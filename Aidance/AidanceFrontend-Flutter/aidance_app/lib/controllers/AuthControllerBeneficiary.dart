import 'dart:developer';

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import Get Storage

class AuthControllerBeneficiary extends GetxController {
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

  createUser(
      String username,
      String email,
      String password,
      String ngonumber,
      String address,
      String benificiarycode,
      String campaignId,
      context) async {
    log("email" + email.toString());
    log("email" + password.toString());

    // Retrieve stored code from Get Storage
    final box = GetStorage();
    String? storedCode = box.read('generatedCode');

    if (storedCode != null && storedCode == benificiarycode) {
      try {
        isLoading.value = true;
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) => Center(
                    child: SpinKitWaveSpinner(
                  waveColor: myColors.theme_turquoise,
                  trackColor: myColors.theme_turquoise.withOpacity(0.5),
                  color: myColors.theme_turquoise,
                )));

        // check campaign id is in the firestore and also the ngonumber is same as presented in that campaign document
        // Check if the campaign ID and NGO number match a document in Firestore
        var campaignQuery = await _firestore
            .collection('campaigns')
            .where('tokenId', isEqualTo: campaignId)
            .where('registrationID', isEqualTo: ngonumber)
            .limit(1)
            .get();

        if (campaignQuery.docs.isEmpty) {
          log('Campaign ID and Went number do not match');
          // Campaign ID and NGO number do not match
          Get.back();
          Get.snackbar(
            "Error!",
            "Invalid campaign ID or NGO number!",
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading(false);
          return;
        }

        log('checking the beneficiares limit');

        var campaignDoc = campaignQuery.docs.first;
        List<dynamic> beneficiaries =
            campaignDoc.data().containsKey('beneficiaries')
                ? campaignDoc['beneficiaries']
                : [];
        int totalBeneficiariesLimit =
            int.parse(campaignDoc['total_no_of_beneficiaries']);
        try {
          log('length of beneficiaries: ${beneficiaries.length}');
          if (beneficiaries.length == totalBeneficiariesLimit) {
            Get.back();
            // Beneficiary limit reached
            Get.snackbar(
              "Limit Reached!",
              "The beneficiary limit for this campaign has been reached!",
              snackPosition: SnackPosition.BOTTOM,
            );

            isLoading(false);
            return;
          }
        } catch (e) {
          log("Error: $e");
        }

        log('Creating user');

        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        if (user != null) {
          // Generate a unique ID for the beneficiary
          String beneficiaryId =
              _firestore.collection('benificiaryUsers').doc().id;
          await _firestore.collection('benificiaryUsers').doc(user.uid).set({
            'id': beneficiaryId,
            'username': username,
            'email': email,
            'ngono': ngonumber,
            'campaignId': campaignId,
            'address': address,
            'benificiarycode': benificiarycode,
            'createdAt': FieldValue.serverTimestamp(),
          });
          // Update the respective NGO document
          await _firestore
              .collection('campaigns')
              .where('tokenId', isEqualTo: campaignId)
              .limit(1)
              .get()
              .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              var ngoDoc = querySnapshot.docs.first;
              _firestore.collection('campaigns').doc(ngoDoc.id).update({
                'beneficiaries': FieldValue.arrayUnion([
                  {
                    'id': beneficiaryId,
                    'username': username,
                    'email': email,
                    'address': address,
                    'benificiarycode': benificiarycode,
                    'ngono': ngonumber,
                    'voucher': '0',
                  }
                ])
              });
            } else {
              log('NGO not found');
            }
          });
          Get.back();

          Get.offAllNamed(AppRoutes.bottomNavScreenBeneficiary);
          Get.snackbar(
            "Account Created Successfully!",
            "Successfully Logged In!",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } on FirebaseAuthException catch (e) {
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
    } else {
      Get.snackbar(
        "Error!",
        "Beneficiary code does not matchh!",
        snackPosition: SnackPosition.BOTTOM,
      );
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
          .collection('benificiaryUsers')
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
        Get.offAllNamed(AppRoutes.bottomNavScreenBeneficiary);
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
