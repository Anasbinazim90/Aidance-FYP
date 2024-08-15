import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/controllers/ApiController/confirm_ngo_controller.dart';
import 'package:aidance_app/controllers/ApiController/get_ngo_data_controller.dart';
import 'package:aidance_app/controllers/ApiController/is_campaign_voted_controller.dart';
import 'package:aidance_app/controllers/ApiController/is_ngo_voted_controller.dart';
import 'package:aidance_app/controllers/ApiController/vote_against_ngo_controller.dart';
import 'package:aidance_app/controllers/ApiController/vote_for_ngo_controller.dart';
import 'package:aidance_app/controllers/DaoControllers/ProposalDetailController.dart';
import 'package:aidance_app/controllers/DaoControllers/ngoTimerController.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/DaoFlow/DaoHomeScreen.dart';
import 'package:aidance_app/screens/DaoFlow/Timer.dart';
import 'package:aidance_app/screens/DaoFlow/ngoTimerScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:clipboard/clipboard.dart';

class NgoVotingscreen extends StatefulWidget {
  NgoVotingscreen({super.key, required this.ngoData});

  final dynamic ngoData;

  @override
  State<NgoVotingscreen> createState() => _NgoVotingscreenState();
}

class _NgoVotingscreenState extends State<NgoVotingscreen> {
  final votingBoxController = Get.put(VotingBoxController());
  final voteForController = Get.put(VoteForNgoConteroller());
  final confirmNgoController = Get.put(ConfirmNgoController());
  final voteAgainstController = Get.put(VoteAgainstNgoConteroller());
  final NgoData = Get.put(GetNgoDataController());
  final Ngotimercontroller _timerController = Get.put(Ngotimercontroller());
  final isNgoVotedController = Get.put(IsNgoVotedController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      NgoData.getAddressApi(widget.ngoData['ngono']);
    });

    isNgoVotedController.checkIfVoted(widget.ngoData['ngono'], userAddress);

    super.initState();
  }

  void checkVotesAndUpdateStatus() async {
    await NgoData.getAddressApi(widget.ngoData['ngono']);
    final ngoData = NgoData.ngoList.value;
    if (int.parse(ngoData.totalInFavorVote ?? '0') >
        int.parse(ngoData.totalAgainstVote ?? '0')) {
      // Update NGO status to active
      updateNgoStatus();
      // Make an API call or perform the necessary action here
      log('NGO status updated to active!');
      // You can call your API to update the NGO status here
    } else {
      log('NGO Rejected not updated.');
      print('NGO status not updated.');
    }
  }

  void updateNgoStatus() async {
    if (int.parse(NgoData.ngoList.value.totalInFavorVote!) >
        int.parse(NgoData.ngoList.value.totalAgainstVote!)) {
      var ngo = await FirebaseFirestore.instance
          .collection('Ngousers')
          .where('ngono', isEqualTo: widget.ngoData['ngono'])
          .get();
      // Replace with the actual document ID
      ngo.docs.first.reference.update({'status': 'active'});
    }
  }

  final User? user = FirebaseAuth.instance.currentUser;

  void copyToClipboard(context) {
    FlutterClipboard.copy(widget.ngoData['address'] ?? '').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 2,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(),
        backgroundColor: myColors.theme_turquoise,
        centerTitle: true,
        title: Text(
          '${widget.ngoData['username']}',
          style: MyTextStyles.HeadingStyle().copyWith(color: Colors.white),
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
                  '${widget.ngoData['username']}',
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 30.sp),
                ),
                RichText(
                    text: TextSpan(children: [
                  // TextSpan(
                  //     text: 'By ',
                  //     style: MyTextStyles.SecondaryTextStyle()
                  //         .copyWith(fontSize: 16.sp)),
                  TextSpan(
                      text: '${widget.ngoData['email']}',
                      style: MyTextStyles.SecondaryTextStyle()
                          .copyWith(fontSize: 16.sp))
                ])),
                50.h.verticalSpace,
                // info about the campaign
                Container(
                  width: double.maxFinite,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NGO Reg. Number',
                            style: MyTextStyles.SecondaryTextStyle().copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.ngoData['ngono']}',
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
                            'NGO Address',
                            style: MyTextStyles.SecondaryTextStyle().copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                padding: EdgeInsets.only(left: 14.w),
                                iconSize: 18.sp,
                                icon: Icon(Icons.copy),
                                onPressed: () => copyToClipboard(context),
                              ),
                              Text(
                                '${Utils().shortenAddress(widget.ngoData['address'])}',
                                style: MyTextStyles.SecondaryTextStyle()
                                    .copyWith(
                                        color: myColors.theme_turquoise,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                50.h.verticalSpace,
                Text(
                  'Mission',
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 26.sp),
                ),

                // Story Paragraph
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('${widget.ngoData['mission']}'),
                ),
                50.h.verticalSpace,

                Text(
                  'KYC Documents (${widget.ngoData['kycdocs'].length})',
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 26.sp),
                ),

                20.h.verticalSpace,

                // GridView of KYC Documents
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.ngoData['kycdocs'].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      List<dynamic> kycDocs = widget.ngoData['kycdocs'];
                      bool isPDF =
                          kycDocs[index]['url'].contains('.pdf') ? true : false;
                      return GestureDetector(
                        onTap: () {
                          // Handle document tap (if needed)
                          if (isPDF)
                            Get.to(() =>
                                PDFViewerScreen(url: kycDocs[index]['url']));
                          else {
                            final imageProvider =
                                Image.network(kycDocs[index]['url']).image;
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
                                  color: myColors.theme_turquoise,
                                  size: 50.sp,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${kycDocs[index]['name']}',
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
                      Obx(
                        () => Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              if (!isNgoVotedController
                                      .userAlreadyVoted.value &&
                                  !votingBoxController.hasVoted.value) {
                                votingBoxController.castVote('For');
                                voteForController.voteForNgo(
                                    widget.ngoData['ngono'].toString(),
                                    userAddress.toString());
                                log('For' +
                                    userAddress.toString() +
                                    widget.ngoData['ngono'].toString());
                                setState(() {});
                              } else {
                                Get.snackbar('Already Voted',
                                    'You have already voted in this campaign');
                              }
                            },
                            child: voteForController.loading.value
                                ? SpinKitWaveSpinner(
                                    waveColor: myColors.theme_turquoise,
                                    trackColor: myColors.theme_turquoise
                                        .withOpacity(0.5),
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
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                              if (!isNgoVotedController
                                      .userAlreadyVoted.value &&
                                  !votingBoxController.hasVoted.value) {
                                votingBoxController.castVote('Against');
                                voteAgainstController.voteAgainstNgo(
                                    widget.ngoData['ngono'].toString(),
                                    userAddress.toString());
                                setState(() {});
                                log('Against');
                              } else {
                                Get.snackbar('Already Voted',
                                    'You have already voted in this campaign');
                              }
                            },
                            child: voteAgainstController.loading.value
                                ? SpinKitWaveSpinner(
                                    waveColor: myColors.theme_turquoise,
                                    trackColor: myColors.theme_turquoise
                                        .withOpacity(0.5),
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
                                        borderRadius:
                                            BorderRadius.circular(10.r),
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
                      // Vote Abstain
                    ],
                  ),
                ),

                20.h.verticalSpace,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Ngotimerscreen(),
                    Obx(
                      () => ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              overlayColor: Colors.white.withOpacity(0.2),
                              backgroundColor: myColors.theme_turquoise,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              )),
                          icon: confirmNgoController.loading.value
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
                          onPressed: () {
                            if (confirmNgoController.areVotesEqual()) {
                              Get.snackbar('Votes Balanced',
                                  'Please wait for the votes to be decisive.');
                            } else {
                              confirmNgoController
                                  .regesterNgoApi(widget.ngoData['ngono']);
                              checkVotesAndUpdateStatus();
                            }
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
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'For',
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 18.sp),
                      ),
                      Text(
                        '${NgoData.ngoList.value.totalInFavorVote.toString()}%',
                        style: MyTextStyles.SecondaryTextStyle().copyWith(
                            color: myColors.theme_turquoise,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                15.h.verticalSpace,
                Obx(
                  () {
                    double votePercentage = 0.0;
                    if (NgoData.ngoList.value.totalInFavorVote != null &&
                        NgoData.ngoList.value.totalInFavorVote!.isNotEmpty) {
                      votePercentage = double.parse(NgoData
                              .ngoList.value.totalInFavorVote
                              .toString()) /
                          100;
                    }
                    return LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(3.r),
                      minHeight: 8.h,
                      value: votePercentage,
                      color: myColors.theme_turquoise,
                      backgroundColor:
                          myColors.theme_turquoise.withOpacity(0.2),
                    );
                  },
                ),
                25.h.verticalSpace,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Against',
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 18.sp),
                      ),
                      Text(
                        NgoData.ngoList.value.totalAgainstVote.toString() + '%',
                        style: MyTextStyles.SecondaryTextStyle().copyWith(
                            color: myColors.theme_turquoise,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                15.h.verticalSpace,
                Obx(() {
                  double votePercentage = 0.0;
                  if (NgoData.ngoList.value.totalAgainstVote != null &&
                      NgoData.ngoList.value.totalAgainstVote!.isNotEmpty) {
                    votePercentage = double.parse(
                            NgoData.ngoList.value.totalAgainstVote.toString()) /
                        100;
                  }
                  return LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(3.r),
                    minHeight: 8.h,
                    value: votePercentage,
                    color: myColors.theme_turquoise,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(myColors.theme_turquoise),
                    backgroundColor: myColors.theme_turquoise.withOpacity(0.2),
                  );
                }),
                25.h.verticalSpace,
              ])),
        ),
      ),
    );
  }

  Container VotingBox() {
    return Container(
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
                votingBoxController.castVote('For');
                log('For');
              },
              child: Obx(
                () => Container(
                  width: 300.w,
                  padding: EdgeInsets.only(
                      right: 150.w, top: 15.h, bottom: 15.h, left: 10.w),
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                  child: Text(
                    'For',
                    style: TextStyle(
                      color: votingBoxController.selectedOption.value == 'For'
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: votingBoxController.selectedOption.value == 'For'
                          ? Palette.theme_turquoise
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(width: 1, color: Colors.grey)),
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
                  votingBoxController.castVote('Against');
                  log('Against');
                },
                child: Container(
                    width: 300.w,
                    padding: EdgeInsets.only(
                        right: 150.w, top: 15.h, bottom: 15.h, left: 10.w),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: votingBoxController.selectedOption.value ==
                                'Against'
                            ? myColors.theme_turquoise
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(width: 1, color: Colors.grey)),
                    // padding:
                    //     EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    child: Text(
                      'Against',
                      style: TextStyle(
                        color: votingBoxController.selectedOption.value ==
                                'Against'
                            ? Colors.white
                            : Colors.grey,
                      ),
                    )),
              ),
            ),
          ),
          // Vote Abstain
        ],
      ),
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  final String url;
  PDFViewerScreen({required this.url});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  PDFDocument? document;

  void initilizePDF() async {
    document = await PDFDocument.fromURL(widget.url);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    initilizePDF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document != null
          ? PDFViewer(
              backgroundColor: myColors.light_theme,
              document: document!,
            )
          : Center(
              child: SpinKitWaveSpinner(
              waveColor: myColors.theme_turquoise,
              trackColor: myColors.theme_turquoise.withOpacity(0.5),
              color: myColors.theme_turquoise,
            )),
    );
  }
}
