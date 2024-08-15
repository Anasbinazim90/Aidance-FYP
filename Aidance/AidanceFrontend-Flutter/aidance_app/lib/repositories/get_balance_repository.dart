import 'dart:developer';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/get_balance_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class GetBalanceRepository {
  final _apiServices = NetworkApiServices();

  Future<GetBalanceModel> getBalanceApi(address) async {
    dynamic response =
        await _apiServices.getApi("${AppUrl.getBalance}?address=${address}");

    log("${AppUrl.getBalance}?address=${address}");

    return GetBalanceModel.fromJson(response);
  }
}
