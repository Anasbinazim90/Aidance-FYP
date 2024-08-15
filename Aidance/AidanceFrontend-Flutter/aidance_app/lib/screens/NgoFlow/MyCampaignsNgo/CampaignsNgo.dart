// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:aidance_app/Components/compaign_card.dart';
import 'package:aidance_app/controllers/catController.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/NgoFlow/NgoCampaignDetailsScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class CompaignView extends StatefulWidget {
  const CompaignView({super.key});

  @override
  State<CompaignView> createState() => _CompaignViewState();
}

class _CompaignViewState extends State<CompaignView> {
  final List<String> catNames = [
    "All (25)",
    "Ongoing (3)",
    "Past (22)",
    "Pending (1)",
  ];
  final controller = Get.put(ChipsController());
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? ngoData;
  bool isLoading = true;

  Future<void> fetchCurrentNgoData() async {
    if (user != null) {
      DocumentSnapshot ngoDoc = await FirebaseFirestore.instance
          .collection('Ngousers')
          .doc(user!.uid)
          .get();

      setState(() {
        ngoData = ngoDoc.data() as Map<String, dynamic>?;
        isLoading = false;
      });
    }
  }

  Future<void> handleRefresh() async {
    await fetchCurrentNgoData();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchCurrentNgoData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.whitebgcolor,
        body: Column(
          children: [
            25.h.verticalSpace,
            GetBuilder(
                init: controller,
                builder: (context) {
                  return SizedBox(
                    height: 32.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 7.w, left: 7.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: GestureDetector(
                            onTap: () {
                              controller.setCattIndex(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.r),
                                  border: Border.all(
                                      color: myColors.theme_turquoise),
                                  color: controller.catIndex == index
                                      ? myColors.theme_turquoise
                                      : Colors.white),
                              height: 32.h,
                              width: 90.w,
                              child: Center(
                                  child: Text(
                                catNames[index],
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: controller.catIndex == index
                                      ? Colors.white
                                      : myColors.theme_turquoise,
                                ),
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
            30.h.verticalSpace,
            isLoading
                ? Center(
                    child: SpinKitWaveSpinner(
                    waveColor: myColors.theme_turquoise,
                    trackColor: myColors.theme_turquoise.withOpacity(0.5),
                    color: myColors.theme_turquoise,
                  ))
                : Expanded(
                    child: LiquidPullToRefresh(
                      animSpeedFactor: 2,
                      height: 200.h,
                      color: myColors.theme_turquoise,
                      backgroundColor: Colors.white,
                      onRefresh: handleRefresh,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('campaigns')
                              .where(
                                'registrationID',
                                isEqualTo: '${ngoData!['ngono']}',
                              )
                              .where('status', isEqualTo: 'active')
                              .orderBy('tokenId', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: SizedBox());
                            }

                            if (snapshot.hasError) {
                              log('Error fetching campaigns: ${snapshot.error}');
                              return Center(
                                  child: Text('Error fetching campaigns'));
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text('No active campaigns available'));
                            }
                            var activeCampaigns =
                                snapshot.data!.docs.map((doc) {
                              return NGOCampaignModel.fromJson(doc.data());
                            }).toList();
                            return ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    right: 7.w, left: 7.w, bottom: 12.h),
                                scrollDirection: Axis.vertical,
                                itemCount: activeCampaigns.length,
                                itemBuilder: (context, index) {
                                  var donationsArray = snapshot
                                          .data!.docs[index]
                                          .data()
                                          .containsKey('donations')
                                      ? snapshot.data!.docs[index]['donations']
                                      : [];

                                  var donationsLength = donationsArray.length;
                                  NGOCampaignModel campaign =
                                      activeCampaigns[index];
                                  return GestureDetector(
                                      onTap: () {
                                        // get the donations array length from firestore

                                        Get.to(
                                            duration: 300.ms,
                                            transition: Transition.fadeIn,
                                            () => NGOCampaignDetailScreen(
                                                  proposal: campaign,
                                                ));
                                      },
                                      child: CompaignCard(
                                        campaign: campaign,
                                        donationsLength: donationsLength,
                                      ));
                                });
                          }),
                    ),
                  )
          ],
        ));
  }
}
