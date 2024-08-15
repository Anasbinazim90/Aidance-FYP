import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class ConfirmNGORepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> confirmNgoApi(var data) async {
    dynamic response =
        _apiServices.postApi(data, "${AppUrl.confirmNgoRegistration}");
    return response;
  }
}
