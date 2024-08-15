import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/ipfs_controller.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/repositories/create_campaign_repository.dart';
import 'package:aidance_app/repositories/register_ngo_repository.dart';
import 'package:aidance_app/repositories/transfer_token_repository.dart';
import 'package:get/get.dart';

class CreateCampaignController extends GetxController {
  // final box = GetStorage();

  final _api = CreateCampaignRepository();
  final IPFSController ipfsController = IPFSController();

  RxBool loading = false.obs;
  Future<Map<String, dynamic>?> registerCampaignAPi(
    String ngoRegisterationNo,
    String address,
    String totalBenificiary,
    String maxDonation,
    NGOCampaignModel campaign,
    selectedFileList,
  ) async {
    try {
      // loading.value = true;

      var tokenUri = await uploadImageAndData(
        File(selectedFileList[0].path),
        campaign.title,
        campaign.description,
        totalBenificiary,
        maxDonation,
        campaign.ngoName,
        campaign.email,
        ngoRegisterationNo,
        address,
      );

      // return hash fom the token uri object

      // log('tokenUri: $tokenUri');

      String ipfsHash = tokenUri['IpfsHash'];

      log('tokenURI hash: $ipfsHash');

      // log('ipfsHash: $ipfsHash');

      Map<String, dynamic> data = {
        "ngoRegisterationNo": ngoRegisterationNo,
        "address": address,
        "votingHours": '1',
        "totalBeneficiary": totalBenificiary,
        "tokenUri": 'ipfs.io/ipfs/$ipfsHash',
        "maxDonation": maxDonation,
      };

      log('data: $data');

      log('calling create campaign api');

      var response = await _api.createCampaignApi(data);
      log(response.toString());

      // loading.value = false;
      return {
        'response': response,
        'tokenUri': ipfsHash,
      };
    } catch (e) {
      loading.value = false;
      log(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> uploadImageAndData(
      File imageFile,
      String campaignname,
      String campaigndesc,
      String totalBenificiary,
      String maxDonation,
      String ngoname,
      String email,
      String ngoRegisterationNo,
      String address) async {
    try {
      // Set loading state to true

      // Upload image to IPFS
      String? imageUrl = await ipfsController.uploadImageToIPFS(imageFile);

      log('imageUrl: $imageUrl');

      // Construct user data JSON
      Map<String, dynamic> userData = {
        'campaignName': campaignname,
        'description': campaigndesc,
        'imageUrl': imageUrl,
        'totalBeneficiary': totalBenificiary,
        'maxDonation': maxDonation,
        'ngoName': ngoname,
        'ngoRegisterationNo': ngoRegisterationNo,
        'address': address,
        'ngoEmail': email,
      };

      // Upload user data to IPFS
      String ipfsHash = await ipfsController.uploadToIPFS(userData);

      // Return IPFS hash
      return jsonDecode(ipfsHash);
    } catch (e) {
      // Handle any errors

      throw Exception('Error uploading image and data to IPFS: $e');
    }
  }
}
