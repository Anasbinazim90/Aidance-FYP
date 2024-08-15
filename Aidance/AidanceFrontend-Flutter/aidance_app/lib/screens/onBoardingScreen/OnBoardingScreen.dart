import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/AnimationControllers/IntroImageAnimationController.dart';
import 'package:aidance_app/screens/DonorView/HomeScreenDonor/HomeScreenDonor.dart';
import 'package:aidance_app/screens/onBoardingScreen/ThemeButton.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:icons_plus/icons_plus.dart';

import 'ImageCard.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});

  final animation_controller = Get.put(IntroImagesAnimation());
  @override
  Widget build(BuildContext context) {
    animation_controller.StartAnimaton();
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Color.fromARGB(255, 236, 239, 243)
          backgroundColor: Palette.theme_turquoise[800],
          body: Stack(
            children: [
              Obx(
                () => AnimatedPositioned(
                  duration: Duration(milliseconds: 1400),
                  top: animation_controller.animate.value ? 80.h : 0,
                  left: 50.w,
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                      opacity: animation_controller.animate.value ? 1 : 0,
                      duration: Duration(milliseconds: 1500),
                      child: IntroImages()),
                ),
              ),
              SlideView(),
              GestureDetector(
                onTap: () {
                  Get.offAll(() => RolesScreen());
                },
                child: ThemeIconButton(
                  icon: OctIcons.arrow_right,
                ),
              ),
            ],
          )),
    );
  }

  Align SlideView() {
    return Align(
      alignment: Alignment(0, 1),
      child: Container(
        height: 380.h,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // onboarding text for helping humanity
                'Make an Impact,\nBy helping others',
                style: MyTextStyles.HeadingStyle(),
              ),
              SizedBox(
                height: 19.h,
              ),
              Text(
                'Explore various humanitarian projects and initiatives from around the world. From disaster relief efforts to community development programs, find causes that resonate with your heart.',
                style: MyTextStyles.SecondaryTextStyle(),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.r), topRight: Radius.circular(28.r)),
        ),
      ),
    );
  }

  IntroImages() {
    return Container(
      height: 345.07.h,
      width: 315.02.w,
      decoration: BoxDecoration(
          // color: Colors.blue[900],
          ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageCard(
                  height: 157.75.h, width: 92.12.w, image: AppImages.fire),
              ImageCard(
                height: 157.75.h,
                width: 190.82.w,
                image: AppImages.water,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageCard(
                height: 157.75.h,
                width: 190.82.w,
                image: AppImages.help,
              ),
              ImageCard(
                height: 157.75.h,
                width: 92.12.w,
                image: AppImages.volcano,
              ),
            ],
          )
        ],
      ),
    );
  }
}
