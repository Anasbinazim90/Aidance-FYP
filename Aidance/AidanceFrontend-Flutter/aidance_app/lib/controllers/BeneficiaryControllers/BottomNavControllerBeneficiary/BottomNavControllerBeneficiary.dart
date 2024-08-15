import 'package:aidance_app/controllers/EndUserModelController.dart';
import 'package:aidance_app/models/BeneficiaryModel/BeneficiaryModel.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/NgoCardBeneficiary/HomeScreenBeneificary.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/ProfileScreenBeneficiary/ProfileScreenBeneficiary.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/VoucherScreenBeneficiary/VoucherScreenBeneficiary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavControllerEndUser extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;
  RxBool isDarkTheme = false.obs;

  List<Widget> pages = [
    // HomeScreenBeneficary(),
    VoucherScreen(),
    ProfileScreenBeneficiary(),
  ];

  ThemeMode get theme => Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
