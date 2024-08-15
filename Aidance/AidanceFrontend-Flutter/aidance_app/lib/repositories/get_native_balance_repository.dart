import 'dart:developer';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/get_balance_model.dart';
import 'package:aidance_app/models/get_native_balance_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class GetNativeBalanceRepository {
  final _apiServices = NetworkApiServices();

  Future<GetNativeBalanceModel> getNativeBalanceApi(address) async {
    dynamic response = await _apiServices
        .getApi("${AppUrl.getnativeBalance}?address=${address}");

    log("${AppUrl.getBalance}?address=${address}");

    return GetNativeBalanceModel.fromJson(response);
  }
}
