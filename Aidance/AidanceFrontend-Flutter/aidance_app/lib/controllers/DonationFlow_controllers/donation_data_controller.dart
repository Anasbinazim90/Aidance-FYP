import 'package:aidance_app/models/DonationModels/donation_data_model.dart';
import 'package:get/get.dart';

class DonationFlowController extends GetxController {
  final donationData = DonationData().obs;

  void updateDonationInfo(String name, String sourceOfFunds, String message) {
    donationData.update((data) {
      data?.name = name;
      data?.sourceOfFunds = sourceOfFunds;
      data?.message = message;
    });
  }

  void updatePaymentInfo(double amount) {
    donationData.update((data) {
      data?.amount = amount;
    });
  }

  void clearDonationData() {
    donationData.value = DonationData();
  }
}
