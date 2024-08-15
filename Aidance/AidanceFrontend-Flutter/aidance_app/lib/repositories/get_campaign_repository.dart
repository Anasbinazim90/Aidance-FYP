import 'dart:developer';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/NgoModel/get_campaign_data_model.dart';
import 'package:aidance_app/models/NgoModel/get_ngo_data_model.dart';
import 'package:aidance_app/models/get_balance_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class GetCampaignDataRepository {
  final _apiServices = NetworkApiServices();

  Future<GetCampaignDataModel> getCampaignDataApi(campaignID) async {
    dynamic response = await _apiServices
        .getApi("${AppUrl.getCampaignData}?campaignId=${campaignID}");

    log("${AppUrl.getCampaignData}?campaignId=${campaignID}");

    return GetCampaignDataModel.fromJson(response);
  }
}
