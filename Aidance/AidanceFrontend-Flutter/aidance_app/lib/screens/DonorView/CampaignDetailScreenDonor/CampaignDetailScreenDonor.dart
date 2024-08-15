import 'dart:developer';
import 'dart:ui';

import 'package:aidance_app/controllers/ApiController/get_campaign_data_controller.dart';
import 'package:aidance_app/controllers/ClipBoardController.dart';
import 'package:aidance_app/controllers/TabBarController.dart';
import 'package:aidance_app/helper/helper_methods.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DonationFlow/PageView/MainPageViewScreen.dart';
import 'package:aidance_app/screens/DonorView/CampaignDetailScreenDonor/Widget/ProgressWithText.dart';
import 'package:aidance_app/screens/DonorView/DataTableScreenDonor/DataTableScreenDonor.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CampaignDetailScreen extends StatefulWidget {
  CampaignDetailScreen({
    super.key,
    required this.proposal,
    required this.story,
  });
  final NGOCampaignModel proposal;

  // final String? ngoName;
  // final String totalDonationRequired;
  // final DateTime? date;
  // final Image? ngoImage;
  // final String story;
  final String? story;

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final tabs = ['Details', 'Donation Records', 'FAQ'];

  final campaignData = Get.put(GetCampaignDataController());
  final DataTableController dataTableController =
      Get.put(DataTableController());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      campaignData.getAddressApi(widget.proposal.tokenId);

    });
    dataTableController.fetchDonations(widget.proposal.tokenId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxToScroll) {
                  return <Widget>[
                    SliverToBoxAdapter(
                        child: Body(
                      // title: "${proposal.title}",
                      // total_funds_required:
                      //     "${proposal.total_donation_required}",
                      // expiration_date: "${proposal.donation_expiration_date}",
                      // name_of_ngo: "${proposal.ngoName}",
                      // images: proposal.cover_photo,
                      proposal: widget.proposal,
                    )),
                    SliverPersistentHeader(
                      delegate: TabSliverDelegate(
                        TabBar(
                          // labelPadding: EdgeInsets.zero,

                          dividerColor: Colors.transparent,
                          // isScrollable: true,
                          indicatorColor: myColors.theme_turquoise,
                          labelColor: myColors.theme_turquoise,
                          unselectedLabelColor: myColors.HeadingColor,
                          isScrollable: true,
                          tabs: tabs
                              .map(
                                (e) => Container(
                                  child: Tab(
                                    child: Text(e,
                                        // style: const TextStyle(color: Colors.black),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    /// Details Tab
                    ///
                    ///
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: AnimateList(
                            interval: 50.ms,
                            effects: [
                              FadeEffect(duration: 300.ms),
                              SlideEffect(
                                  begin: const Offset(0, 0.1),
                                  duration: 300.ms),
                            ],
                            children: [
                              Text("What happened?",
                                  style: MyTextStyles.HeadingStyle()),
                              SizedBox(height: 10.h),
                              Text(
                                "${widget.proposal.story}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Donation Record Tab
                    ///
                    ///
                    Animate(
                      effects: [
                        FadeEffect(duration: 300.ms),
                        SlideEffect(
                            begin: const Offset(0, 0.05), duration: 300.ms),
                      ],
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Obx(
                          () => CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  SizedBox(height: 30.h),
                                  Row(
                                    children: [
                                      Text("Donation Records",
                                          style: MyTextStyles.HeadingStyle()),
                                      Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(() => DataTableScreen(
                                                campaignId:
                                                    widget.proposal.tokenId,
                                              ));
                                        },
                                        child: Text(
                                          'View all',
                                          style: TextStyle(
                                            color: const Color(0xFF00BDD6),
                                            fontSize: 15.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0.14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                ]),
                              ),
                              dataTableController.data.length == 0
                                  ? SliverList(
                                      delegate: SliverChildListDelegate([
                                        Center(
                                          child: Text(
                                            "No records found",
                                            style: TextStyle(
                                              color: myColors.HeadingColor,
                                              fontSize: 15.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0.14,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    )
                                  : SliverList(
                                      delegate: SliverChildListDelegate([
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(AppImages.ethIcon,
                                                  width: 20.w),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "ETH",
                                                style: MyTextStyles
                                                    .SecondaryTextStyle(),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 25.w,
                                          ),
                                          Obx(
                                            () => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    dataTableController
                                                        .data[0].DonorName,
                                                    style: TextStyle(
                                                        color: myColors
                                                            .HeadingColor,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Inter')),
                                                Text(
                                                  dataTableController
                                                      .data[0].Date,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          Obx(
                                            () => Row(
                                              children: [
                                                Text(
                                                  dataTableController
                                                      .data[0].Amount
                                                      .toString(),
                                                  style: MyTextStyles
                                                      .SecondaryTextStyle(),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.bottomSheet(
                                                        DonationDetailsBottomSheet2(
                                                      donationDetails:
                                                          dataTableController
                                                              .data[0],
                                                    ));
                                                  },
                                                  child: const Icon(
                                                    Icons.more_horiz_rounded,
                                                    color:
                                                        myColors.HeadingColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ])),
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                SizedBox(height: 30.h),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  children: [
                                    Text("Allocation Records",
                                        style: MyTextStyles.HeadingStyle()),
                                    Spacer(),

                                    Padding(
                                      padding: EdgeInsets.only(right: 15.w),

                                      child: Text(
                                        'View all',
                                        style: TextStyle(
                                          color: const Color(0xFF00BDD6),
                                          fontSize: 15.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 0.14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 30.h),
                              ])),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: 2,
                                  (BuildContext context, index) {
                                    return GridView.count(
                                      crossAxisCount: 2,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: const PageScrollPhysics(),
                                      children: List.generate(
                                        2,
                                        (index) {
                                          return Padding(
                                            padding: EdgeInsets.all(5.h),
                                            child: PhysicalModel(
                                              color: Colors.transparent,
                                              elevation: 2,
                                              shadowColor: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: myColors.light_theme,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20.r),

                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "C**E",
                                                      style: MyTextStyles
                                                          .HeadingStyle(),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                      "10 ETH",
                                                      style: TextStyle(
                                                        color: myColors
                                                            .theme_turquoise,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Inter',
                                                      ),
                                                    ),
                                                    SizedBox(height: 15.h),
                                                    Text(
                                                      "2022-07-23",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Inter',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SliverList(
                                  delegate: SliverChildListDelegate([
                                SizedBox(height: 100.h),
                              ])),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// FAQ Tab
                    ///
                    ///
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: SingleChildScrollView(
                        child: Column(
                          children: AnimateList(
                            interval: 100.ms,
                            effects: [
                              FadeEffect(duration: 300.ms),
                              SlideEffect(
                                  begin: const Offset(0, 0.1),
                                  duration: 300.ms),
                            ],
                            children: [FAQ_Card(), FAQ_Card(), FAQ_Card()],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                    child: const Icon(
                      color: Colors.white,
                      Icons.arrow_back,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 360.w,
        height: 52.h,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          backgroundColor: myColors.theme_turquoise,
          foregroundColor: myColors.whitebgcolor,
          onPressed: () {
            Get.to(() => MainPageViewScreen(
                  campaign: widget.proposal,
                ));
          },
          label: const Text('Donate Now'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CampaignTitle extends StatelessWidget {
  const CampaignTitle({
    super.key,
    required this.size,
    this.title,
    required this.images,
  });

  final Size size;
  final String? title;
  final dynamic images;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SliderController());

    // List<Map<String, dynamic>> imageList = [
    //   {"id": 1, "image_path": "assets/images/sandstorm.jpg"},
    //   {"id": 2, "image_path": "assets/images/ngo_compaign.jpeg"},
    //   {"id": 3, "image_path": "assets/images/sandstorm.jpg"}
    // ];
    List<String> imageList = images;
    return Animate(
      effects: [
        FadeEffect(duration: 300.ms),
        SlideEffect(begin: const Offset(0, 0.1), duration: 300.ms),
      ],
      child: SizedBox(
        // 40% of our total height
        height: size.height * 0.4,
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                print(controller.currentIndex.value);
              },
              child: CarouselSlider(
                items: imageList
                    .map(
                      (item) => CachedNetworkImage(
                        imageUrl: item,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    .toList(),
                carouselController: controller.carouselController,
                options: CarouselOptions(
                  height: size.height * 0.35,
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: imageList.length > 1,
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    controller.currentIndex.value = index;
                  },
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                // it will cover 90% of our total width
                width: size.width * 0.95,
                height: 100.h,
                decoration: BoxDecoration(
                  color: myColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    topLeft: Radius.circular(50.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 10.r,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      // Title OF Campaign

                      Text("${title}", style: MyTextStyles.HeadingStyle()),
                    ],
                  ),
                ),
              ),
            ),
            // Back Button
            // SafeArea(
            //     child: BackButton(
            //   color: Colors.white,
            // )),
          ],
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key, required this.proposal});
  final NGOCampaignModel proposal;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TabBarController tabBarController = Get.put(TabBarController());

  final campaignData = Get.put(GetCampaignDataController());

  @override
  Widget build(BuildContext context) {
    double totalDonationsRequired =
        double.parse(widget.proposal.total_donation_required);
    double totalDonationsReceived =
        double.parse(widget.proposal.total_donations_received);

    // Calculate the progress value
    double progressValue = totalDonationsReceived / totalDonationsRequired;
    // Calculate the percentage
    int percentage = (progressValue * 100).toInt();
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CampaignTitle(
            images: widget.proposal.cover_photo,
            size: size,
            title: widget.proposal.title,
          ),
          const SizedBox(height: 20 / 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: SingleChildScrollView(
              child: Column(
                children: AnimateList(
                  interval: 20.ms,
                  effects: [
                    FadeEffect(duration: 300.ms),
                    SlideEffect(begin: const Offset(0, -0.1), duration: 300.ms),
                  ],
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Organized by",
                              style: TextStyle(
                                color: myColors.HeadingColor,
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "${widget.proposal.ngoName}",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 191, 0),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            )
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Expired on:",
                                  style: TextStyle(
                                    color: myColors.HeadingColor,
                                    fontSize: 12.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  "${widget.proposal.donation_expiration_date}",
                                  style: TextStyle(
                                    color: myColors.HeadingColor,
                                    fontSize: 12.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              // "${campaignData.campaignList.value.maxReceivedDonationTotal}",
                              '${widget.proposal.total_donations_received}',
                              style: TextStyle(
                                color: const Color(0xFF00BDD6),
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "of",
                              style: TextStyle(
                                color: myColors.HeadingColor,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "${widget.proposal.total_donation_required} tokens",
                              style: TextStyle(
                                color: const Color(0xFF00BDD6),
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Funded",
                              style: TextStyle(
                                color: myColors.HeadingColor,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
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
                                '$percentage%',
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
                    Row(
                      children: [
                        Text(
                          'No of Beneficiaries : ',
                          style: TextStyle(
                            color: myColors.HeadingColor,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${widget.proposal.total_no_of_beneficiaries}",
                          style: TextStyle(
                            color: const Color(0xFF00BDD6),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            myColors.theme_turquoise),
                        backgroundColor: myColors.light_theme,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    AppCard(
                      height: 400.h,
                      child: Column(
                        children: [
                          const Text(
                            "Total Raised",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 200.h,
                            child: ProgressWithText(

                              value: totalDonationsReceived,
                              indicatorValue: progressValue,

                              title: 'Tokens',
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Column(
                            children: [
                              /// Raised Amount
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget
                                          .proposal.total_donations_received,
                                      style: TextStyle(
                                        color: Color(0xFF00BDD6),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0.10,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(
                                        color: Color(0xFF171A1F),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 0.10,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '≈',
                                      style: TextStyle(
                                        color: Color(0xFF00BDD6),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 0.10,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(
                                        color: Color(0xFF171A1F),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 0.10,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${widget.proposal.total_donation_required} ETH',
                                      style: TextStyle(
                                        color: myColors.HeadingColor,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0.10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 15.h,
                                    width: 20.w,
                                    color: myColors.theme_turquoise,
                                  ),
                                  SizedBox(width: 20.w),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Total funding ≈ ',
                                          style: TextStyle(
                                            color: myColors.HeadingColor,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            height: 0.10,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.proposal.total_donations_received} ETH',
                                          style: TextStyle(
                                            color: myColors.HeadingColor,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 15.h,
                                    width: 20.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 20.w),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Total allocated ≈ ',
                                          style: TextStyle(
                                            color: myColors.HeadingColor,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            height: 0.10,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.proposal.total_donations_received} ETH",
                                          style: TextStyle(
                                            color: myColors.HeadingColor,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                        color: myColors.whiteColor,
                      ),
                      height: 110.h,
                      width: double.infinity,
                      child: Card(
                        color: myColors.whiteColor,
                        margin: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 5.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5.h, left: 15.w, right: 10.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.r),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,

                                    height: 50,
                                    width: 50,
                                    imageUrl: widget.proposal.cover_photo[0],
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${widget.proposal.ngoName}",
                                      style: TextStyle(
                                        color: myColors.HeadingColor,
                                        fontSize: 18.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Row(
                                    children: [
                                      Text("Verified",
                                          style: TextStyle(
                                            color: myColors.HeadingColor,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter',
                                          )),
                                      SizedBox(width: 5.w),
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 100.w,
                                height: 40.h,
                                padding: const EdgeInsets.only(
                                    top: 4, left: 8, right: 9, bottom: 4),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: myColors.light_theme,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Follow',
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TabSliverDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool space;
  TabSliverDelegate(this.tabBar, {this.space = false});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: tabBar,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}

// class MyTimeLineWidget extends StatelessWidget {
//   final bool isFirst;
//   final bool isPast;
//   final bool isLast;
//   final progressText;

//   const MyTimeLineWidget(
//       {super.key,
//       required this.isFirst,
//       required this.isPast,
//       required this.isLast,
//       this.progressText});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 120.h,
//       child: TimelineTile(
//         isFirst: isFirst,
//         isLast: isLast,
//         beforeLineStyle: LineStyle(
//             color: isPast ? myColors.theme_turquoise : myColors.light_theme),
//         indicatorStyle: IndicatorStyle(
//           width: 40,
//           color: isPast ? myColors.theme_turquoise : myColors.light_theme,
//           iconStyle: IconStyle(
//             color: isPast ? myColors.whiteColor : myColors.light_theme,
//             iconData: Icons.check,
//           ),
//         ),
//         endChild: ProgressText(
//           isPast: isPast,
//           text: progressText,
//         ),
//       ),
//     );
//   }
// }

class ProgressText extends StatelessWidget {
  final bool isPast;
  final text;
  const ProgressText({super.key, required this.isPast, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Text(
        text,
        style: TextStyle(color: isPast ? myColors.HeadingColor : Colors.grey),
      ),
    );
  }
}

class FAQ_Card extends StatelessWidget {
  const FAQ_Card({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.grey,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: myColors.whiteColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              children: [
                Text("Why should I donate to earthquake relief efforts?",
                    style: TextStyle(
                      color: myColors.HeadingColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    )),
                SizedBox(height: 10.h),
                const Text(
                  "Donating to earthquake relief helps provide immediate assistance to those affected.",
                  maxLines: 3,
                ),
                const Spacer(),
                const Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                    ),
                    Text("36")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DonationDetailsBottomSheet extends StatelessWidget {
  final ClipBoardController myController = Get.put(ClipBoardController());
  DonationDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700.0.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(
            25.r,
          ),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(
                25.r,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Donor's Information",
                    style: MyTextStyles.HeadingStyle(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Currency",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      Image.asset(AppImages.ethIcon, width: 20.w),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "ETH",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: myColors.HeadingColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Amount",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "0.000012",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Donor",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "anonymous",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Date",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "2023-09-23 07:49:59",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Message",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    "-- --",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Transaction Hash",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40.h, // Set a fixed height
                        child: Obx(
                          () => Text(
                            myController.myText.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () => myController.copyToClipboard(),
                          child: const Icon(
                            Icons.copy,
                            color: myColors.theme_turquoise,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DonationDetailsBottomSheet2 extends StatelessWidget {
  final DataRowModel donationDetails;
  final ClipBoardController myController = Get.put(ClipBoardController());

  DonationDetailsBottomSheet2({super.key, required this.donationDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 720.0.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(
            25.r,
          ),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(
                25.r,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Donor's Information",
                    style: MyTextStyles.HeadingStyle(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Currency",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      Image.asset(AppImages.ethIcon, width: 20.w),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        donationDetails.Currency,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: myColors.HeadingColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Amount",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    donationDetails.Amount.toString(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Donor",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    donationDetails.DonorName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Date",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    donationDetails.Date,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Message",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    donationDetails.Message,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: myColors.HeadingColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Transaction Hash",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // height: 40.h, // Set a fixed height
                        child: Text(
                          donationDetails.transactionHash,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () => myController.copyToClipboard(),
                          child: const Icon(
                            Icons.copy,
                            color: myColors.theme_turquoise,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SliderController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final CarouselController carouselController = CarouselController();
}
