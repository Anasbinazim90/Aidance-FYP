import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class TransferTokenRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> transferTokenApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.transferTokens}");
    return response;
  }
}
