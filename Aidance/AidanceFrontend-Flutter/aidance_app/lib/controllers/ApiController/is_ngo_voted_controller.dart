import 'dart:developer';

import 'package:aidance_app/repositories/is_campaign_voted_repository.dart';
import 'package:aidance_app/repositories/is_ngo_voted_repository.dart';
import 'package:get/get.dart';

class IsNgoVotedController extends GetxController {
  final getIsNgoVotedRepository _repository = getIsNgoVotedRepository();
  RxBool userAlreadyVoted = false.obs;

  Future<void> checkIfVoted(ngoNo, userAddress) async {
    try {
      final bool hasVoted = await _repository.isNGOVoted(ngoNo, userAddress);
      userAlreadyVoted.value = hasVoted;
    } catch (error) {
      log("Error checking if user voted: $error");
      Get.snackbar("Error", "Failed to check if you have already voted.");
    }
  }
}
