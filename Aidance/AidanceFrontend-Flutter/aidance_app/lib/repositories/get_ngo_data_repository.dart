import 'dart:developer';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/NgoModel/get_ngo_data_model.dart';
import 'package:aidance_app/models/get_balance_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class GetNgoDataRepository {
  final _apiServices = NetworkApiServices();

  Future<GetNgoDataModel> getNgoDataApi(ngoRegNo) async {
    dynamic response =
        await _apiServices.getApi("${AppUrl.getNgoData}?ngoRegNo=${ngoRegNo}");

    log("${AppUrl.getBalance}?ngoRegNo=${ngoRegNo}");

    return GetNgoDataModel.fromJson(response);
  }
}
