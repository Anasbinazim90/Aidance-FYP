import 'dart:developer';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/network/network_api_services.dart';
import 'package:aidance_app/services/app_url.dart';

class getIsNgoVotedRepository {
  final _apiServices = NetworkApiServices();

  Future<bool> isNGOVoted(ngoNo, userAddress) async {
    dynamic response = await _apiServices.getApi(
        "${AppUrl.isNgoVoted}?ngoNumber=${ngoNo}&address=${userAddress}");
    log('isNGOvoted ${response['AlreadyVoted']}');
    return response['AlreadyVoted'];
  }
}
