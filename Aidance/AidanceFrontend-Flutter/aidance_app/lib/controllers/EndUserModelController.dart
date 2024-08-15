import 'package:aidance_app/models/BeneficiaryModel/BeneficiaryModel.dart';
import 'package:get/get.dart';

class EndUserModelController extends GetxController {
  RxList<EndUserModel> Endusers = <EndUserModel>[].obs;

  void addEnduser(EndUserModel enduser) {
    Endusers.add(enduser);
  }

  
}
