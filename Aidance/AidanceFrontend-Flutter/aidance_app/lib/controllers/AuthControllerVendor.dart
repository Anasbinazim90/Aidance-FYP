import 'dart:developer';

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/vendorFlow/vendor_bottom_nav_screen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import Get Storage

class AuthControlleVendor extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Rxn<User> _firebaseUser = Rxn<User>();

  String? get user => _firebaseUser.value?.email;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    print(" Auth Change :   ${_auth.currentUser}");
  }

  createUser(String username, String email, String password,
      String confirmpassword, String address, context) async {
    log("email" + email.toString());
    log("email" + password.toString());

    // Retrieve stored code from Get Storage

    try {
      isLoading(true);
      showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) => Center(
                  child: SpinKitWaveSpinner(
                waveColor: myColors.theme_turquoise,
                trackColor: myColors.theme_turquoise.withOpacity(0.5),
                color: myColors.theme_turquoise,
              )));
      // check if the confrim pass and pass matches or not

      if (password != confirmpassword) {
        Get.snackbar("Password do not match !",
            "Password and Confirm Password donot match !",
            snackPosition: SnackPosition.TOP);
        isLoading(false);
        Get.back();
        return;
      }

      log('Creating user');

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        log('saving user to firebase');
        await _firestore.collection('vendors').doc(user.uid).set({
          'username': username,
          'email': email,
          'address': address,
          'createdAt': FieldValue.serverTimestamp(),
        });
        log('Data Saved');
        Get.back();

        Get.offAll(() => BottomNavScreenVendor());
        Get.snackbar(
          "Account Created Successfully!",
          "Successfully Logged In!",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      log("email" + email.toString());
      log("email" + password.toString());
      log('erorrrr codeee ${e.code}');
      log('erorrrr messagge ${e.message}');
      Get.snackbar(
        "Error!",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void login(String email, String password) async {
    try {
      isLoading(true);
      showDialog(
          barrierColor: Colors.transparent,
          context: Get.context!,
          builder: (context) => Center(
                  child: SpinKitWaveSpinner(
                waveColor: myColors.theme_turquoise,
                trackColor: myColors.theme_turquoise.withOpacity(0.5),
                color: myColors.theme_turquoise,
              )));

      // Check if the user email is present in Firestore
      QuerySnapshot userSnapshot = await _firestore
          .collection('vendors')
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

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.back();
        Get.offAll(() => BottomNavScreenVendor());
        Get.snackbar(
          "Log In!",
          "Successfully Logged In!",
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
      log("email" + email.toString());
      log("email" + password.toString());
      log('erorrrr codeee ${e.code}');
      log('erorrrr messagge ${e.message}');
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
      log('erorrrr codeee ${e.code}');
      log('erorrrr messagge ${e.message}');
      Get.snackbar(
        "Error!",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
