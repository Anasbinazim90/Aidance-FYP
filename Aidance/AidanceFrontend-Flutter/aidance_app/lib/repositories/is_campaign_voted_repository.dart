import 'dart:developer';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class getIsCampaignVotedRepository {
  final _apiServices = NetworkApiServices();

  Future<bool> isCampaignVoted(campaignID, userAddress) async {
    dynamic response = await _apiServices.getApi(
        "${AppUrl.isCampaignVoted}?campaignId=${campaignID}&address=${userAddress}");
    log('isvoted ${response['CampaignVoted']}');
    return response['CampaignVoted'];
  }
}
