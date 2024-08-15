import 'dart:developer';

import 'package:aidance_app/controllers/DonationFlow_controllers/PageView_controllers/PageView_controller.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/donation_data_controller.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Name Field Controller

class FieldController extends GetxController {
  Rx<FocusNode> namefocus = FocusNode().obs;
  Rx<FocusNode> emailfocus = FocusNode().obs;
  Rx<FocusNode> msgfocus = FocusNode().obs;
  Rx<FocusNode> DropDownfocus = FocusNode().obs;

  // ObscureText
  RxBool isHidden = true.obs;

  // SignInWith
  RxBool istaplogo = true.obs;

  ontapLogo() {
    istaplogo.value = false;
  }

  UnFocusFields() {
    namefocus.value.unfocus();
    emailfocus.value.unfocus();
    msgfocus.value.unfocus();
    DropDownfocus.value.unfocus();
  }

  toggleHiddenText() {
    isHidden.value = !isHidden.value;
  }
}

class CheckBoxController extends GetxController {
  // name checkbox
  final donationDataController = Get.put(DonationFlowController());
  RxBool name_checkboxSelected = false.obs;

  // Email Checkbox
  RxBool email_checkboxSelected = false.obs;

  ontap_Email() {
    return email_checkboxSelected.value = !email_checkboxSelected.value;
  }
}

class SourceOfFundsController extends GetxController {
  final fieldController = Get.put(FieldController());
  final sourceofFunds_value_contrllr = TextEditingController();
  RxInt currentIndex = (-1).obs;
  RxBool istap = false.obs;
  RxBool isTextFieldEnabled = true.obs;

  List<String> SourceOfFunds = [
    'Salary',
    'Company Profit',
    'Savings',
    'Shares or Investements',
    'Sales of Property',
    'Gift'
  ].obs;

  List<String> SourceOfFundsIcon = [
    AppImages.salary,
    AppImages.comp_profit,
    AppImages.savings,
    AppImages.investment,
    AppImages.sales,
    AppImages.giftbox,
  ].obs;

  List<double> arr_width = [
    63.w,
    100.w,
    110.w,
    150.w,
    180.w,
    110.w,
    140.w,
    130.w,
  ].obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void setValue(int index) {
    sourceofFunds_value_contrllr.text = SourceOfFunds[index];
  }

  void istappedListTile() {
    istap.value = true;
  }

  void Unfoucs_DropDown() {
    fieldController.DropDownfocus.value.unfocus();
  }
}

class MainButtonController extends GetxController {
  // PageView Logic to navigate donation flow screen
  final pageviewcontroller = Get.find<PageViewController>();

  mainButtonTapped() {
    if (pageviewcontroller.activeStep.value <
        pageviewcontroller.Dotcount.value - 1) {
      pageviewcontroller.activeStep.value++;

      pageviewcontroller.pageController.animateToPage(
          pageviewcontroller.activeStep.value,
          duration: const Duration(microseconds: 5000),
          curve: Curves.linear);
    }
  }
}
