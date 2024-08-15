import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/repositories/claim_funds_repository.dart';
import 'package:aidance_app/repositories/create_voucher_repository.dart';
import 'package:aidance_app/repositories/donate_amount_repository.dart';
import 'package:get/get.dart';

class DonateAmountController extends GetxController {
  // final box = GetStorage();

  final _api = DonateAmountRepository();

  RxBool loading = false.obs;
  CreateVoucherApi(
      String campaignId, String senderAddress, String amountWei) async {
    // String token = box.read('token').toString();

    loading.value = true;
    Map data = {
      "senderAddress": senderAddress,
      "campaignId": campaignId,
      "amountWei": amountWei
    };
    // try {
    _api
        .donateAmountApi(
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
