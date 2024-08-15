import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class CreateVoucherRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> createVoucherApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.createVoucher}");
    return response;
  }
}
