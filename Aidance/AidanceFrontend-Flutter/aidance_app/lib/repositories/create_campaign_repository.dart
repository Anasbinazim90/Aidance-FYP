import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class CreateCampaignRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> createCampaignApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.createCampaign}");
    return response;
  }
}
