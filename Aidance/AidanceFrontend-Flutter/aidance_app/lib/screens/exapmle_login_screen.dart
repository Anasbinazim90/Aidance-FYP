// // main.dart
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:aidance_app/controllers/ipfs_controller.dart';
// import 'package:aidance_app/utils/myutils.dart';
// import 'package:file_picker/file_picker.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// //  ipfsHash ?? "Qma6YRNQYas7oXqdPj6METrjN6ipirPUXFCybnzdmUx1dL"
// class IPFSCheck extends StatefulWidget {
//   @override
//   State<IPFSCheck> createState() => _IPFSCheckState();
// }

// class _IPFSCheckState extends State<IPFSCheck> {
//   // final EthereumController ethereumController = Get.put(EthereumController());
//   final IPFSController ipfsController = Get.put(IPFSController());

//   String? ipfsHash;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blockchain App'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             storeData();
//           },
//           child: Text('Store and Retrieve Data'),
//         ),
//       ),
//     );
//   }

//   Future<void> storeData() async {
//     final data =
//         {"message": "testing image","image": "https://cyan-fantastic-beaver-931.mypinata.cloud/ipfs/QmVqGtjw21L2auPUEGfVnYZSfKFaV3eooBCtJtG7khZ9MN"}; // Example data to be stored

//     // IPFS operation (upload data)
//     final ipfsHashString = await ipfsController.uploadToIPFS(data);

//     // Parse the JSON string to extract the IPFS hash
//     Map<String, dynamic> ipfsHashJson = jsonDecode(ipfsHashString);
//     ipfsHash = ipfsHashJson['IpfsHash'];

//     print(
//         "IPFS Hash: $ipfsHash"); // Output: IPFS Hash: Qma6YRNQYas7oXqdPj6METrjN6ipirPUXFCybnzdmUx1dL

//     // Now, you can use ipfsHash to retrieve data from IPFS or perform any other operations.
//   }

//   Future<void> retrieveData(String ipfsHash) async {
//     // IPFS operation (retrieve data)

//     print("IPFS Hash: $ipfsHash");

//     final retrievedData = await ipfsController.getDataFromIPFS(ipfsHash);

//     // Print the retrieved data
//     print("Retrieved data from IPFS: $retrievedData");
//   }
// }

//   // Future<void> uploadImage() async {
//   //   // Open file picker to select an image
//   //   FilePickerResult? result = await FilePicker.platform.pickFiles(
//   //     type: FileType.image,
//   //     allowMultiple: false,
//   //   );

//   //   // Check if a file was selected
//   //   if (result != null) {
//   //     PlatformFile file = result.files.first;

//   //     // Upload image to IPFS
//   //     String ipfsHash =
//   //         await ipfsController.uploadImageToIPFS(File(file.path!));

//   //     // Print IPFS hash
//   //     print("Image uploaded to IPFS with hash: $ipfsHash");
//   //   }
//   // }
//   // // String ipfsHash = "QmTqWQM5E9CD9Ujko6kNeSWzmWMVagozym1ceCVipZBuqd";

import 'dart:io';

import 'package:aidance_app/controllers/example_controller.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final loginController = Get.put(LoginController());

  Future<void> _selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      File imageFile = File(result.files.single.path!);

      try {
        // Call the uploadImageAndData function of the controller
        String ipfsHash = await loginController.uploadImageAndData(
            imageFile, "saimanus@fatherarqam.com");

        // Handle the result (in this example, just print the IPFS hash)
        print('Data uploaded to IPFS successfully! IPFS Hash: $ipfsHash');
      } catch (e) {
        // Handle any errors
        print('Error uploading data to IPFS: $e');
      }
    } else {
      // User canceled the file picker
      print('User canceled the file picker');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _selectImage,
          child: Obx(() => loginController.isLoading.value
              ? CircularProgressIndicator()
              : Text('Select Image')),
        ),
      ),
    );
  }
}
