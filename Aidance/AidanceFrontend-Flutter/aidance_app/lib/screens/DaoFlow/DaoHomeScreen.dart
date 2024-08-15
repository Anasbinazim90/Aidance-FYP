import 'dart:developer';

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/components/campaignProposalWidget.dart';
import 'package:aidance_app/components/main_campaign_card.dart';
import 'package:aidance_app/constants.dart';
import 'package:aidance_app/controllers/AuthControllerDao.dart';
import 'package:aidance_app/controllers/transfer_token_controller.dart';
import 'package:aidance_app/services/DaoTokenServices.dart';
import 'package:aidance_app/services/infura.dart';
import 'package:aidance_app/services/pinata.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
// import 'package:web3modal_flutter/web3modal_flutter.dart';

class DaoHomeScreen extends StatefulWidget {
  final String? address;
  DaoHomeScreen({super.key, this.address});

  @override
  State<DaoHomeScreen> createState() => _DaoHomeScreenState();
}

class _DaoHomeScreenState extends State<DaoHomeScreen> {
  final List<String> titles = [
    'PROPOSALS',
    'ELIGIBLE VOTERS ',
    'YOUR VOTING POWER'
  ];

  final List<String> subtitles = [
    'PARTICIPATE AND PROPOSE NOW',
    'JOIN THE DAO NOW AND BECOME ONE',
    'BASED ON YOUR TOKEN BALANCE'
  ];

  bool isLoading = false;
  PlatformFile? pickedfile;
  int totalProposals = 0;

  // metamaskController
  // final MetaMaskProvider metamaskController = Get.put(MetaMaskProvider());
  final PinataServices pinataServices = Get.put(PinataServices());
  final InfuraServices infuraServices = Get.put(InfuraServices());
  final _controller = Get.put(DaoAuthController());
  final transferController = Get.put(TransferTokenController());

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('daoUsers')
          .doc(user.uid)
          .get();
      setState(() {
        userAddress = userDoc['address'];
        print("addresssssss" + userAddress.toString());
      });
    }
  }

  // fetch total proposals from firestore
  _fetchTotalProposals() async {
    await FirebaseFirestore.instance
        .collection('campaigns')
        .where('status', isEqualTo: 'pending')
        .get()
        .then((value) {
      totalProposals = value.docs.length;
    });
    return totalProposals;
  }

  @override
  void initState() {
    _fetchUserData();
    _fetchTotalProposals();
    // TODO: implement initState
    super.initState();
  }

  Future pickImage() async {
    log('pick Image function called');

    // Set isLoading to true to display loading icon
    setState(() {
      isLoading = true;
    });

    // picking file using file picker package
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      log('No file selected');
      // Set isLoading to true to display loading icon
      setState(() {
        isLoading = false;
      });
      return;
    }

    // get the file
    setState(() {
      pickedfile = result.files.first;
      log(pickedfile!.name.toString());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _controller.signout();
              Get.to(RolesScreen());
            },
            icon: Icon(Icons.arrow_back)),
        elevation: 2,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(),
        backgroundColor: myColors.whiteColor,
        title: Text(
          'Home',
          style: MyTextStyles.HeadingStyle()
              .copyWith(color: myColors.theme_turquoise),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // horizontal list of proposal , voters , voting power
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  // decoration: BoxDecoration(border: Border.all()),
                  height: 200.h,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final List<String> headings = [
                        '${totalProposals} Total Proposals',
                        '1 Total Voters',
                        '20'
                      ];

                      return CampaignProposalWidget(
                          title: titles[index],
                          subtitile: subtitles[index],
                          heading: headings[index]);
                    },
                  ),
                ),
                26.h.verticalSpace,

                // Ongoing Campaigns
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    'On Going Fundings',
                    style: MyTextStyles.HeadingStyle(),
                  ),
                ),

                //  List of on going Fundings
                SizedBox(
                  height: 350.h,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return MainCampaignCard();
                    },
                  ),
                ),

                15.h.verticalSpace,
                // Connect wallet button

                //Request Tokens

                transferController.loading.value
                    ? SpinKitWaveSpinner(
                        waveColor: myColors.theme_turquoise,
                        trackColor: myColors.theme_turquoise.withOpacity(0.5),
                        color: myColors.theme_turquoise,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          log(userAddress.toString());
                          transferController.transferTokenApi(
                              userAddress.toString(), "10");
                        },
                        child: Text('Request Tokens'),
                      ),

                95.h.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? userAddress;
