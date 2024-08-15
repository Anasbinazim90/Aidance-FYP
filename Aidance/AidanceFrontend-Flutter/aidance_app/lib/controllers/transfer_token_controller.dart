import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/repositories/transfer_token_repository.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TransferTokenController extends GetxController {
  // final box = GetStorage();

  final _api = TransferTokenRepository();

  RxBool loading = false.obs;
  transferTokenApi(String address, String amount) async {
    // String token = box.read('token').toString();

    loading.value = true;
    Utils.showAlertAndNavigateGeneral(
        Get.context!,
        true,
        "Transfering Tokens",
        "Please wait while we transfer the tokens",
        SpinKitWaveSpinner(
          waveColor: myColors.theme_turquoise,
          trackColor: myColors.theme_turquoise.withOpacity(0.5),
          color: myColors.theme_turquoise,
        ));
    Map data = {"address": address, "amount": amount};
    // try {
    _api
        .transferTokenApi(
      data,
    )
        .then((value) {
      loading.value = false;

      print("value" + value.toString());
      // final _controller = Get.put(GetFriendsController());
      // _controller.getFriendsApi();
      Get.back();
      Get.snackbar("Success", value['message']);
    }).onError((error, stackTrace) {
      Get.back();
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
