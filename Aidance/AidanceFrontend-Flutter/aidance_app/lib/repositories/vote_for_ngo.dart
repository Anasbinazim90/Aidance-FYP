import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class VoteforNgoRepository {
  final _apiServices = NetworkApiServices();
  Future<dynamic> VoteForNgoApi(var data) async {
    dynamic response = _apiServices.postApi(data, "${AppUrl.voteForNGO}");
    return response;
  }
}
