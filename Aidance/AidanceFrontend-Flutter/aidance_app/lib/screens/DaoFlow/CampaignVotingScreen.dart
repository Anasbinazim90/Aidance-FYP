import 'dart:developer';

import 'package:aidance_app/controllers/ApiController/confirm_campaign_controlelr.dart';
import 'package:aidance_app/controllers/ApiController/get_campaign_data_controller.dart';
import 'package:aidance_app/controllers/ApiController/is_campaign_voted_controller.dart';
import 'package:aidance_app/controllers/ApiController/vote_against_campaign.dart';
import 'package:aidance_app/controllers/ApiController/vote_for_campaign.dart';
import 'package:aidance_app/controllers/DaoControllers/ProposalDetailController.dart';
import 'package:aidance_app/controllers/DaoControllers/campaignVotingController.dart';
import 'package:aidance_app/helper/helper_methods.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/DaoFlow/DaoHomeScreen.dart';
import 'package:aidance_app/screens/DaoFlow/NgoVotingScreen.dart';
import 'package:aidance_app/screens/DaoFlow/Timer.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CampaignVotingScreen extends StatefulWidget {
  CampaignVotingScreen({super.key, required this.proposal});

  final dynamic proposal;

  @override
  State<CampaignVotingScreen> createState() => _CampaignVotingScreenState();
}

class _CampaignVotingScreenState extends State<CampaignVotingScreen> {
  final votingBoxController = Get.put(CampaignVotingController());

  final voteForController = Get.put(VoteForCampaignController());

  final confirmcaimpaignController = Get.put(ConfirmCampaignController());

  final voteAgainstController = Get.put(VoteAgainstCampaignController());

