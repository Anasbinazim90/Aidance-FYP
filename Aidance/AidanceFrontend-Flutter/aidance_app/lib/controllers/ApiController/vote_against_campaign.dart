import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/ApiController/get_campaign_data_controller.dart';
import 'package:aidance_app/repositories/create_campaign_repository.dart';
import 'package:aidance_app/repositories/register_ngo_repository.dart';
import 'package:aidance_app/repositories/transfer_token_repository.dart';
import 'package:aidance_app/repositories/vote_against_campaign_repository.dart';
import 'package:get/get.dart';

class VoteAgainstCampaignController extends GetxController {
  // final box = GetStorage();

  final _api = VoteAgainstCampaignRepository();
  final campaignData = Get.put(GetCampaignDataController());

  RxBool loading = false.obs;
  VoteAgainstCampaign(
    String campaignId,
    String address,
  ) async {
    // String token = box.read('token').toString();

    loading.value = true;
    Map data = {
      "address": address,
      "campaignId": campaignId,
    };
    // try {
    _api.VoteAgainstCampaignApi(
      data,
    ).then((value) {
      loading.value = false;

      log("value" + value.toString());
      // final _controller = Get.put(GetFriendsController());
      // _controller.getFriendsApi();
      campaignData.getAddressApi(campaignId);
      Get.snackbar("Success", value['message']);
    }).onError((error, stackTrace) {
      loading.value = false;
      if (error is SocketException) {
        Get.snackbar("No Internet", "Internet Connection not Available");
      }
      // print("value" + error.toString());
      log("value" + error.toString());
      Get.snackbar("Error", error.toString());
    });
  }
}
