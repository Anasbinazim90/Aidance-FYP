import 'dart:convert';
import 'dart:developer';

import 'package:aidance_app/Components/alertdialogues.dart';
import 'package:aidance_app/controllers/ApiController/create_voucher_controller.dart';
import 'package:aidance_app/controllers/ipfs_controller.dart';
import 'package:aidance_app/screens/NgoFlow/BottomNavScreenNgo/BottomNavScreenNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BenificiaryDetailScreen extends StatefulWidget {
  const BenificiaryDetailScreen(
      {super.key, this.beneficiary, required this.campaignData});

  final beneficiary;
  final Map<String, dynamic> campaignData;

  @override
  State<BenificiaryDetailScreen> createState() =>
      _BenificiaryDetailScreenState();
}

final _ipfsController = Get.put(IPFSController());

class _BenificiaryDetailScreenState extends State<BenificiaryDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var totalReceived =
        double.parse(widget.campaignData['total_donations_received']);
    var totalRequired =
        double.parse(widget.campaignData['total_donation_required']);

    var beneficiaries = widget.campaignData['beneficiaries'] as List<dynamic>;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          scrolledUnderElevation: 0,
          backgroundColor: myColors.whitebgcolor,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: widget.beneficiary == null
            ? Center(
                child: SpinKitWaveSpinner(
                waveColor: myColors.theme_turquoise,
                trackColor: myColors.theme_turquoise.withOpacity(0.5),
                color: myColors.theme_turquoise,
              ))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.beneficiary['username']}",
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${widget.beneficiary['email']}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: myColors.themeGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    50.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: myColors.themeGreyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(left: 14.w),
                              iconSize: 18.sp,
                              icon: Icon(Icons.copy),
                              onPressed: () => copyToClipboard(context),
                            ),
                            Text(
                              '${Utils().shortenAddress(widget.beneficiary['address'])}',
                              style: MyTextStyles.SecondaryTextStyle().copyWith(
                                  fontSize: 16.sp,
                                  color: myColors.theme_turquoise,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ngo Number',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: myColors.themeGreyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.beneficiary!['ngono']}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 16.sp,
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    30.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Voucher',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: myColors.themeGreyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.beneficiary!['voucher']}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 16.sp,
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    30.h.verticalSpace,
                    widget.beneficiary!['voucher'] == 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: myColors.themeGreyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                    text: formatVoucherAmount(
                                        widget.beneficiary!['voucherAmount']),
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            fontSize: 16.sp,
                                            color: myColors.theme_turquoise,
                                            fontWeight: FontWeight.bold),
                                    children: [
                                      WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                4), // Adjust the width as needed
                                      ),
                                      TextSpan(
                                        text: 'eth',
                                        style: MyTextStyles.SecondaryTextStyle()
                                            .copyWith(
                                                fontSize: 16.sp,
                                                color: myColors.themeGreyColor,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              )
                            ],
                          )
                        : Container(),
                    50.h.verticalSpace,
                    ElevatedButton.icon(
                            label: Text(widget.beneficiary['voucher'] == 1
                                ? 'Voucher Sent'
                                : 'Generate Voucher'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myColors.theme_turquoise,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                )),
                            icon: Icon(widget.beneficiary['voucher'] == 1
                                ? Icons.check
                                : Icons.send),
                            onPressed: totalReceived >= totalRequired &&
                                    widget.beneficiary['voucher'] != 1
                                ? () {
                                    generateAndSendVouchers(
                                        beneficiaries,
                                        totalReceived,
                                        widget.campaignData['tokenId'],
                                        widget.beneficiary);
                                  }
                                : null)
                        .animate(
                          onPlay: (controller) => controller.loop(
                            count: 5,
                          ),
                        )
                        .shimmer(
                          duration: 2200.ms,
                          delay: 1200.ms,
                        ),
                  ],
                ),
              ));
  }

  String formatVoucherAmount(dynamic amount) {
    try {
      final parsedAmount = double.parse(amount.toString());
      return parsedAmount.toStringAsFixed(4);
    } catch (e) {
      // Handle the error gracefully if parsing fails
      return '0.0000';
    }
  }

  generateAndSendVouchers(List<dynamic> beneficiaries, double totalReceived,
      String campaignId, Beneficiary) async {
    double voucherAmount = totalReceived / beneficiaries.length;
    final createVoucherController = CreateVoucherController();

    BigInt voucherAmountWei = BigInt.from(voucherAmount * 1000000000000000000);

    log(voucherAmountWei.toString());

    var beneficiaryData = {
      "beneficiaryName": Beneficiary['username'],
      "beneficiaryAddress": Beneficiary['address'],
      "campaignId": campaignId,
      "price": '${voucherAmount.toString()} Eth',
    };

    try {
      // showDialog(
      //     barrierColor: Colors.white.withOpacity(0.4),
      //     context: context,
      //     builder: (context) => Center(
      //             child: SpinKitWaveSpinner(
      //           waveColor: myColors.theme_turquoise,
      //           trackColor: myColors.theme_turquoise.withOpacity(0.5),
      //           color: myColors.theme_turquoise,
      //         )));
      Utils.showAlertAndNavigateGeneral(
          context,
          true,
          'Sending Voucher',
          'Please wait while we send vouchers to your beneficiary.',
          SpinKitWaveSpinner(
            waveColor: myColors.theme_turquoise,
            trackColor: myColors.theme_turquoise.withOpacity(0.5),
            color: myColors.theme_turquoise,
          ));

      String tokenUri = await _ipfsController.uploadToIPFS(beneficiaryData);
      var tokenUriMap = jsonDecode(tokenUri);
      String ipfsHash = tokenUriMap['IpfsHash'];
      log('calling create voucher api');
      log('$campaignId');
      log('${Beneficiary['address']}');
      log('${voucherAmountWei.toString()}');
      log('$ipfsHash');

      var response = await createVoucherController.createVoucherApi(
        campaignId,
        Beneficiary['address'],
        voucherAmountWei.toString(),
        ipfsHash,
      );

      if (response['message'] == 'Transaction successful') {
        log('saving data into firestore');
        var campaignQuery = await FirebaseFirestore.instance
            .collection('campaigns')
            .where('tokenId', isEqualTo: campaignId)
            .limit(1)
            .get();

        if (campaignQuery.docs.isNotEmpty) {
          var campaignDoc = campaignQuery.docs.first;
          var currentBeneficiary = beneficiaries.firstWhere(
              (b) => b['address'] == Beneficiary['address'],
              orElse: () => null);

          if (currentBeneficiary != null) {
            log('found beneficiary: ${currentBeneficiary['address']}');

            // Update beneficiary in the local list
            setState(() {
              currentBeneficiary['voucher'] = 1;
              currentBeneficiary['voucherAmount'] = voucherAmount.toString();
              currentBeneficiary['tokenUri'] = ipfsHash;
            });

            // Update Firestore document with modified beneficiaries array
            await campaignDoc.reference.update({
              'beneficiaries': beneficiaries,
            });
          }
        }
        Get.back();
        showAlertAndNavigate(context, voucherAmount);
      } else {
        Get.back();
        log('Error: Failed to create voucher');
        Get.snackbar("Error", "Failed to create voucher!");
      }
    } catch (e) {
      Get.back();
      log("Error creating voucher: $e");
      Get.snackbar(
          "Error", "Failed to create voucher for ${Beneficiary['username']}");
    }
  }

  void copyToClipboard(context) {
    FlutterClipboard.copy(widget.beneficiary['address'] ?? '').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  void showAlertAndNavigate(BuildContext context, voucherAmount) {
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
      barrierColor: Colors.white,
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
                  SizedBox(
                      height: 84.h,
                      width: 84.w,
                      child: SvgPicture.asset(
                        AppImages.alertIcon,
                        color: myColors.theme_turquoise,
                        fit: BoxFit.fitHeight,
                      )),
                  16.h.verticalSpace,
                  Text('Voucher Sent!',
                      textAlign: TextAlign.center,
                      style: MyTextStyles.HeadingStyle()
                          .copyWith(color: myColors.theme_turquoise)),
                  16.h.verticalSpace,
                  Text(
                      "Your voucher for ${formatVoucherAmount(voucherAmount)} has been sent successfully. You will be redirected to the home screen in 2 seconds.",
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

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
