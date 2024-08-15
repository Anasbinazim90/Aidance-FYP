import 'dart:developer';

import 'package:aidance_app/Components/alertdialogues.dart';
import 'package:aidance_app/components/mainbutton.dart';
import 'package:aidance_app/controllers/ApiController/donate_to_campaign_controller.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/PayCryptoController/PayCryptoController.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/donation_data_controller.dart';
import 'package:aidance_app/models/DonationModels/donation_data_model.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/DonorView/BottomNavScreenDonor/BottomNavScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/HomeScreenDonor/HomeScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/ProfileScreenDonor/ProfileScreenDonor.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CompleteTransactionScreen extends StatelessWidget {
  CompleteTransactionScreen({super.key, this.campaign});

  final NGOCampaignModel? campaign;

  final pay_with_crypto_contrllr = Get.put(PayCryptoController());

  final donationFlowController = Get.find<DonationFlowController>();
  final donateToController = Get.put(DonateToCampaignController());

  Future<void> storeDonationData(String name, String message, double amount,
      String transactionHash) async {
    try {
      if (campaign != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('campaigns')
            .where('tokenId', isEqualTo: campaign!.tokenId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final campaignDocRef = querySnapshot.docs.first.reference;

          await campaignDocRef.update({
            'donations': FieldValue.arrayUnion([
              {
                'donorName': name,
                'message': message,
                'amount': amount,
                'transactionHash': transactionHash,
                'timestamp': Timestamp.now(),
              }
            ])
          });
        }
      }
    } catch (e) {
      log('Error storing donation data: $e');
    }
  }

  Future<void> StoreDonationData(String name, String message, double amount,
      String transactionHash) async {
    try {
      if (campaign != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('campaigns')
            .where('tokenId', isEqualTo: campaign!.tokenId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final campaignDocRef = querySnapshot.docs.first.reference;

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(campaignDocRef);

            if (!snapshot.exists) {
              throw Exception("Campaign does not exist!");
            }

            // Get current total received donation amount
            String currentTotalReceivedStr =
                snapshot.get('total_donations_received') ?? '0.0';
            double currentTotalReceived = double.parse(currentTotalReceivedStr);

            // Update the donations array
            transaction.update(campaignDocRef, {
              'donations': FieldValue.arrayUnion([
                {
                  'donorName': name,
                  'message': message,
                  'amount': amount,
                  'transactionHash': transactionHash,
                  'timestamp': Timestamp.now(),
                }
              ]),
              // Update the total received donation amount
              'total_donations_received':
                  (currentTotalReceived + amount).toString(),
            });
          });
        }
      }
    } catch (e) {
      log('Error storing donation data: $e');
    }
  }

  void onPaymentSuccess(String transactionHash) async {
    // Commit the data to Firestore
    DonationData data = donationFlowController.donationData.value;
    await StoreDonationData(
        data.name!, data.message!, data.amount!, transactionHash);

    // Clear the temporary data
    donationFlowController.clearDonationData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // backgroundColor: const Color.fromARGB(255, 80, 21, 21),
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: 31.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 32.h,
                      ),
                      Center(
                        child: Text(
                          '${donationFlowController.donationData.value.amount} ETH',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 42.h,
                      ),
                      PaymentMethod(campaign!.title),
                      SizedBox(
                        height: 37.h,
                      ),
                      // Obx(() => ChoiceChip.elevated(
                      //       showCheckmark: false,
                      //       avatar: SvgPicture.asset(AppImages.Img_wallet,
                      //           colorFilter: pay_with_crypto_contrllr
                      //                   .isChoiceChipSelected.value
                      //               ? ColorFilter.mode(myColors.theme_turquoise,
                      //                   BlendMode.srcIn)
                      //               : ColorFilter.mode(
                      //                   Color(0xFFEBFDFF), BlendMode.srcIn),
                      //           width: 20.w,
                      //           height: 20.h),
                      //       elevation: 0,
                      //       pressElevation: 4,
                      //       selected: pay_with_crypto_contrllr
                      //           .isChoiceChipSelected.value,
                      //       onSelected: (value) {
                      //         pay_with_crypto_contrllr
                      //             .isChoiceChipSelected.value = value;
                      //       },
                      //       selectedColor: Color(0xFFEBFDFF),
                      //       backgroundColor: myColors.theme_turquoise,
                      //       label: Text(
                      //         'Connect Your Wallet',
                      //         style: TextStyle(
                      //             fontFamily: 'Inter',
                      //             fontSize: 16.sp,
                      //             fontWeight: FontWeight.w400,
                      //             color: pay_with_crypto_contrllr
                      //                     .isChoiceChipSelected.value
                      //                 ? myColors.theme_turquoise
                      //                 : Color(0xFFEBFDFF)),
                      //       ),
                      //     )
                      //         .animate(
                      //           onPlay: (controller) => controller.loop(
                      //             count: 5,
                      //           ),
                      //         )
                      //         .shimmer(
                      //           duration: 2200.ms,
                      //           delay: 1200.ms,
                      //         )),

                      Center(
                        child: Obx(
                          () => ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: myColors.theme_turquoise,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                )),
                            onPressed: () async {
                              log('donor address : ${DonorAddress!}');
                              log('campaign token id : ${campaign!.tokenId}');
                              log('donation amount : ${donationFlowController.donationData.value.amount}');
                              donateToController.loading.value = true;
                              final response =
                                  await donateToController.donateToCampaignApi(
                                DonorAddress!,
                                campaign!.tokenId.toString(),
                                donationFlowController.donationData.value.amount
                                    .toString(),
                              );

                              log('apicalled');

                              if (response['success'] == true) {
                                onPaymentSuccess(
                                  response['transactionHash'],
                                );
                                showAlertAndNavigate(context);
                                Get.snackbar('Success', 'Donation Successful',
                                    snackPosition: SnackPosition.BOTTOM);
                              } else {
                                Get.snackbar('Error', 'Donation Failed',
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                              donateToController.loading.value = false;
                            },
                            label: Text('Confirm Transaction'),
                            icon: donateToController.loading.value
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: EdgeInsets.all(2.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))
                                : SvgPicture.asset(AppImages.Img_wallet,
                                    colorFilter: pay_with_crypto_contrllr
                                            .isChoiceChipSelected.value
                                        ? ColorFilter.mode(
                                            myColors.theme_turquoise,
                                            BlendMode.srcIn)
                                        : ColorFilter.mode(
                                            Color(0xFFEBFDFF), BlendMode.srcIn),
                                    width: 20.w,
                                    height: 20.h),
                          )
                              .animate(
                                onPlay: (controller) => controller.loop(
                                  count: 5,
                                ),
                              )
                              .shimmer(
                                duration: 2200.ms,
                                delay: 1200.ms,
                              ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Kindly confirm the transaction after reviewing the details.',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: myColors.themeGreyColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 78.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Network',
                                style: MyTextStyles.HeadingStyle()
                                    .copyWith(fontSize: 16.sp),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                alignment: Alignment.centerLeft,
                                width: 360.w,
                                height: 43.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: Color(0xffF3F4F6),
                                ),
                                child: Text(
                                  'ERC20 (Ethereum)',
                                  style: MyTextStyles.SecondaryTextStyle()
                                      .copyWith(fontSize: 16.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 56.h,
                      ),
                      // MainButton(title: 'Connect Wallet', ontap: () {})
                    ],
                  ),
                ))));
  }

  void showAlertAndNavigate(BuildContext context) {
    alertDialogue(
      context,
      "Donation Successfull",
      "Your donation has been sent successfully. You will be redirected to the home screen in 2 seconds.",
      AppImages.alertIcon,
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BottomNavBarScreenDonor(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (Route<dynamic> route) => false,
      );
    });
  }

  PaymentMethod(campaignName) {
    return Container(
        padding: EdgeInsets.all(9.h),
        // color: Palette.theme_turquoise[800],
        width: double.infinity,
        height: 120.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method',
                  style: MyTextStyles.SecondaryTextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: myColors.themeGreyColor),
                ),
                Text('Wallet Pay',
                    style: MyTextStyles.HeadingStyle().copyWith(
                      fontSize: 14.sp,
                      color: Colors.black,
                    )),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Donate to',
                  style: MyTextStyles.SecondaryTextStyle().copyWith(
                      fontWeight: FontWeight.w400,
                      color: myColors.themeGreyColor)),
              Container(
                margin: EdgeInsets.only(top: 15.h),
                width: 150.w,
                height: 40.h,
                child: Text(campaignName,
                    textAlign: TextAlign.end,
                    style: MyTextStyles.HeadingStyle()
                        .copyWith(fontSize: 14.sp, color: Colors.black)),
              )
            ])
          ],
        ));
  }
}
