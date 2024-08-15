import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/ApiController/get_campaign_data_controller.dart';
import 'package:aidance_app/controllers/ApiController/get_ngo_data_controller.dart';
import 'package:aidance_app/repositories/confirm_ngo_repository.dart';
import 'package:get/get.dart';

class ConfirmNgoController extends GetxController {
  // final box = GetStorage();

  final _api = ConfirmNGORepository();
  final NgoData = Get.put(GetNgoDataController());

  RxBool loading = false.obs;
  regesterNgoApi(ngoRegisterationNo) async {
    // String token = box.read('token').toString();

    loading.value = true;
    Map data = {"ngoRegisterationNo": ngoRegisterationNo};
    // try {
    _api
        .confirmNgoApi(
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

  bool areVotesEqual() {
    return NgoData.ngoList.value.totalInFavorVote ==
        NgoData.ngoList.value.totalAgainstVote;
  }
}
