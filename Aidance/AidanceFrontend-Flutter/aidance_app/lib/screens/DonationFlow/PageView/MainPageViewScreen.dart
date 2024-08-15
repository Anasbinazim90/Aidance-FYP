import 'dart:developer';

import 'package:aidance_app/controllers/DonationFlow_controllers/PageView_controllers/PageView_controller.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/PayCryptoController/PayCryptoController.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/DonationFlow/PageView/PageViewWidget.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';

// This is Main Screen Where Stepper functionality is implemented and inside that we are calling apge view widget

class MainPageViewScreen extends StatefulWidget {
  MainPageViewScreen({super.key, this.campaign});

  final NGOCampaignModel? campaign;

  @override
  _MainPageViewScreen createState() => _MainPageViewScreen();
}

class _MainPageViewScreen extends State<MainPageViewScreen> {
  // OPTIONAL: can be set directly.

  // int dotCount = 3;

  final pay_with_crypto_contrllr = Get.put(PayCryptoController());
  final pageviewcontroller = Get.put(PageViewController());

  @override
  void initState() {
    // TODO: implement initState
    if (widget.campaign != null) {
      log(widget.campaign!.title.toString());
    } else {
      log('null');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Palette.theme_turquoise[800],
                    onTap: () {
                      if (pageviewcontroller.activeStep.value == 0) {
                        Get.back();
                      }
                      ;
                      if (pageviewcontroller.activeStep.value > 0) {
                        setState(() {
                          pageviewcontroller.activeStep.value--;
                          pageviewcontroller.pageController.animateToPage(
                              pageviewcontroller.activeStep.value,
                              duration: Duration(microseconds: 5000),
                              curve: Curves.linear);
                        });
                      }
                      pay_with_crypto_contrllr.isChoiceChipSelected.value =
                          false;
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(3),
                      child: SvgPicture.asset(
                        AppImages.Img_arrow_left,
                        width: 26.w,
                        height: 26.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Obx(
                    () => Text(
                      pageviewcontroller.activeStep.value == 0
                          ? 'Donation Information'
                          : pageviewcontroller.activeStep.value == 1
                              ? 'Payment Method'
                              : 'Complete Your Transaction',
                      style: MyTextStyles.HeadingStyle(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Obx(
                () => DotStepper(
                  // direction: Axis.vertical,
                  tappingEnabled: false,
                  dotCount: pageviewcontroller.Dotcount.value,
                  dotRadius: 9,

                  /// THIS MUST BE SET. SEE HOW IT IS CHANGED IN NEXT/PREVIOUS BUTTONS AND JUMP BUTTONS.
                  activeStep: pageviewcontroller.activeStep.value,
                  shape: Shape.circle,
                  spacing: 130,
                  indicator: Indicator.shrink,

                  /// TAPPING WILL NOT FUNCTION PROPERLY WITHOUT THIS PIECE OF CODE.
                  // onDotTapped: (tappedDotIndex) {
                  //   setState(() {
                  //     pageviewcontroller.activeStep.value = tappedDotIndex;
                  //   });
                  // },

                  // DOT-STEPPER DECORATIONS
                  fixedDotDecoration: const FixedDotDecoration(
                    color: myColors.theme_turquoise,
                  ),

                  indicatorDecoration: const IndicatorDecoration(
                    // style: PaintingStyle.stroke,
                    // strokeWidth: 8,
                    color: Colors.white,
                  ),

                  lineConnectorsEnabled: true,
                  lineConnectorDecoration: const LineConnectorDecoration(
                    color: myColors.theme_turquoise,
                    strokeWidth: 3,
                    linePadding: 5,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: PageViewWidget(
                  campaign: widget.campaign,
                ),
              ),

              /// Jump buttons.
              // Padding(padding: const EdgeInsets.all(18.0), child: steps()),

              // Next and Previous buttons.
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [previousButton(), nextButton()],
              // )
            ],
          ),
        ),
      ),
    );
  }

  /// Generates jump steps for dotCount number of steps, and returns them in a row.

  /// Returns the next button widget.
  Widget nextButton() {
    return ElevatedButton(
      child: const Text('Next'),
      onPressed: () {
        /// ACTIVE STEP MUST BE CHECKED FOR (dotCount - 1) AND NOT FOR dotCount To PREVENT Overflow ERROR.
        if (pageviewcontroller.activeStep.value <
            pageviewcontroller.Dotcount.value - 1) {
          setState(() {
            pageviewcontroller.activeStep.value++;
            pageviewcontroller.pageController.animateToPage(
                pageviewcontroller.activeStep.value,
                duration: const Duration(microseconds: 5000),
                curve: Curves.linear);
          });
        }
      },
    );
  }

  /// Returns the previous button widget.
  Widget previousButton() {
    return ElevatedButton(
      child: const Text('Prev'),
      onPressed: () {
        // activeStep MUST BE GREATER THAN 0 TO PREVENT OVERFLOW.
        if (pageviewcontroller.activeStep.value > 0) {
          setState(() {
            pageviewcontroller.activeStep.value--;
            pageviewcontroller.pageController.animateToPage(
                pageviewcontroller.activeStep.value,
                duration: const Duration(microseconds: 5000),
                curve: Curves.linear);
          });
        }
      },
    );
  }
}
