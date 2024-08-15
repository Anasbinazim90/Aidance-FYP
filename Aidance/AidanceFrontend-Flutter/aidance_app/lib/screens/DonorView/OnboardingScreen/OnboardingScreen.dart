import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DonorView/OnboardingScreen/ContentModel.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value == contents.length - 1) {
      // Get.off(Home());
      Get.offAllNamed(AppRoutes.bottomNavBarScreenDonor);
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linearToEaseOut,
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = OnboardingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: contents.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        contents[i].image,
                        height: 300,
                      ),
                      Text(
                        contents[i].title,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60.h,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColorLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                side: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),

              child: Text(
                  controller.currentIndex.value == contents.length - 1
                      ? "Continue"
                      : "Next",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w200,
                    color: myColors.whiteColor,
                  )),
              onPressed: controller.nextPage,
              // color: Theme.of(context).primaryColor,
              // textColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20),
              // ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Obx(
        () => Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: controller.currentIndex.value == index
                ? Theme.of(context).primaryColorLight
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
