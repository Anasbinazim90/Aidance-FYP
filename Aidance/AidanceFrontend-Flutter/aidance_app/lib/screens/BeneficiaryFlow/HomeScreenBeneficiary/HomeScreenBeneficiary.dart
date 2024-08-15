import 'dart:ui';

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/components/mainbutton.dart';
import 'package:aidance_app/controllers/AuthControllerBeneficiary.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// class HomeScreenEndUser extends StatelessWidget {
//   final RequestController requestController = Get.put(RequestController());
//   HomeScreenEndUser({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return NGO_Card_EndUser(requestController: requestController);
//   }
// }

class HomeScreenEndUser extends StatelessWidget {
  final TextEditingController referenceController = TextEditingController();
  final _controller = Get.put(AuthControllerBeneficiary());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        scrolledUnderElevation: 0.1,
        title: Text('Hello, User!', style: MyTextStyles.HeadingStyle()),
        actions: [
          TextButton(
            onPressed: () {
              // Get.toNamed(AppRoutes.profileScreenEndUser);
            },
            child: Container(
              width: 50.w,
              height: 120.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Icon(Icons.person, color: Colors.black, size: 30.sp),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _showDialog(context);
              },
              child: Container(
                width: 150.w,
                height: 150.h,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: myColors.themeGreyColor.withOpacity(0.4),
                      width: 6),
                ),
                child: Icon(Icons.add,
                    color: myColors.themeGreyColor.withOpacity(0.4),
                    size: 100.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Text('Tap to add NGO',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontSize: 16.sp,
                  color: myColors.themeGreyColor,
                )),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Enter Credentials',
      content: Column(
        children: [
          TextFormField(
            controller: referenceController,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            maxLines: null,
            cursorColor: myColors.theme_turquoise,
            style: TextStyle(
              // height: 1.h,
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
              filled: true,
              fillColor: const Color(0x379E9E9E),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: myColors.theme_turquoise,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              hintText: "Enter Reference Number",
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          MainButton(
              title: "OK",
              ontap: () {
                if (referenceController.text.isNotEmpty) {
                  // Get.to(() => NGO_Card_EndUser(
                  //       requestController: RequestController(),
                  //     )
                  //     );
                  Get.offAllNamed(AppRoutes.bottomNavScreenBeneficiary);
                } else {
                  // Show an error message if the reference number is empty
                  Get.snackbar('Error', 'Please enter a valid reference number',
                      snackPosition: SnackPosition.BOTTOM);
                }
              })
        ],
      ),
      // textConfirm: 'OK',
      // confirmTextColor: Colors.white,
      // onConfirm: () {
      //   if (referenceController.text.isNotEmpty) {
      //     // Get.to(() => NGO_Card_EndUser(
      //     //       requestController: RequestController(),
      //     //     )
      //     //     );
      //     Get.offAllNamed(AppRoutes.bottomNavScreenEndUser);
      //   } else {
      //     // Show an error message if the reference number is empty
      //     Get.snackbar('Error', 'Please enter a valid reference number',
      //         snackPosition: SnackPosition.BOTTOM);
      //   }
      // },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

