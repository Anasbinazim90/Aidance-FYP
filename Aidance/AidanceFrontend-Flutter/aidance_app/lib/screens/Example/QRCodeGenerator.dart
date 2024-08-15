import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  TextEditingController value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          value.text.isEmpty
              ? Container()
              : QrImageView(
                  data: value.text,
                  size: 200.0,
                  version: QrVersions.auto,
                ),

          // Text Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: value,
              decoration: InputDecoration(
                hintText: 'Enter a value',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Generate QR Code')),
        ],
      ),
    );
  }
}
