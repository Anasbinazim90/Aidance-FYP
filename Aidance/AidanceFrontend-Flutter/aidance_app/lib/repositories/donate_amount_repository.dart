import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class DonateAmountRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> donateAmountApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.donateAmount}");
    return response;
  }
}
