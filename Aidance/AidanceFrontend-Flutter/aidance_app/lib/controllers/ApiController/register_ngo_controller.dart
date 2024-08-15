import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/AuthControllerNgo.dart';
import 'package:aidance_app/repositories/register_ngo_repository.dart';
import 'package:aidance_app/utils/loadingWidget.dart';
import 'package:get/get.dart';

class RegisterNgoController extends GetxController {
  final _api = RegisterNGORepository();
  final _controller = Get.put(AuthControllerNgo());

  RxBool loading = false.obs;
  RxString loadingMessage = ''.obs;

  Future<void> regesterNgoApi(String ngoRegisterationNo, String address,
      context, email, phone, pass, name, mission, selectedFiles) async {
    loading.value = true;

    Map<String, dynamic> data = {
      "ngoRegisterationNo": ngoRegisterationNo,
      "address": address
    };

    try {
      final value = await _api.registerNgoApi(data);

      log("value: $value");

      Get.snackbar("Success", value['message']);

      // Call createUser only if registerNgoApi was successful

      await _controller.createUser(
        context,
        email,
        phone,
        pass,
        name,
        ngoRegisterationNo,
        address,
        mission,
        selectedFiles,
      );

      loading.value = false;
    } catch (error) {
      loading.value = false;
      log("Error: $error");
      Get.snackbar("Error", error.toString());
    }
  }
}
