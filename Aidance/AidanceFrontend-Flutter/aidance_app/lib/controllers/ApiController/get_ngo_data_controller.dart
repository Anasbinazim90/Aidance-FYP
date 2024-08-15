import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/NgoModel/get_ngo_data_model.dart';
import 'package:aidance_app/repositories/get_adr_repository.dart';
import 'package:aidance_app/repositories/get_ngo_data_repository.dart';
import 'package:aidance_app/response/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetNgoDataController extends GetxController {
  final _api = GetNgoDataRepository();
  final RxRequestStatus = Status.LOADING.obs;
  final ngoList = GetNgoDataModel().obs;
  RxString error = ''.obs;
  // Rx<GetProfileModel> profileModel = GetProfileModel().obs;
  // final box = GetStorage();

  setRxRequestStatus(Status _value) => RxRequestStatus.value = _value;
  setaddressList(GetNgoDataModel _value) => ngoList.value = _value;
  setError(String _value) => error.value = _value;

  getAddressApi(ngoNo) {
    _api.getNgoDataApi(ngoNo).then((value) {
      print("phraseeeee valueee" + value.toString());
      log(value.toString());
      ngoList.value = value;
      // box.write("ProfileData", jsonEncode(value));
      // profileModel.value =
      //     GetProfileModel.fromJson(jsonDecode(box.read("ProfileData")));
      // log("Emailllllllll" +
      //     GetProfileModel.fromJson(jsonDecode(box.read("ProfileData")))
      //         .toString());

      setRxRequestStatus(Status.COMPLETED);
      // return true;
    }).onError((error, stackTrace) {
      if (error is SocketException) {
        print("Internet Connection not Available");
      }
      setError(error.toString());
      print("value" + error.toString());
      // setRxRequestStatus(Status.ERROR);

      setRxRequestStatus(Status.ERROR);
      // Get.snackbar("Error", error.toString());
      // return false;
    });
  }
}
