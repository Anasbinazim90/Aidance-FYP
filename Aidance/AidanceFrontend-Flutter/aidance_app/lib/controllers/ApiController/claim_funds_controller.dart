import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/repositories/claim_funds_repository.dart';
import 'package:get/get.dart';

class ClaimFundsController extends GetxController {
  // final box = GetStorage();

  final _api = ClaimfundsRepository();

  RxBool loading = false.obs;
  ClaimFundsApi(String BenificiaryAddress, String campaignId,
      String VendorAddress) async {
    // String token = box.read('token').toString();

    loading.value = true;
    Map data = {
      "beneficiaryAddress": BenificiaryAddress,
      "campaignId": campaignId,
      "vendorAddress": VendorAddress,
    };
    // try {
    _api
        .claimFundsApi(
      data,
    )
        .then((value) {
      loading.value = false;

      print("value" + value.toString());
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
}
