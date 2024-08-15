import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class RegisterNGORepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> registerNgoApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.registerNgo}");
    return response;
  }
}
