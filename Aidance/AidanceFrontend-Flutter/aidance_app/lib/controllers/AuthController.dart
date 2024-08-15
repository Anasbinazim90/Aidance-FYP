import 'dart:developer';

import 'package:aidance_app/controllers/DonorViewController/BottomNavControllerDonor/BottomNavControllerDonor.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DaoFlow/DaoHomeScreen.dart';
import 'package:aidance_app/screens/RegisterationScreens/RegisterationScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final controller = Get.put(BottomNavControllerUser());
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
    String email,
    String password,
    String confirmpassword,
    String username,
    String ngono,
    String address,
  ) async {
    try {
      isLoading.value = true;

      // check if the pass and confirm password donot match

      if (password != confirmpassword) {
        Get.snackbar(
          "Password do not match !",
          "Password and Confirm Password donot match !",
        );
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'ngono': ngono,
          'address': address,
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.offAllNamed(AppRoutes.bottomNavBarScreenDonor);
        Get.snackbar(
          "Account Created Successfully!",
          "Successfully Logged In!",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Signup failed');
    } finally {
      isLoading.value = false;
    }
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
          .collection('users')
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
      Get.toNamed(AppRoutes.bottomNavBarScreenDonor);
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
      Get.offAll(DaoHomeScreen());
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
