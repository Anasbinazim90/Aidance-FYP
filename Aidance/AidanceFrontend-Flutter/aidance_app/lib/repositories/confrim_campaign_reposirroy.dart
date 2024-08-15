import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class ConfirmCampaignRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> confirmCampaignApi(var data) async {
    dynamic response = _apiServices.postApi(
        data, "${AppUrl.confirmCampaign}?campaignId=${data['campaignId']}");
    return response;
  }
}
