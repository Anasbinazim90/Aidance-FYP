import 'dart:developer';

import 'package:aidance_app/screens/DonorView/HomeScreenDonor/HomeScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/NotificationScreenDonor/NotificationScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/ProfileScreenDonor/ProfileScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/SearchScreenDonor/SearchScreenDonor.dart';
import 'package:aidance_app/screens/NgoFlow/CreateCampaignNgo/CreateCampaignNgo.dart';
import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/MyCampaignsNgo.dart';
// import 'package:aidance_app/screens/NgoFlow/RequestScreenNgo/RequestScreenNgo.dart';
import 'package:aidance_app/controllers/NgoControllers/ngo_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavControllerUser extends GetxController {
  late PageController pageController;

  RxInt currentPage = 0.obs;

  final pages = [
    // HomeScreen(),
    SearchScreen(),
    HomeScreen(),
    MyDonationScreen(),
    ProfileScreenUser(),
  ];

  void goToTab(int page) async {
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
