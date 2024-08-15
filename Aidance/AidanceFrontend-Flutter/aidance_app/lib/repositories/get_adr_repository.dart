import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class getAddressRepository {
  final _apiServices = NetworkApiServices();

  Future<GetAddressModel> getAddressApi() async {
    dynamic response = await _apiServices.getApi(AppUrl.getAddress);

    return GetAddressModel.fromJson(response);
  }
}
