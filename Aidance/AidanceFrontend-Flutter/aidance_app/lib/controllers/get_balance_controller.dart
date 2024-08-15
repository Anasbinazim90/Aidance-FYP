import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/get_balance_model.dart';
import 'package:aidance_app/repositories/get_adr_repository.dart';
import 'package:aidance_app/repositories/get_balance_repository.dart';
import 'package:aidance_app/response/status.dart';
import 'package:get/get.dart';

class GetBalanceController extends GetxController {
  final _api = GetBalanceRepository();
  final RxRequestStatus = Status.LOADING.obs;
  final balanceList = GetBalanceModel().obs;
  RxString error = ''.obs;
  // Rx<GetProfileModel> profileModel = GetProfileModel().obs;
  // final box = GetStorage();

  setRxRequestStatus(Status _value) => RxRequestStatus.value = _value;
  setaddressList(GetBalanceModel _value) => balanceList.value = _value;
  setError(String _value) => error.value = _value;

  getBalanceApi(balance) {
    _api.getBalanceApi(balance).then((value) {
      print("phraseeeee valueee" + value.toString());
      log(value.toString());
      balanceList(value);
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
