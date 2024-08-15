import 'dart:developer';

import 'package:aidance_app/services/app_url.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VenderScannerScreen extends StatefulWidget {
  @override
  _VenderScannerScreenState createState() => _VenderScannerScreenState();
}

class _VenderScannerScreenState extends State<VenderScannerScreen> {
  final String vendorAddress = '0x39EB086Ed7f4D67540a1b54E8Acf622C18CEB1e5';

  void _scanQRCode() async {
    final qrData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );

    if (qrData != null) {
      String beneficiaryAddress = qrData['beneficiaryAddress'];
      String campaignId = qrData['campaignId'];
      _claimFunds(beneficiaryAddress, campaignId, vendorAddress);
    } else {
      log('QR code data is null');
    }
  }

  Future<void> _claimFunds(String beneficiaryAddress, String campaignId,
      String vendorAddress) async {
    final String apiUrl = '${AppUrl.baseURL}/Donation/claimFunds';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'beneficiaryAddress': beneficiaryAddress,
        'campaignId': campaignId,
        'vendorAddress': vendorAddress,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Funds claimed successfully');
    } else {
      // Handle error response
      print('Failed to claim funds');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanQRCode,
          child: Text('Scan QR Code'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? beneficiaryAddress;
  String? campaignId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan a QR code',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      var data = scanData.code!.split(',');
      setState(() {
        beneficiaryAddress = data[0];
        campaignId = data[1];
      });
      controller.dispose(); // Stop the scanner
      Navigator.pop(context,
          {'beneficiaryAddress': beneficiaryAddress, 'campaignId': campaignId});
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
