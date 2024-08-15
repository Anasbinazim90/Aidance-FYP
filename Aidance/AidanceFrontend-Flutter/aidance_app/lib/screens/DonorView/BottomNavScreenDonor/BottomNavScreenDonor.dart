import 'package:aidance_app/controllers/DonorViewController/bottom_navbar_donor_controller.dart';
import 'package:aidance_app/controllers/NgoControllers/BottomNavControllerNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BottomNavBarScreenDonor extends StatelessWidget {
  BottomNavBarScreenDonor({super.key});

  final bottom_nav_controller_donor = Get.put(BottomNavControllerDonor());

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
                _bottomAppBarItem(
                  icon: Icons.home,
                  page: 0,
                  context,
                  label: "Search",
                ),
                _bottomAppBarItem(
                    icon: Icons.add_alert_sharp,
                    page: 1,
                    context,
                    label: "Home"),
                _bottomAppBarItem(
                    icon: Icons.add, page: 2, context, label: "Create"),
                _bottomAppBarItem(
                    icon: Icons.person, page: 3, context, label: "Profile"),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: bottom_nav_controller_donor.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: bottom_nav_controller_donor.animateToTab,
        children: bottom_nav_controller_donor.pages,
      ),
      // body: Obx(() {
      //   return IndexedStack(
      //     index: bottom_nav_controller_donor.currentPage.value,
      //     children: bottom_nav_controller_donor.pages,
      //   );
      // }),
    );
  }

  Widget _bottomAppBarItem(BuildContext context,
      {required IconData icon, required int page, required String label}) {
    return ZoomTapAnimation(
      onTap: () => bottom_nav_controller_donor.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: bottom_nav_controller_donor.currentPage.value == page
                  ? myColors.theme_turquoise
                  : Colors.grey,
              size: 20,
            ),
            Text(
              label,
              style: TextStyle(
                  color: bottom_nav_controller_donor.currentPage.value == page
                      ? myColors.theme_turquoise
                      : Colors.grey,
                  fontSize: 13,
                  fontWeight:
                      bottom_nav_controller_donor.currentPage.value == page
                          ? FontWeight.w600
                          : null),
            ),
          ],
        ),
      ),
    );
  }
}
