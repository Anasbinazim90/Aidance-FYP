import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NgoSignupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController missionController = TextEditingController();

  RxBool isNameValid = true.obs;
  RxBool isRegistrationNumberValid = true.obs;
  RxBool isAddressValid = true.obs;
  RxBool isPhoneValid = true.obs;
  RxBool isEmailValid = true.obs;
  RxBool isMissionValid = true.obs;

  RxBool formIsValid = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validateForm() {
    formIsValid.value = isNameValid.value &&
        isRegistrationNumberValid.value &&
        isAddressValid.value &&
        isPhoneValid.value &&
        isEmailValid.value &&
        isMissionValid.value;
  }
}