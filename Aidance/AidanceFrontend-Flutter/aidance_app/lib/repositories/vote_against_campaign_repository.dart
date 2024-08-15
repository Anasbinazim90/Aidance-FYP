import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class VoteAgainstCampaignRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> VoteAgainstCampaignApi(var data) async {
    dynamic response =
        _apiServices.postApi(data, "${AppUrl.voteAgainstCampaign}");
    return response;
  }
}
