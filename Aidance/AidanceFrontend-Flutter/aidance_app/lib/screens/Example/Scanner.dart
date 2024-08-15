import 'dart:convert';
import 'package:aidance_app/controllers/ApiController/claim_funds_controller.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final claimController = Get.put(ClaimFundsController());
  String scannedCode = '';
  bool isScanning = true;
  String vendorAddress =
      '0xYourVendorAddressHere'; // Replace with actual vendor address

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => claimController.loading.value
                      ? SpinKitWaveSpinner(
                          waveColor: myColors.theme_turquoise,
                          trackColor: myColors.theme_turquoise.withOpacity(0.5),
                          color: myColors.theme_turquoise,
                        )
                      : Text(
                          'Scan your QR Code...',
                          style: const TextStyle(fontSize: 20),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      if (isScanning) {
        setState(() {
          scannedCode = scanData
              .code!; // update scannedCode variable with scanned QR code
        });

        // Stop scanning to prevent multiple API calls
        controller.pauseCamera();
        isScanning = false;

        try {
          // Decode the JSON string
          Map<String, dynamic> scannedDataMap = jsonDecode(scannedCode);

          // Extract the beneficiaryAddress and campaignId
          String beneficiaryAddress = scannedDataMap['beneficiaryAddress'];
          String campaignId = scannedDataMap['campaignId'];

          // Call the API with the extracted values
          await claimController.ClaimFundsApi(
              beneficiaryAddress, campaignId, vendorAddress);

          // Update the voucher status in Firestore
          await updateVoucherStatusInFirestore(campaignId, beneficiaryAddress);

          // Handle successful API call
          Get.snackbar("Success", "Funds claimed successfully");
        } catch (error) {
          // Handle errors
          Get.snackbar("Error", "Failed to claim funds: $error");
        } finally {
          // Resume scanning after handling the API call
          controller.resumeCamera();
          isScanning = true;
        }
      }
    });
  }

  Future<void> updateVoucherStatusInFirestore(
      String campaignId, String beneficiaryAddress) async {
    try {
      // Fetch the campaign document
      QuerySnapshot campaignSnapshot = await FirebaseFirestore.instance
          .collection('campaigns')
          .where('tokenId', isEqualTo: campaignId)
          .get();

      if (campaignSnapshot.docs.isNotEmpty) {
        DocumentSnapshot campaignDoc = campaignSnapshot.docs.first;
        DocumentReference campaignRef = campaignDoc.reference;

        // Get the current beneficiaries list
        List<dynamic> beneficiaries = campaignDoc['beneficiaries'];

        // Find the index of the beneficiary to be updated
        int index = beneficiaries.indexWhere((beneficiary) =>
            beneficiary['address'] == beneficiaryAddress &&
            beneficiary['voucher'] == 1);

        if (index != -1) {
          // Update the voucher status to 0
          beneficiaries[index]['voucher'] = 0;

          // Update the campaign document with the new beneficiaries list
          await campaignRef.update({'beneficiaries': beneficiaries});

          Get.snackbar("Success", "Voucher claimed and updated successfully");
        } else {
          Get.snackbar("Error", "Voucher not found");
        }
      } else {
        Get.snackbar("Error", "Campaign not found");
      }
    } catch (error) {
      Get.snackbar("Error", "Failed to update voucher: $error");
    }
  }
}
