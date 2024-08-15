import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class VoteForCampaignRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> VorForCampaignApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.voteForCampaign}");
    return response;
  }
}
