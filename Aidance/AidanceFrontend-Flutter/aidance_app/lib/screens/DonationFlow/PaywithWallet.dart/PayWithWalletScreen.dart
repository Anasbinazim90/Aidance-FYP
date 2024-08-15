import 'dart:developer';

import 'package:aidance_app/components/mainbutton.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/DonationInfo_controllers/DonationInfo_controller.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/donation_data_controller.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/DonationFlow/PaywithWallet.dart/PayCryptoWidget.dart';
import 'package:aidance_app/screens/DonationFlow/PaywithWallet.dart/UsdEqualsWigdet.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PayWithWalletScreen extends StatefulWidget {
  const PayWithWalletScreen({super.key, this.campaign});

  final NGOCampaignModel? campaign;

  @override
  State<PayWithWalletScreen> createState() => _PayWithWalletScreenState();
}

class _PayWithWalletScreenState extends State<PayWithWalletScreen> {
  final Mainbutton_contrllr = Get.put(MainButtonController());
  final donationDataController = Get.find<DonationFlowController>();
  final amountController = TextEditingController();
  String selectedOption = 'Option 1';
  double total_donations_recieved = 0;

  Future<void> checkDonationAmountAndProceed() async {
    log('checkDonationAmountAndProceed called');
    double amount = double.parse(amountController.text);
    double currentTotalReceived =
        double.parse(widget.campaign!.total_donations_received);
    log('currentTotalReceived: $currentTotalReceived');

    if (widget.campaign != null) {
      double totalAmountRequired =
          double.parse(widget.campaign!.total_donation_required);

      if ((currentTotalReceived + amount) <= totalAmountRequired) {
        donationDataController.updatePaymentInfo(amount);
        Mainbutton_contrllr.mainButtonTapped();
        log(donationDataController.donationData.value.amount.toString());
        log(donationDataController.donationData.value.name.toString());
        log(donationDataController.donationData.value.message.toString());
      } else {
        Get.snackbar("Amount Exceed",
            "Total donation amount exceeds the required amount");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.campaign != null) {
      log(widget.campaign!.ngoName.toString());
    } else {
      log('null');
    }
    // total_donations_recieved = fetchCurrentTotalReceived();
    log('total_donations_recieved: $total_donations_recieved');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: 31.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Heading_PayWithWallet(widget.campaign?.title),
                  SizedBox(
                    height: 24.h,
                  ),
                  Heading_DonateTo(widget.campaign?.title),
                  SizedBox(
                    height: 24.h,
                  ),
                  Heading_Organisation(widget.campaign?.ngoName),
                  SizedBox(
                    height: 39.h,
                  ),
                  PayCryptoWidget(
                    controller: amountController,
                  ),
                  SizedBox(
                    height: 27.h,
                  ),
                  Center(
                    child: Transform.rotate(
                      angle: 1.5,
                      child: Image.asset(
                        AppImages.Img_equal,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 27.h,
                  ),
                  // UsdEqualsWidget(),
                  SizedBox(
                    height: 43.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppImages.Img_checkcircle,
                        height: 15.h,
                        width: 15.w,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      termsAnsArgsText(),
                    ],
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  MainButton(
                    ontap: () {
                      // amountController shoudlnt be empty

                      if (validateAmount()) {
                        checkDonationAmountAndProceed();
                        // double amount = double.parse(amountController.text);

                        // donationDataController.updatePaymentInfo(amount);
                        // // Get.toNamed(AppRoutes.pay_with_wallet_screen);
                        // Mainbutton_contrllr.mainButtonTapped();
                        // log(donationDataController.donationData.value.amount
                        //     .toString());
                        // log(donationDataController.donationData.value.name
                        //     .toString());
                        // log(donationDataController.donationData.value.message
                        //     .toString());
                      }
                    },
                    title: 'Continue',
                  ),
                ],
              ),
            ),
          )),
    );
  }

  bool validateAmount() {
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Amount cannot be empty");
      return false;
    }

    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar("Error", "Amount must be greater than 0");
      return false;
    }

    return true;
  }

  Expanded termsAnsArgsText() {
    return Expanded(
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
          text: 'By proceeding the donation, you agree with our ',
          style: MyTextStyles.SecondaryTextStyle().copyWith(fontSize: 12.sp),
        ),
        TextSpan(
          text: 'Terms of Use',
          style: MyTextStyles.SecondaryTextStyle()
              .copyWith(fontSize: 12.sp, color: myColors.theme_turquoise),
        ),
        TextSpan(
          text: ' and ',
          style: MyTextStyles.SecondaryTextStyle().copyWith(fontSize: 12.sp),
        ),
        TextSpan(
          text: 'privacy policy.',
          style: MyTextStyles.SecondaryTextStyle()
              .copyWith(fontSize: 12.sp, color: myColors.theme_turquoise),
        ),
      ])),
    );
  }

  Heading_Organisation(ngoName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organization',
          style: MyTextStyles.SecondaryTextStyle()
              .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              ngoName,
              style: MyTextStyles.SecondaryTextStyle()
                  .copyWith(fontSize: 12.sp, color: myColors.theme_turquoise),
            ),
            SizedBox(
              width: 4.w,
            ),
            SvgPicture.asset(AppImages.Img_CheckBox, width: 14.w, height: 14.h)
          ],
        )
      ],
    );
  }

  Heading_DonateTo(campaignName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donate to',
          style: MyTextStyles.SecondaryTextStyle()
              .copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          campaignName,
          style: MyTextStyles.SecondaryTextStyle()
              .copyWith(fontSize: 12.sp, color: myColors.theme_turquoise),
        ),
      ],
    );
  }

  Heading_PayWithWallet(campaignname) {
    return Row(
      children: [
        Text(
          '${campaignname}',
          style: MyTextStyles.SecondaryTextStyle()
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          width: 12.w,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: SvgPicture.asset(
            AppImages.Img_wallet,
            width: 28.w,
            height: 28.h,
          ),
        ),
      ],
    );
  }
}
