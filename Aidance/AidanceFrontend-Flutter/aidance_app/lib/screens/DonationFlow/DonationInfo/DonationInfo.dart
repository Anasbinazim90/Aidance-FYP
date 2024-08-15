import 'dart:developer';

import 'package:aidance_app/controllers/DonationFlow_controllers/DonationInfo_controllers/DonationInfo_controller.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/PageView_controllers/PageView_controller.dart';
import 'package:aidance_app/components/mainbutton.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/donation_data_controller.dart';
import 'package:aidance_app/screens/DonationFlow/DonationInfo/InputFields.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:aidance_app/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DonationInfoScreen extends StatelessWidget {
  DonationInfoScreen({super.key});

  final checkbx_contrllr = Get.put(CheckBoxController());

  final Mainbutton_contrllr = Get.put(MainButtonController());

  final pageviewcontroller = Get.put(PageViewController());

  final donationDataController = Get.put(DonationFlowController());

  final nameController = TextEditingController();
  final messageController = TextEditingController();
  String? selectedSourceOfFunds;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 31.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyTexts.df_name,
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 16.sp),
                ),
                InputFields().NameField(context, nameController),
                SizedBox(height: 7.h),
                Obx(
                  () => Padding(
                      padding: EdgeInsets.only(left: 0.0.w),
                      child: Utils.CustomCheckBoxWithText(
                          MyTexts.df_name_chkbox,
                          checkbx_contrllr.name_checkboxSelected.value, () {
                        checkbx_contrllr.name_checkboxSelected.value =
                            !checkbx_contrllr.name_checkboxSelected.value;

                        if (checkbx_contrllr.name_checkboxSelected.value) {
                          nameController.text = 'Anonymous';
                        } else {
                          nameController.text = '';
                        }
                      })),
                ),
                SizedBox(height: 22.h),
                Text(
                  MyTexts.df_SourceofFunds,
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 16.sp),
                ),
                InputFields().SourceOfFunds_Dropdown(context),
                SizedBox(height: 22.h),
                Text(
                  MyTexts.df_msg,
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 16.sp),
                ),
                InputFields().MessgaeBox(context, messageController),
                SizedBox(height: 30.h),
                MainButton(
                  ontap: () {
                    // Use default values for the controller, but not in the text fields
                    final name = nameController.text.isEmpty
                        ? 'Anonymous'
                        : nameController.text;
                    final message = messageController.text.isEmpty
                        ? 'none'
                        : messageController.text;
                    // Get.toNamed(AppRoutes.pay_with_wallet_screen);
                    donationDataController.updateDonationInfo(
                        name, selectedSourceOfFunds.toString(), message);

                    Mainbutton_contrllr.mainButtonTapped();
                  },
                  title: 'Continue',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
