import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/models/ApiModels/get_address_model.dart';
import 'package:aidance_app/models/NgoModel/get_campaign_data_model.dart';
import 'package:aidance_app/models/NgoModel/get_campaign_model.dart';
import 'package:aidance_app/models/NgoModel/get_ngo_data_model.dart';
import 'package:aidance_app/repositories/get_adr_repository.dart';
import 'package:aidance_app/repositories/get_campaign_repository.dart';
import 'package:aidance_app/repositories/get_ngo_data_repository.dart';
import 'package:aidance_app/response/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetCampaignDataController extends GetxController {
  final _api = GetCampaignDataRepository();
  final Rx<Status> rxRequestStatus = Status.LOADING.obs;
  final campaignList = GetCampaignDataModel().obs;
  RxString error = ''.obs;

  setRxRequestStatus(Status _value) => rxRequestStatus.value = _value;
  setCampaignList(GetCampaignDataModel _value) => campaignList.value = _value;
  setError(String _value) => error.value = _value;

  Future<void> getAddressApi(campaignId) async {
    log("Fetching campaign data for ID: $campaignId");
    try {
      final value = await _api.getCampaignDataApi(campaignId);
      log("Received value from API: $value");
      setCampaignList(value);
      log("Set campaign data: ${campaignList.value}");

      setRxRequestStatus(Status.COMPLETED);
      log("Campaign data successfully fetched and set.");
    } catch (error) {
      if (error is SocketException) {
        print("Internet Connection not Available");
      }
      setError(error.toString());
      log("Error: $error");
      setRxRequestStatus(Status.ERROR);
    }
  }
}
