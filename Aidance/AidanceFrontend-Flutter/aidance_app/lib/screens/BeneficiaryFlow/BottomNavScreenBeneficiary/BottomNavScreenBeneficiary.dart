import 'package:aidance_app/controllers/BeneficiaryControllers/BottomNavControllerBeneficiary/BottomNavControllerBeneficiary.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BottomNavScreenBeneficiary extends StatelessWidget {
  BottomNavScreenBeneficiary({super.key});

  final bottom_nav_controller_enduser = Get.put(BottomNavControllerEndUser());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        notchMargin: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _bottomAppBarItem(
                //   icon: Icons.home,
                //   page: 0,
                //   context,
                //   label: "Home",
                // ),
                _bottomAppBarItem(
                    icon: Icons.wallet, page: 0, context, label: "Vouchers"),
                _bottomAppBarItem(
                    icon: Icons.person, page: 1, context, label: "Profile"),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: bottom_nav_controller_enduser.pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: bottom_nav_controller_enduser.animateToTab,
        children: [...bottom_nav_controller_enduser.pages],
      ),
    );
  }

  Widget _bottomAppBarItem(BuildContext context,
      {required icon, required page, required label}) {
    return ZoomTapAnimation(
      onTap: () => bottom_nav_controller_enduser.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: bottom_nav_controller_enduser.currentPage == page
                  ? myColors.theme_turquoise
                  : Colors.grey,
              size: 20,
            ),
            Text(
              label,
              style: TextStyle(
                  color: bottom_nav_controller_enduser.currentPage == page
                      ? myColors.theme_turquoise
                      : Colors.grey,
                  fontSize: 13,
                  fontWeight: bottom_nav_controller_enduser.currentPage == page
                      ? FontWeight.w600
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
