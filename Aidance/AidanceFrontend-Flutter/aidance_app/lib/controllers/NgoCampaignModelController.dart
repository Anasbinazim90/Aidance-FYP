import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:get/get.dart';

class NGOProposalController extends GetxController {
  RxList<NGOCampaignModel>? proposals = <NGOCampaignModel>[].obs;

  void addProposal(NGOCampaignModel proposal) {
    proposals!.add(proposal);
  }
}
