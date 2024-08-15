import 'package:aidance_app/controllers/DaoControllers/DaoBottomScreenController.dart';
import 'package:aidance_app/screens/DaoFlow/DaoBalanceScreen.dart';
import 'package:aidance_app/screens/DaoFlow/DaoHomeScreen.dart';
import 'package:aidance_app/screens/DaoFlow/AddCampaign.dart';
import 'package:aidance_app/screens/DaoFlow/CampaignListScreen.dart';
import 'package:aidance_app/screens/DaoFlow/NgoApprovalScreen.dart';
import 'package:aidance_app/screens/DaoFlow/NgoVotingScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DaoBottomBar extends StatefulWidget {
  final String? address;
  DaoBottomBar({super.key, this.address});

  @override
  State<DaoBottomBar> createState() => _DaoBottomBarState();
}

class _DaoBottomBarState extends State<DaoBottomBar> {
  // final _daoBottomBarController = Get.put(DaoBottomBarController());
  final _daoBottomBarController = Get.put(DaoBottomBarController());

  final _pageController = Get.put(PageController(initialPage: 0));

  final _bottomBarController = Get.put(ScrollController());
  // New ScrollController

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose(); // Dispose PageController
    _bottomBarController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // a add button for adding own campaing
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.theme_turquoise,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        elevation: 2.0,
        onPressed: () {
          Get.to(() => const AddCampaignScreen());
        },
        child: const Icon(
          Icons.add,
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 75.h,
        child: Container(
          child: Obx(
            () => BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _daoBottomBarController.selectedIndex.value,
              selectedItemColor: myColors.theme_turquoise,
              unselectedItemColor: myColors.themeGreyColor,
              onTap: (index) {
                _daoBottomBarController.selectedIndex.value = index;
                _pageController.jumpToPage(index);
              },
              items: [
                // home Icon
                BottomNavigationBarItem(
                  icon: _daoBottomBarController.selectedIndex.value == 0
                      ? Icon(
                          Icons.home,
                          size: 32.sp,
                        )
                      : Icon(
                          Icons.home_outlined,
                        ),
                  label: '',
                ),

                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: _daoBottomBarController.selectedIndex.value == 1
                        ? Icon(
                            Icons.search,
                            size: 32.sp,
                          )
                        : Icon(
                            Icons.search_outlined,
                          ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: _daoBottomBarController.selectedIndex.value == 2
                        ? Icon(Icons.pending_actions_outlined, size: 32.sp)
                        : Icon(Icons.pending_actions_rounded),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: _daoBottomBarController.selectedIndex.value == 3
                      ? Icon(Icons.person_2, size: 32.sp)
                      : Icon(Icons.person_2_outlined),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
          onPageChanged: (value) {
            _daoBottomBarController.selectedIndex.value = value;
          },
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DaoHomeScreen(),
            CampaignListScreen(),

           
            NgoApprovalScreen(),
            DaoBalanceScreen()
            // Center(
            //   child: Text(
            //     'Profile ',
            //   ),
            // ),
          ]),
    );
  }
}
