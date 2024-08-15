import 'dart:convert'; // Add this import to use jsonEncode
import 'dart:developer';

import 'package:aidance_app/screens/BeneficiaryFlow/ProfileScreenBeneficiary/ProfileScreenBeneficiary.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/horizontal_coupon.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/vertical_coupon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? beneficiaryData;
  String? beneficiaryAddress;
  String? campaignId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    if (user != null) {
      DocumentSnapshot beneficiaryDoc = await FirebaseFirestore.instance
          .collection('benificiaryUsers')
          .doc(user!.uid)
          .get();

      setState(() {
        beneficiaryData = beneficiaryDoc.data() as Map<String, dynamic>?;
        beneficiaryAddress = beneficiaryData?['address'];
        campaignId = beneficiaryData?['campaignId'];
      });

      log(campaignId ?? 'No campaign ID');
      log(beneficiaryAddress ?? 'No address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Voucher',
            style: TextStyle(
              fontFamily: 'Epilogue',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff171A1F),
            )),
      ),
      body: beneficiaryData == null
          ? Center(
              child: SpinKitWaveSpinner(
              waveColor: myColors.theme_turquoise,
              trackColor: myColors.theme_turquoise.withOpacity(0.5),
              color: myColors.theme_turquoise,
            ))
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('campaigns')
                      .where('tokenId', isEqualTo: campaignId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('No data available');
                    }

                    // Assuming there is only one document for the campaign ID
                    var campaignData = snapshot.data!.docs.first;
                    var beneficiaries =
                        campaignData['beneficiaries'] as List<dynamic>;
                    // Filter the beneficiaries list
                    var filteredBeneficiaries =
                        beneficiaries.where((beneficiary) {
                      return beneficiary['address'] == beneficiaryAddress &&
                          beneficiary['voucher'] == 1;
                    }).toList();

                    if (filteredBeneficiaries.isEmpty) {
                      return Text('No voucher available');
                    }

                    return ListView.builder(
                        itemCount: filteredBeneficiaries.length,
                        itemBuilder: (context, index) {
                          var beneficiary = filteredBeneficiaries[index];
                          return GestureDetector(
                              onTap: () => onTapVoucher1(
                                      context,
                                      campaignData['ngoName'],
                                      beneficiary['voucherAmount'], () {
                                    Get.back();
                                    showQRCodeDialog(
                                      context,
                                      beneficiaryAddress!,
                                      campaignId!,
                                      NetworkImage(
                                          '${campaignData['cover_photo'][0]}'),
                                    );
                                  }),
                              child: HorizontalCouponExample1(
                                userName: campaignData['ngoName'],
                                campaignName: campaignData['title'],
                                amount: beneficiary['voucherAmount'],
                                Ngoname: beneficiary['username'],
                              ));
                        });
                  },
                ),
              ),
            ),
    );
  }

  void onTapVoucher1(
      BuildContext context, String ngoName, String amount, onPressedRedeem) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.all(0.0),
            contentPadding: EdgeInsets.all(0.0),
            content: VerticalCouponExample(
              ngoName: ngoName,
              amount: amount,
              onPressed: onPressedRedeem,
            ).animate().shake(hz: 2),
          ),
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

  void showQRCodeDialog(BuildContext context, String address, String campaignId,
      ImageProvider<Object> image) {
    // Encode the address and campaignId into a JSON string
    String qrData = jsonEncode({
      "beneficiaryAddress": address,
      "campaignId": campaignId,
    });

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: SizedBox(
            width: 350,
            height: 450,
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text('QR Code'),
              content: Column(
                children: [
                  QrImageView(
                    data: qrData,
                    size: 200.0,
                    version: QrVersions.auto,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
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

  Future<Color> getImageDominantColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );
    return paletteGenerator.dominantColor?.color ?? Colors.white;
  }
}
