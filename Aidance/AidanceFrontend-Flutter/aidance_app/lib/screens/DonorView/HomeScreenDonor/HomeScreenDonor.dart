import 'dart:developer';

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/ApiController/get_addr_controller.dart';
import 'package:aidance_app/controllers/ApiController/get_native_balance_controller.dart';
import 'package:aidance_app/controllers/DonorViewController/HomeControllerDonor/HomeControllerDonor.dart';
import 'package:aidance_app/controllers/NgoCampaignModelController.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DonorView/CampaignDetailScreenDonor/CampaignDetailScreenDonor.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ngoProposalController = Get.put(NGOProposalController());

  List<NGOCampaignModel> campaign = [];

  // void fetchNgos() async {
  final _nativeBalancecontroller = Get.put(GetNativeBalanceController());

  // final auth_controller_donor = Get.put(AuthController());

  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? DonorData;

  Future<void> fetchCurrentUserData() async {
    if (user != null) {
      DocumentSnapshot DonorDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        DonorData = DonorDoc.data() as Map<String, dynamic>?;
        DonorAddress = DonorData?['address'];
      });

      // Fetch balance after setting userAddress
      if (DonorAddress != null) {
        _nativeBalancecontroller.getBalanceApi(DonorAddress!);
      }
    }
    log(DonorData.toString());
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerDonor>(
        init: HomeControllerDonor(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            // drawer: CustomDrawer(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // leading: IconButton(
              //     onPressed: () {
              //       Get.to(RolesScreen());
              //     },
              //     icon: Icon(Icons.arrow_back)),
              scrolledUnderElevation: 0,
              title: Text('Home', style: MyTextStyles.HeadingStyle()),

              // leading: IconButton(
              //   onPressed: () {
              //     Scaffold.of(context).openDrawer();
              //   },
              //   icon: Icon(CupertinoIcons.text_justify),
              // ),
              actions: [
                Icon(
                  CupertinoIcons.bell,
                  size: 24.h,
                ),
                SizedBox(width: 14.w),
              ],
            ),

            body: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Text(
                    'Featured Campaigns',
                    style: MyTextStyles.HeadingStyle(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),

              // CARD 1

              SliverToBoxAdapter(
                child: Expanded(
                  child: SizedBox(
                      height: 400.h,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('campaigns')
                              .where('status', isEqualTo: 'active')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: SpinKitWaveSpinner(
                                waveColor: myColors.theme_turquoise,
                                trackColor:
                                    myColors.theme_turquoise.withOpacity(0.5),
                                color: myColors.theme_turquoise,
                              ));
                            }

                            if (snapshot.hasError) {
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
                                scrollDirection: Axis.horizontal,
                                itemCount: activeCampaigns.length,
                                itemBuilder: (context, index) {
                                  NGOCampaignModel campaign =
                                      activeCampaigns[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          duration: 300.ms,
                                          transition: Transition.fadeIn,
                                          () => CampaignDetailScreen(
                                                story: "${campaign.story}",
                                                proposal: campaign,
                                              ));
                                    },
                                    child: CampaignCardWidget(
                                      campaign: campaign,
                                    ),
                                  );
                                });
                          })

                      //  ListView.builder(
                      //   physics: const BouncingScrollPhysics(),
                      //   scrollDirection: Axis.horizontal,
                      //   itemCount: 1,
                      //   itemBuilder: (context, index) {
                      //     return GestureDetector(
                      //       onTap: () {
                      //         Get.toNamed(AppRoutes.campaignDetailScreen);
                      //       },
                      //       child: CampaignCardWidget(
                      //         title: "TurKey Earthquake",
                      //         description:
                      //             "Providing urgent relief to the people of Turkey, affected by the earthquake.",
                      //         total_donation: "24,000\$",
                      //         total_funded: "12,000\$",
                      //         progress: "In progress",
                      //         percentage: "50%",
                      //       ),
                      //     );
                      //   },
                      // ),
                      ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 60.h),
              ),
            ]),
          );
        });
  }
}

class CampaignCardWidget extends StatelessWidget {
  const CampaignCardWidget({
    super.key,
    required this.campaign,
  });

  final NGOCampaignModel campaign;

  @override
  Widget build(BuildContext context) {
    // Parse the string values to double
    double totalDonationsRequired =
        double.parse(campaign.total_donation_required);
    double totalDonationsReceived =
        double.parse(campaign.total_donations_received);

    // Calculate the progress value
    double progressValue = totalDonationsReceived / totalDonationsRequired;
    // Calculate the percentage
    int percentage = (progressValue * 100).toInt();

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        margin: EdgeInsets.only(right: 10.w, bottom: 10.h, left: 16.w),
        // height: double.infinity,
        width: 300.w,
        decoration: BoxDecoration(
          color: myColors.whitebgcolor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: CachedNetworkImage(
                imageUrl: campaign.cover_photo[0],
                placeholder: (context, url) {
                  return Center(
                    child: Container(
                      color: Colors.grey.withOpacity(0.5),
                      width: 300.w,
                      height: 200.h,
                    ).animate(onPlay: (anim) => anim.repeat()).shimmer(),
                  );
                },
                width: 300.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.w, top: 10.h, bottom: 10.h, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: 250.w,
                          child: Text("${campaign.title}",
                              style: TextStyle(
                                  fontFamily: 'Epilogue',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: myColors.HeadingColor)),
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 30.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: myColors.light_theme,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              totalDonationsRequired == totalDonationsReceived
                                  ? "Completed"
                                  : "In Progress",
                              style: TextStyle(
                                color: Color(0xFF00BDD6),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0.14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "${campaign.description}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: MyTextStyles.Subtitle(),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),

                  /// Progress Bar and Percentage

                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progressValue,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              myColors.theme_turquoise),
                          backgroundColor: myColors.light_theme,
                        ),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Container(
                        width: 60.w,
                        height: 30.h,
                        padding: const EdgeInsets.only(
                            top: 4, left: 8, right: 9, bottom: 4),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: myColors.light_theme,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "$percentage%",
                              style: TextStyle(
                                color: Color(0xFF00BDD6),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0.14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Raised Amount and Goal Amount

                  Row(
                    children: [
                      Text(
                        campaign.total_donations_received,
                        style: TextStyle(
                          color: const Color(0xFF00BDD6),
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "of",
                        style: TextStyle(
                          color: myColors.HeadingColor,
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "${campaign.total_donation_required}\$",
                        style: TextStyle(
                          color: const Color(0xFF00BDD6),
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "funded",
                        style: TextStyle(
                          color: myColors.HeadingColor,
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  /// End of Raised Amount and Goal Amount

                  /// Urgent Fundraising
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? DonorAddress;
