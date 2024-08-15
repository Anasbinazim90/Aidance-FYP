// import 'dart:developer';

// import 'package:aidance_app/screens/NgoFlow/CreateCampaignNgo/CreateCampaignNgo.dart';
// import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/MyCampaignsNgo.dart';
// import 'package:aidance_app/screens/NgoFlow/RequestScreenNgo/BeneficiaryListScreen.dart';
// import 'package:aidance_app/controllers/NgoControllers/ngo_profile_screen.dart';
// import 'package:aidance_app/utils/myutils.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BottomNavControllerNgo extends GetxController {
//   late PageController pageController;

//   RxInt currentPage = 0.obs;

//   final List<Widget> pages = [
//     MyCompaignScreen(),
//     // BeneficiaryListScreen(),

//     CreateCompaignScreen(),
//     NgoProfileScreen(),
//   ];

//   Future<bool> checkUserRegistrationStatus() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     log(user!.email.toString());
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Ngousers')
//         .doc(user.uid)
//         .get();
//     // check if the status is pending or active
//     if (snapshot.exists) {
//       String status = snapshot['status'];
//       if (status == 'pending') {
//         return false;
//       } else if (status == 'active') {
//         return true;
//       }
//     }
//     return false;
//   }

//   void goToTab(int page) async {
//     if (page == 2) {
//       bool isRegistered = await checkUserRegistrationStatus();
//       if (!isRegistered) {
//         Get.dialog(
//           AlertDialog(
//             backgroundColor: Colors.white,
//             title: Text('Registration Pending'),
//             content:
//                 Text('You are not registered yet. Please wait for approval.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//         // Utils.showAlertAndNavigateGeneral(
//         //     Get.context!,
//         //     true,
//         //     'Registration Pending',
//         //     'You are not registered yet. Please wait for approval.',
//         //     Icon(Icons.watch_later_outlined));
//         return;
//       }
//     }
//     currentPage.value = page;
//     pageController.jumpToPage(page);
//   }

//   void animateToTab(int page) {
//     currentPage.value = page;
//     pageController.animateToPage(page,
//         duration: const Duration(milliseconds: 300), curve: Curves.ease);
//   }

//   @override
//   void onInit() {
//     pageController = PageController(initialPage: 0);
//     super.onInit();
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }
// }

import 'dart:developer';

import 'package:aidance_app/controllers/NgoControllers/ngo_profile_screen.dart';
import 'package:aidance_app/screens/NgoFlow/CreateCampaignNgo/CreateCampaignNgo.dart';
import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/MyCampaignsNgo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavControllerNgo extends GetxController {
  late PageController pageController;

  RxInt currentPage = 0.obs;

  final List<Widget> pages = [
    MyCompaignScreen(),
    CreateCompaignScreen(),
    NgoProfileScreen(),
  ];

  Future<bool> checkUserRegistrationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    log(user!.email.toString());
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Ngousers')
        .doc(user.uid)
        .get();
    if (snapshot.exists) {
      String status = snapshot['status'];
      if (status == 'pending') {
        return false;
      } else if (status == 'active') {
        return true;
      }
    }
    return false;
  }

  void goToTab(int page) async {
    if (page == 1) {
      bool isRegistered = await checkUserRegistrationStatus();
      if (!isRegistered) {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Registration Pending'),
            content:
                Text('You are not registered yet. Please wait for approval.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    }
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
