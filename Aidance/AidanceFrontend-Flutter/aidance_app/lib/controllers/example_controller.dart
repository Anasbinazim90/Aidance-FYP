import 'dart:io';
import 'package:aidance_app/controllers/ipfs_controller.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final IPFSController ipfsController = IPFSController();
  var isLoading = false.obs;

  Future<String> uploadImageAndData(File imageFile, String email) async {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Upload image to IPFS
      String? imageUrl = await ipfsController.uploadImageToIPFS(imageFile);

      // Construct user data JSON
      Map<String, dynamic> userData = {
        'email': email,
        'imageUrl': imageUrl,
      };

      // Upload user data to IPFS
      String ipfsHash = await ipfsController.uploadToIPFS(userData);

      // Set loading state to false
      isLoading.value = false;

      // Return IPFS hash
      return ipfsHash;
    } catch (e) {
      // Handle any errors
      isLoading.value = false;
      throw Exception('Error uploading image and data to IPFS: $e');
    }
  }
}
