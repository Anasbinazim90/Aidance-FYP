import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/ApiController/get_campaign_data_controller.dart';
import 'package:aidance_app/controllers/ApiController/get_ngo_data_controller.dart';
import 'package:aidance_app/repositories/confirm_ngo_repository.dart';
import 'package:aidance_app/repositories/donate_to_campaign_repository.dart';
import 'package:get/get.dart';

class DonateToCampaignController extends GetxController {
  // final box = GetStorage();

  final _api = DonateToCampaignRepository();
  final NgoData = Get.put(GetNgoDataController());

  RxBool loading = false.obs;
  donateToCampaignApi(
      String senderAddress, String campaignID, String amount) async {
    // String token = box.read('token').toString();

    Map data = {
      "senderAddress": senderAddress,
      "campaignId": campaignID,
      "amountWei": amount
    };
    try {
      var response = _api.donateToCampaign(
        data,
      );

      log('returning this response ${response.toString()}');

      // loading.value = false;
      return response;
    } catch (e) {
      loading.value = false;
      log(e.toString());
      return null;
    }
  }

  bool areVotesEqual() {
    return NgoData.ngoList.value.totalInFavorVote ==
        NgoData.ngoList.value.totalAgainstVote;
  }
}
