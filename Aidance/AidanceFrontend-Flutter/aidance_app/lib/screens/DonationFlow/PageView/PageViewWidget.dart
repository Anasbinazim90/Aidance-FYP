import 'package:aidance_app/controllers/DonationFlow_controllers/PageView_controllers/PageView_controller.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/DonationFlow/Complete_transaction/Complete_transaction.dart';
import 'package:aidance_app/screens/DonationFlow/DonationInfo/DonationInfo.dart';
import 'package:aidance_app/screens/DonationFlow/PaywithWallet.dart/PayWithWalletScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({super.key, required this.campaign});

  final NGOCampaignModel? campaign;

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final pageviewcontroller = Get.put(PageViewController());

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageviewcontroller.pageController,
        onPageChanged: (index) {
          pageviewcontroller.activeStep.value = index;
        },
        children: [
          DonationInfoScreen(),
          PayWithWalletScreen(campaign: widget.campaign),
          CompleteTransactionScreen(campaign: widget.campaign),
        ],
      ),
    );
  }
}
