import 'dart:convert';
import 'dart:developer';

import 'package:aidance_app/controllers/ApiController/create_voucher_controller.dart';
import 'package:aidance_app/controllers/BeneficiaryControllers/RequestController/RequestController.dart';
import 'package:aidance_app/controllers/EndUserModelController.dart';
import 'package:aidance_app/controllers/NgoControllers/AcceptRequestController.dart';
import 'package:aidance_app/controllers/ipfs_controller.dart';
import 'package:aidance_app/models/BeneficiaryModel/BeneficiaryModel.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/NgoFlow/BenficiaryDetailScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class BeneficiaryListScreen extends StatefulWidget {
  final String campaignId;

  BeneficiaryListScreen({required this.campaignId});

  @override
  State<BeneficiaryListScreen> createState() => _BeneficiaryListScreenState();
}

final _createVoucherController = Get.put(CreateVoucherController());
final _ipfsController = Get.put(IPFSController());

class _BeneficiaryListScreenState extends State<BeneficiaryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: myColors.theme_turquoise,
        title: Text(
          "Beneficiaries",
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('campaigns')
            .where('tokenId', isEqualTo: widget.campaignId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitWaveSpinner(
              waveColor: myColors.theme_turquoise,
              trackColor: myColors.theme_turquoise.withOpacity(0.5),
              color: myColors.theme_turquoise,
            ));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No beneficiaries found'));
          }

          var campaignData = snapshot.data!.docs.first.data();

          // Check if beneficiaries is a list
          if (campaignData['beneficiaries'] == null ||
              (campaignData['beneficiaries'] is! List)) {
            return Center(
                child: Text('No beneficiaries found',
                    style: TextStyle(
                      fontSize: 20.sp,
                    )));
          }

          var beneficiaries = campaignData['beneficiaries'] as List<dynamic>;

          var totalReceived =
              double.parse(campaignData['total_donations_received']);
          var totalRequired =
              double.parse(campaignData['total_donation_required']);

          log(beneficiaries.toString());
          log(totalReceived.toString());
          log(totalRequired.toString());

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: beneficiaries.length,
                  itemBuilder: (context, index) {
                    var beneficiary = beneficiaries[index];

                    return BeneficiaryCard(
                      beneficiary: beneficiary,
                      onTap: () {
                        Get.to(
                            transition: Transition.rightToLeft,
                            () => BenificiaryDetailScreen(
                                beneficiary: beneficiary,
                                campaignData: campaignData));
                      },
                    );
                  },
                ),
              ),
              // if (totalReceived >= totalRequired)
              // Padding(
              //   padding: EdgeInsets.all(16.0),
              //   child: ElevatedButton.icon(
              //     label: Text('Send Vouchers'),
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: myColors.theme_turquoise,
              //         foregroundColor: Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.r),
              //         )),
              //     icon: Icon(Icons.send),
              //     onPressed: totalReceived >= totalRequired
              //         ? () {
              //             log(campaignData['tokenId']);
              //             log('${totalReceived / beneficiaries.length}');

              //             // Convert the floating-point value to a Decimal type
              //             var voucherAmount =
              //                 totalReceived / beneficiaries.length;

              //             showAlertAndNavigate(context, voucherAmount);
              //             // generateAndSendVouchers(
              //             //     beneficiaries, totalReceived, widget.campaignId);
              //           }
              //         : null,
              //   )
              //       .animate(
              //         onPlay: (controller) => controller.loop(
              //           count: 5,
              //         ),
              //       )
              //       .shimmer(
              //         duration: 2200.ms,
              //         delay: 1200.ms,
              //       ),
              // )
            ],
          );
        },
      ),
    );
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
                      "Your voucher for ${voucherAmount} has been sent successfully. You will be redirected to the home screen in 2 seconds.",
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

//   void generateAndSendVouchers(
//       List<dynamic> beneficiaries, double totalReceived, String campaignId) {
//     double voucherAmount = totalReceived / beneficiaries.length;

//     for (var beneficiary in beneficiaries) {
//       var beneficiaryAddress = beneficiary['address'];
//       var price = voucherAmount.toString();
//       var tokenUri = "some_token_uri"; // You can customize this

//       // Call the API to create a voucher
//       _createVoucherController.CreateVoucherApi(
//           campaignId, beneficiaryAddress, price, tokenUri);
//     }
//   }
// }

  // generateAndSendVouchers(List<dynamic> beneficiaries, double totalReceived,
  //     String campaignId) async {
  //   double voucherAmount = totalReceived / beneficiaries.length;
  //   final createVoucherController = CreateVoucherController();

  //   BigInt voucherAmountWei = BigInt.from(voucherAmount * 1000000000000000000);

  //   log(voucherAmountWei.toString());

  //   for (var beneficiary in beneficiaries) {
  //     log('${beneficiary['username']}');

  //     var beneficiaryData = {
  //       "beneficiaryName": beneficiary['username'],
  //       "beneficiaryAddress": beneficiary['address'],
  //       "campaignId": campaignId,
  //       "price": voucherAmountWei.toString()
  //     };

  //     try {
  //       String tokenUri = await _ipfsController.uploadToIPFS(beneficiaryData);
  //       var tokenUriMap = jsonDecode(tokenUri);
  //       String ipfsHash = tokenUriMap['IpfsHash'];
  //       log('calling create voucher api');
  //       log('${campaignId}');
  //       log('${beneficiary['address']}');
  //       log('${voucherAmount.toString()}');
  //       log('${ipfsHash}');
  //       var response = await createVoucherController.CreateVoucherApi(
  //         campaignId,
  //         beneficiary['address'],
  //         voucherAmount.toString(),
  //         ipfsHash,
  //       );

  //       Get.snackbar("Success",
  //           "Voucher created successfully for ${beneficiary['username']}");

  //       return {
  //         'response': response,
  //         'BeneficiarytokenUri': ipfsHash,
  //       };
  //     } catch (e) {
  //       log("Error creating voucher: $e");
  //       Get.snackbar(
  //           "Error", "Failed to create voucher for ${beneficiary['username']}");
  //     }
  //   }
  // }

// //
//   appBar: AppBar(
//           foregroundColor: Colors.white,
//           backgroundColor: myColors.theme_turquoise,
//           title: Text(
//             "Beneficiaries",
//             style: TextStyle(
//               fontSize: 24.sp,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
// //
}

class BeneficiaryCard extends StatelessWidget {
  const BeneficiaryCard({super.key, this.beneficiary, this.onTap});

  final beneficiary;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(beneficiary['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.sp)),
                Text(beneficiary['email'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
