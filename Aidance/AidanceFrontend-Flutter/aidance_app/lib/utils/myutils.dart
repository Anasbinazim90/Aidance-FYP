import 'package:aidance_app/screens/NgoFlow/BottomNavScreenNgo/BottomNavScreenNgo.dart';
import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/MyCampaignsNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// String? ipfsHash;

extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r'^.{0,7}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    // ignore: unrelated_type_equality_checks
    return this != 0;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r'^.{0,14}$');
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidRef {
    final refRegExp = RegExp(r'^\d{1,6}$');
    return refRegExp.hasMatch(this);
  }
}

class Utils {
  static void CustomErrorSnackBar(
      BuildContext context, String message, String submessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(bottom: 20),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          height: 100.h,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade700
                ], // Define your gradient colors.
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20.r)),
          child: Row(
            children: [
              SizedBox(
                width: 50.w,
              ),
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: MyTextStyles.HeadingStyle()
                          .copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                    Text(
                      submessage,
                      style: MyTextStyles.SecondaryTextStyle()
                          .copyWith(color: Colors.white, fontSize: 12.sp),
                      // maxLines: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void CustomSuccessSnackBar(
      BuildContext context, String message, String submessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(bottom: 20),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(16),
        height: 100.h,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade400,
                Colors.green.shade700
              ], // Define your gradient colors.
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20.r)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/checked(1).png',
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: MyTextStyles.HeadingStyle()
                        .copyWith(color: Colors.white, fontSize: 18.sp),
                  ),
                  Text(
                    submessage,
                    style: MyTextStyles.SecondaryTextStyle()
                        .copyWith(color: Colors.white, fontSize: 12.sp),
                    // maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  static DialgBox(BuildContext context, text, String s) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
        );
      },
    );
  }

  /// Exit App on Double tap
  static Future<bool> onWillPop() {
    DateTime? currentBackPressTime;
    DateTime now = DateTime.now();
    // ignore: unnecessary_null_comparison
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      // G(message: "Press double tap to exit",snackPosition: SnackPosition.TOP,);
      Get.snackbar(
        'Message',
        'Double Tap to Exit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  static CustomCheckBox(vvalue, Function() ontap) {
    return Transform.scale(
      scale: 0.7,
      child: Checkbox(
        value: vvalue,
        // enable: true,
        // color: myColors.theme_turquoise,
        onChanged: (value) {
          ontap();
        },
      ),
    );
  }

  static CustomCheckBoxWithText(String text, vvalue, Function() ontap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Utils.CustomCheckBox(vvalue, ontap),
        SizedBox(width: 1.w),
        Text(
          text,
          style: MyTextStyles.SecondaryTextStyle().copyWith(fontSize: 13.sp),
        )
      ],
    );
  }

  String shortenAddress(String fullAddress,
      {int firstChars = 6, int lastChars = 4}) {
    if (fullAddress.length <= (firstChars + lastChars)) {
      return fullAddress; // Return full address if it's already short
    }

    String start = fullAddress.substring(0, firstChars);
    String end = fullAddress.substring(fullAddress.length - lastChars);

    return '$start...$end';
  }

  static showAlertAndNavigateGeneral(
    BuildContext context,
    isLoader,
    String heading,
    String subtitle,
    dynamic Icon,
  ) {
    // alertDialogue(
    //   context,
    //   "Voucher Sent!",
    //   "Your voucher for ${voucherAmount} has been sent successfully. You will be redirected to the home screen in 2 seconds.",
    //   AppImages.alertIcon,
    // );

    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.pop(context);
    // });

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // barrierColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
          ),
          // contentPadding: const EdgeInsets.all(15),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          // shadowColor: Colors.white,
          actions: [
            Container(
              // padding: const EdgeInsets.all(15),
              height: 321.h,
              width: 318.w,
              decoration: BoxDecoration(
                color: Colors.white,
                backgroundBlendMode: BlendMode.darken,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  30.h.verticalSpace,
                  isLoader
                      ? SizedBox(height: 84.h, width: 84.w, child: Icon)
                      : SizedBox(
                          height: 84.h,
                          width: 84.w,
                          child: SvgPicture.asset(
                            Icon,
                            color: myColors.theme_turquoise,
                            fit: BoxFit.fitHeight,
                          )),
                  16.h.verticalSpace,
                  Text(heading,
                      textAlign: TextAlign.center,
                      style: MyTextStyles.HeadingStyle()
                          .copyWith(color: myColors.theme_turquoise)),
                  16.h.verticalSpace,
                  Text(subtitle,
                      textAlign: TextAlign.center,
                      style: MyTextStyles.SecondaryTextStyle()),
                  0.024.sh.verticalSpace,
                ],
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(
                  0.0, -0.1), // Start just above the final position
              end: Offset.zero, // End at the final position
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          ),
        );
      },
    );
  }
}
