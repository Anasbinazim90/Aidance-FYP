import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/repositories/claim_funds_repository.dart';
import 'package:aidance_app/repositories/create_voucher_repository.dart';
import 'package:get/get.dart';

class CreateVoucherController extends GetxController {
  // final box = GetStorage();

  final _api = CreateVoucherRepository();

  RxBool loading = false.obs;
  // CreateVoucherApi(String campaignId, String BenificiaryAddress, String price,
  //     String tokenUri) async {
  //   // String token = box.read('token').toString();

  //   loading.value = true;
  //   Map data = {
  //     "beneficiaryAddress": BenificiaryAddress,
  //     "price": price,
  //     "campaignId": campaignId,
  //     "tokenUri": tokenUri
  //   };
  //   try {
  //     var response = await _api.createVoucherApi(data);
  //     Get.snackbar("Success", "Voucher created successfully");
  //     return response;
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<Map<String, dynamic>> createVoucherApi(String campaignId,
      String beneficiaryAddress, String price, String tokenUri) async {
    loading.value = true;
    Map<String, dynamic> data = {
      "beneficiaryAddress": beneficiaryAddress,
      "price": price,
      "campaignId": campaignId,
      "tokenUri": tokenUri,
    };
    try {
      var response = await _api.createVoucherApi(data);
      loading.value = false;
      log("reponse : ${response['message']}");
      return response;
    } catch (e) {
      loading.value = false;

      log("Error creating voucher: $e");
      throw e;
    }
  }
}
