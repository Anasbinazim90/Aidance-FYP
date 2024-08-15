import 'dart:io';
import 'dart:typed_data';

import 'package:aidance_app/controllers/ipfs_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  IPFSController ipfsController = IPFSController();
  File? imageFile;
  String? ipfsHash;
  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload and Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Open file picker to select an image
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowMultiple: false,
                );

                // Check if a file was selected
                if (result != null) {
                  setState(() {
                    imageFile = File(result.files.single.path.toString());
                  });

                  // Upload image to IPFS
                  ipfsHash = await ipfsController.uploadImageToIPFS(imageFile!);
                  print('IPFS Hash: $ipfsHash'); // Print IPFS hash

                  // Fetch image from IPFS
                  Uint8List? data =
                      await ipfsController.getImageFromIPFS(ipfsHash!);

                  // Update UI with fetched image
                  setState(() {
                    imageData = data;
                  });
                }
              },
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            if (imageData != null)
              Image.memory(
                imageData!,
                width: 200,
                height: 200,
              ),
          ],
        ),
      ),
    );
  }
}
