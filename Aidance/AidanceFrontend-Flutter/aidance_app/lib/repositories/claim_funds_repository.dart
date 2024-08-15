import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class ClaimfundsRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> claimFundsApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.claimFunds}");
    return response;
  }
}
