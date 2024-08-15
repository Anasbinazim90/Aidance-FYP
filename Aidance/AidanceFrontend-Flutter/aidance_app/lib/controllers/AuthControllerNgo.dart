import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DaoFlow/DaoBottomBar.dart';
import 'package:aidance_app/screens/DaoFlow/NgoApprovalScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthControllerNgo extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  // GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  Rxn<User> _firebaseUser = Rxn<User>();

  String? get user => _firebaseUser.value?.email;
//  String get imageurl =>_firebaseUser.value?.photoURL;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    print(" Auth Change :   ${_auth.currentUser}");
  }

  // function to create user, login, and sign out user

  Future<void> createUser(
    context,
    String email,
    String phone,
    String password,
    String username,
    String ngono,
    String address,
    String mission,
    List<PlatformFile> selectedFileList,
  ) async {
    try {
      isLoading.value = true;

      // Check if ngono already exists
      bool ngonoExists = await checkNgonoExists(ngono);
      if (ngonoExists) {
        isLoading.value = false;
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            isDismissible: true,
            icon: Icon(Icons.error),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            'Error !',
            'Registration number already exists. Please use a different one.');
        return;
      }

      //check if kyc is null
      if (selectedFileList.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
            snackStyle: SnackStyle.FLOATING,
            isDismissible: true,
            icon: Icon(Icons.error),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            'Error !',
            'Please upload your KYC documents.');
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('User created: ${userCredential.user?.uid}');

      User? user = userCredential.user;
      if (user != null) {
        List<Map<String, String>> kycdocs =
            await uploadFiles(user.uid, selectedFileList);
        await _firestore.collection('Ngousers').doc(user.uid).set({
          'username': username,
          'email': email,
          'ngono': ngono,
          'mission': mission,
          'address': address,
          'kycdocs': kycdocs,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.offAllNamed(AppRoutes.bottomNavScreenNgo);
        Get.snackbar(
          snackStyle: SnackStyle.FLOATING,
          isDismissible: true,
          icon: Icon(Icons.check),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          "Account Created Successfully!",
          "Successfully Logged In!",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
          snackStyle: SnackStyle.FLOATING,
          isDismissible: true,
          icon: Icon(Icons.error),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          'Error',
          e.message ?? 'Signup failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkNgonoExists(String ngono) async {
    final querySnapshot = await _firestore
        .collection('Ngousers')
        .where('ngono', isEqualTo: ngono)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<List<Map<String, String>>> uploadFiles(
      String uid, List<PlatformFile> files) async {
    List<Map<String, String>> downloadUrls = [];
    for (var file in files) {
      String downloadUrl = await uploadFile(uid, file);
      downloadUrls.add({'name': file.name, 'url': downloadUrl});
    }
    return downloadUrls;
  }

  Future<String> uploadFile(String uid, PlatformFile file) async {
    String downloadUrl = '';
    try {
      String fileName = file.name;
      File fileToUpload = File(file.path!);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('$uid/kyc_docs/$timestamp-$fileName')
          .putFile(fileToUpload);

      if (snapshot.state == TaskState.success) {
        downloadUrl = await snapshot.ref.getDownloadURL();
      } else {
        Get.snackbar("Error", "File upload failed.");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
    return downloadUrl;
  }

  login(String email, String password) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading(true);
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return Center(
            child: SpinKitWaveSpinner(
              waveColor: myColors.theme_turquoise,
              trackColor: myColors.theme_turquoise.withOpacity(0.5),
              color: myColors.theme_turquoise,
            ),
          );
        },
      );

      // Check if the user email is present in Firestore
      QuerySnapshot userSnapshot = await _firestore
          .collection('Ngousers')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isEmpty) {
        Get.back();
        // No user found with the provided email
        Get.snackbar(
          backgroundColor: Colors.red,
          colorText: Colors.white,
          "Error!",
          "You are not registered. Please sign up.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.back();
      Get.toNamed(AppRoutes.bottomNavScreenNgo);
      Get.snackbar(
        "Log In!",
        "Successfully Logged In!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.back();
      log("email" + email.toString());
      log("email" + password.toString());
      log('error code ${e.code}');
      log('error message ${e.message}');
      Get.snackbar(
        "Error!",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void signout() async {
    try {
      await _auth.signOut().then((value) {
        Get.snackbar(
          "Sign Out!",
          "Signed Out Successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } on FirebaseAuthException catch (e) {
      log('error code ${e.code}');
      log('error message ${e.message}');
      Get.snackbar(
        "Error!",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      isLoading(true);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in process
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      // Now you can navigate to the home screen or perform other actions
      Get.offAll(NgoApprovalScreen());
    } catch (e) {
      print("Error during Google sign-in: $e");
    } finally {
      isLoading(false);
    }
  }

  void google_signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
