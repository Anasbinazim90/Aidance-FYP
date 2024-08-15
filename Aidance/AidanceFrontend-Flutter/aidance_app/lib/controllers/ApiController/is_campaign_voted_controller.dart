import 'dart:developer';

import 'package:aidance_app/repositories/is_campaign_voted_repository.dart';
import 'package:get/get.dart';

class IsCampaignVotedController extends GetxController {
  final getIsCampaignVotedRepository _repository =
      getIsCampaignVotedRepository();
  RxBool userAlreadyVoted = false.obs;

  Future<void> checkIfVoted(campaignId, userAddress) async {
    try {
      final bool hasVoted =
          await _repository.isCampaignVoted(campaignId, userAddress);
      userAlreadyVoted.value = hasVoted;
    } catch (error) {
      log("Error checking if user voted: $error");
      Get.snackbar("Error", "Failed to check if you have already voted.");
    }
  }
}
