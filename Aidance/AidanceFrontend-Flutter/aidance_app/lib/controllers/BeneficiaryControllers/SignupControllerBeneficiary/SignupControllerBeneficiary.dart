// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UsernameController extends GetxController {
//   RxString usernameError = RxString('');

//   void validateUsername(String username) {
//     if (username.isEmpty) {
//       usernameError.value = 'Username is required';
//     } else if (username.length < 4) {
//       usernameError.value = 'Username must be at least 4 characters';
//     } else {
//       usernameError.value = '';
//     }
//   }
// }

// class PhoneNumberController extends GetxController {
//   RxString phoneNumberError = RxString('');
//   TextEditingController phoneNumberController = TextEditingController();

//   void validatePhoneNumber(String phoneNumber) {
//     // Add your phone number validation logic here
//     // For example, you can check if it's a valid phone number format
//     // In this example, I'm just checking if it's not empty
//     if (phoneNumber.isEmpty) {
//       phoneNumberError.value = 'Phone number is required';
//     } else {
//       phoneNumberError.value = '';
//     }
//   }
// }

// class CNICNumberController extends GetxController {
//   RxString cnicNumberError = RxString('');
//   TextEditingController cnicNumberController = TextEditingController();

//   void validateCNICNumber(String cnicNumber) {
//     // Add your CNIC number validation logic here
//     // For example, you can check if it's a valid CNIC number format
//     // In this example, I'm just checking if it's not empty
//     if (cnicNumber.isEmpty) {
//       cnicNumberError.value = 'CNIC number is required';
//     } else {
//       cnicNumberError.value = '';
//     }
//   }
// }

// class ReferenceNumberController extends GetxController {
//   RxString referenceNumberError = RxString('');
//   TextEditingController referenceNumberController = TextEditingController();

//   void validateReferenceNumber(String referenceNumber) {
//     // Add your reference number validation logic here
//     // For example, you can check if it meets specific criteria
//     // In this example, I'm just checking if it's not empty
//     if (referenceNumber.isEmpty) {
//       referenceNumberError.value = 'Reference number is required';
//     } else {
//       referenceNumberError.value = '';
//     }
//   }
// }

// class PasswordController extends GetxController {
//   RxString passwordError = RxString('');
//   TextEditingController passwordController = TextEditingController();

//   void validatePassword(String password) {
//     // Add your password validation logic here
//     // For example, you can check if it meets specific criteria
//     // In this example, I'm just checking if it's at least 6 characters long
//     if (password.length < 6) {
//       passwordError.value = 'Password must be at least 6 characters';
//     } else {
//       passwordError.value = '';
//     }
//   }
// }

// class ConfirmPasswordController extends GetxController {
//   RxString confirmPasswordError = RxString('');
//   TextEditingController confirmPasswordController = TextEditingController();

//   void validateConfirmPassword(String confirmPassword) {
//     // Add your confirm password validation logic here
//     // For example, you can check if it matches the original password
//     // In this example, I'm assuming there's a PasswordController to get the original password
//     String originalPassword =
//         Get.find<PasswordController>().passwordController.text;

//     if (confirmPassword.isEmpty) {
//       confirmPasswordError.value = 'Confirm password is required';
//     } else if (confirmPassword != originalPassword) {
//       confirmPasswordError.value = 'Passwords do not match';
//     } else {
//       confirmPasswordError.value = '';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupControllerEnduser extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cnicNumberController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void signUp() {
    // Add your signup logic here
    // You can access the controllers' values like this:
    print(usernameController.text);
    print(phoneNumberController.text);
    // Add more fields as needed
  }
}

class LoginControllerEnduser extends GetxController {
  TextEditingController cnicNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() {
    // Add your login logic here
    // You can access the controllers' values like this:
    print(cnicNumberController.text);
    print(passwordController.text);
  }
}