  final campaignData = Get.put(GetCampaignDataController());
  final isCampaignVotedController = Get.put(IsCampaignVotedController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      campaignData.getAddressApi(widget.proposal['tokenId']);
      log(campaignData.campaignList.value.campaignId.toString());

      isCampaignVotedController.checkIfVoted(
          widget.proposal['tokenId'], userAddress);
    });

    super.initState();
  }

  void checkVotesAndUpdateStatus() async {
    log('checkVotesAndUpdateStatus called');
    await campaignData.getAddressApi(widget.proposal['tokenId']);

    final campaingdata = campaignData.campaignList.value;
    if (int.parse(campaingdata.totalInFavorVoteCampaign ?? '0') >
        int.parse(campaingdata.totalAgainstVoteCampaign ?? '0')) {
      // Update NGO status to active
      updateCampaignStatus();
      // Make an API call or perform the necessary action here
      log('NGO status updated to active!');
      // You can call your API to update the NGO status here
    } else {
      log('NGO Rejected not updated.');
      print('NGO status not updated.');
    }
  }

  void updateCampaignStatus() async {
    log('updating campaign status');
    if (int.parse(campaignData.campaignList.value.totalInFavorVoteCampaign!) >
        int.parse(campaignData.campaignList.value.totalAgainstVoteCampaign!)) {
      var ngo = await FirebaseFirestore.instance
          .collection('campaigns')
          .where('tokenId', isEqualTo: widget.proposal['tokenId'])
          .get();
      // Replace with the actual document ID
      ngo.docs.first.reference.update({'status': 'active'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.proposal['title']}',
        ),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: MyPaddingStyle.myPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimateList(interval: 50.ms, effects: [
              FadeEffect(duration: 300.ms),
              SlideEffect(begin: const Offset(0, 0.1), duration: 300.ms),
            ], children: [
              Text(
                '${widget.proposal['title']}',
                style: MyTextStyles.HeadingStyle().copyWith(fontSize: 30.sp),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'By ',
                    style: MyTextStyles.SecondaryTextStyle()
                        .copyWith(fontSize: 16.sp)),
                TextSpan(
                    text: '${widget.proposal['ngoName']} ',
                    style: MyTextStyles.SecondaryTextStyle().copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: myColors.theme_turquoise)),
              ])),
              50.h.verticalSpace,
              // info about the campaign
              Container(
                // width: 200.w,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount needed',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.proposal['total_donation_required']}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End Date',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${convertDateString(widget.proposal['donation_expiration_date'])}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NGO registeration no',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(widget.proposal['registrationID'])}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Campaign ID',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(widget.proposal['tokenId'])}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              50.h.verticalSpace,
              Text(
                'Story',
                style: MyTextStyles.HeadingStyle().copyWith(fontSize: 26.sp),
              ),

              // Story Paragraph
              Container(
                alignment: Alignment.centerLeft,
                child: Text('${widget.proposal['story']}'),
              ),
              50.h.verticalSpace,

              Text(
                'Documents (${widget.proposal['additional_docs'].length})',
                style: MyTextStyles.HeadingStyle().copyWith(fontSize: 26.sp),
              ),

              20.h.verticalSpace,

              // GridView of KYC Documents
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.proposal['additional_docs'].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    List<dynamic> documents =
                        widget.proposal['additional_docs'];
                    bool isPDF =
                        documents[index]['url'].contains('.pdf') ? true : false;
                    return GestureDetector(
                      onTap: () {
                        // Handle document tap (if needed)
                        if (isPDF)
                          Get.to(() =>
                              PDFViewerScreen(url: documents[index]['url']));
                        else {
                          final imageProvider =
                              Image.network(documents[index]['url']).image;
                          showImageViewer(context, imageProvider,
                              barrierColor: Colors.black54,
                              swipeDismissible: true, onViewerDismissed: () {
                            log("dismissed");
                          });
                        }
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isPDF ? Icons.file_copy : Icons.image,
                                size: 50.sp,
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${documents[index]['name']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

              50.h.verticalSpace,
              // Vote

              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Column(
                  children: [
                    // Vote heading
                    Container(
                      margin: EdgeInsets.only(left: 5.w),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Vote',
                        style: MyTextStyles.HeadingStyle(),
                      ),
                    ),
                    // Vote For
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          if (!isCampaignVotedController
                              .userAlreadyVoted.value) {
                            votingBoxController.castVote('For');
                            voteForController.VoteForCampaignApi(
                                widget.proposal['tokenId'].toString(),
                                userAddress.toString());
                            log('For' +
                                userAddress.toString() +
                                widget.proposal['tokenId'].toString());
                            setState(() {
                              campaignData.campaignList.refresh();
                            });
                          } else {
                            Get.snackbar('Already Voted',
                                'You have already voted in this campaign');
                          }
                        },
                        child: Obx(
                          () => voteForController.loading.value
                              ? SpinKitWaveSpinner(
                                  waveColor: myColors.theme_turquoise,
                                  trackColor:
                                      myColors.theme_turquoise.withOpacity(0.5),
                                  color: myColors.theme_turquoise,
                                )
                              : Container(
                                  width: 300.w,
                                  padding: EdgeInsets.only(
                                      right: 150.w,
                                      top: 15.h,
                                      bottom: 15.h,
                                      left: 10.w),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 5.w),
                                  child: Text(
                                    'For',
                                    style: TextStyle(
                                      color: votingBoxController
                                                  .selectedOption.value ==
                                              'For'
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: votingBoxController
                                                  .selectedOption.value ==
                                              'For'
                                          ? Palette.theme_turquoise
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                ),
                        ),
                      ),
                    ),
                    // Vote Against
                    Obx(
                      () => Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (!isCampaignVotedController
                                .userAlreadyVoted.value) {
                              votingBoxController.castVote('Against');
                              voteAgainstController.VoteAgainstCampaign(
                                  widget.proposal['tokenId'].toString(),
                                  userAddress.toString());
                              setState(() {
                                campaignData.campaignList.refresh();
                              });
                              log('Against');
                            } else {
                              Get.snackbar('Already Voted',
                                  'You have already voted in this campaign');
                            }
                          },
                          child: voteAgainstController.loading.value
                              ? SpinKitWaveSpinner(
                                  waveColor: myColors.theme_turquoise,
                                  trackColor:
                                      myColors.theme_turquoise.withOpacity(0.5),
                                  color: myColors.theme_turquoise,
                                )
                              : Container(
                                  width: 300.w,
                                  padding: EdgeInsets.only(
                                      right: 150.w,
                                      top: 15.h,
                                      bottom: 15.h,
                                      left: 10.w),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                      color: votingBoxController
                                                  .selectedOption.value ==
                                              'Against'
                                          ? myColors.theme_turquoise
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  // padding:
                                  //     EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                                  child: Text(
                                    'Against',
                                    style: TextStyle(
                                      color: votingBoxController
                                                  .selectedOption.value ==
                                              'Against'
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              20.h.verticalSpace,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TimerScreen(),
                  Obx(
                    () => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            overlayColor: Colors.white.withOpacity(0.2),
                            backgroundColor: myColors.theme_turquoise,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            )),
                        icon: confirmcaimpaignController.loading.value
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.login_sharp),
                        onPressed: () async {
                          if (confirmcaimpaignController.areVotesEqual()) {
                            Get.snackbar('Votes Balanced',
                                'Please wait for the votes to be decisive.');
                          } else {
                            confirmcaimpaignController.regesterCampaignApi(
                                widget.proposal['tokenId']);
                            checkVotesAndUpdateStatus();
                          }

                          // await confirmcaimpaignController
                          //     .regesterCampaignApi(widget.proposal['tokenId']);
                          // checkVotesAndUpdateStatus();
                        },
                        label: Text('End Voting')),
                  )
                ],
              ),

              //
              // Results
              50.h.verticalSpace,
              Text(
                'Results',
                style: MyTextStyles.HeadingStyle(),
              ),
              15.h.verticalSpace,
              Obx(
                () {
                  double votePercentage = 0.0;
                  double againstVotePercentage = 0.0;

                  if (campaignData
                          .campaignList.value.totalInFavorVoteCampaign !=
                      null) {
                    votePercentage = int.parse(campaignData
                            .campaignList.value.totalInFavorVoteCampaign!) /
                        100;
                  }

                  if (campaignData
                          .campaignList.value.totalAgainstVoteCampaign !=
                      null) {
                    againstVotePercentage = int.parse(campaignData
                            .campaignList.value.totalAgainstVoteCampaign!) /
                        100;
                  }

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'For',
                            style: MyTextStyles.HeadingStyle()
                                .copyWith(fontSize: 18.sp),
                          ),
                          Text(
                            '${votePercentage * 100}%',
                            style: MyTextStyles.SecondaryTextStyle().copyWith(
                                color: myColors.theme_turquoise,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      15.h.verticalSpace,
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(3.r),
                        minHeight: 8.h,
                        value: votePercentage,
                        color: myColors.theme_turquoise,
                        backgroundColor:
                            myColors.theme_turquoise.withOpacity(0.2),
                      ),
                      25.h.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Against',
                            style: MyTextStyles.HeadingStyle()
                                .copyWith(fontSize: 18.sp),
                          ),
                          Text(
                            // '${campaignData.campaignList.value.totalAgainstVoteCampaign.toString()}%',
                            '${againstVotePercentage * 100}%',
                            style: MyTextStyles.SecondaryTextStyle().copyWith(
                                color: myColors.theme_turquoise,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      15.h.verticalSpace,
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(3.r),
                        minHeight: 8.h,
                        value: againstVotePercentage,
                        color: myColors.theme_turquoise,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            myColors.theme_turquoise),
                        backgroundColor:
                            myColors.theme_turquoise.withOpacity(0.2),
                      ),
                    ],
                  );
                },
              ),

              25.h.verticalSpace,
            ]),
          ),
        ),
      ),
    );
  }
}
