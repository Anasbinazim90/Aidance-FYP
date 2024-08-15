import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/ApiController/get_campaign_data_controller.dart';
import 'package:aidance_app/repositories/confirm_ngo_repository.dart';
import 'package:aidance_app/repositories/confrim_campaign_reposirroy.dart';
import 'package:get/get.dart';

class ConfirmCampaignController extends GetxController {
  // final box = GetStorage();

  final _api = ConfirmCampaignRepository();

  final campaignData = Get.put(GetCampaignDataController());

  RxBool loading = false.obs;
  regesterCampaignApi(campaignId) async {
    // String token = box.read('token').toString();

    loading.value = true;
    Map data = {"campaignId": campaignId};
    // try {
    _api
        .confirmCampaignApi(
      data,
    )
        .then((value) {
      loading.value = false;

      log("value" + value.toString());
      // final _controller = Get.put(GetFriendsController());
      // _controller.getFriendsApi();
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

  bool areVotesEqual() {
    return campaignData.campaignList.value.totalInFavorVoteCampaign ==
        campaignData.campaignList.value.totalAgainstVoteCampaign;
  }
}
