import 'package:aidance_app/Components/mainbutton.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen(
      {super.key, required this.campaign, this.donationsLength});

  final NGOCampaignModel campaign;
  final donationsLength;

  @override
  Widget build(BuildContext context) {
    String expirationDateString = campaign.donation_expiration_date;
    DateTime expirationDate =
        DateFormat('yyyy-MM-dd').parse(expirationDateString);
    DateTime currentDate = DateTime.now();
    int daysLeft = expirationDate.difference(currentDate).inDays;

    double progressValue = (double.parse(campaign.total_donations_received) /
            double.parse(campaign.total_donation_required)) *
        100;

    // Calculate the percentage
    int percentage = (progressValue * 100).toInt();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: myColors.whitebgcolor,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            "See Insights",
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              children: [
            30.h.verticalSpace,
            Container(
              margin: EdgeInsets.only(
                  right: 16.w, bottom: 20.h, left: 16.w, top: 10.h),
              height: 360.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: myColors.whitebgcolor,
                borderRadius: BorderRadius.circular(8.r),
                // borderRadius: BorderRadius.only(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2,
                    spreadRadius: 0.1,
                  )
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Total Funds Insights",
                        style:
                            MyTextStyles.HeadingStyle().copyWith(fontSize: 16),
                      ),
                    ),
                    110.h.verticalSpace,
                    Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 90.h,
                            width: 190.w,
                            child: SfRadialGauge(axes: <RadialAxis>[
                              RadialAxis(
                                showLabels: false,
                                showTicks: false,
                                startAngle: 180,
                                endAngle: 0,
                                radiusFactor: 3.r,
                                // radiusFactor: 0.2,
                                canScaleToFit: true,
                                axisLineStyle: const AxisLineStyle(
                                  thickness: 0.3,
                                  color: myColors.light_theme,
                                  thicknessUnit: GaugeSizeUnit.factor,
                                  cornerStyle: CornerStyle.bothFlat,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                      value: progressValue,
                                      width: 0.3,
                                      color: myColors.theme_turquoise,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      cornerStyle: CornerStyle.bothFlat)
                                ],
                              )
                            ]),
                          ),
                          Positioned.fill(
                            child: Center(
                                child: Column(
                              children: [
                                20.h.verticalSpace,
                                Text('Completed',
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(color: Colors.grey)),
                                8.h.verticalSpace,
                                Text('${progressValue.toStringAsFixed(2)}%',
                                    style: MyTextStyles.HeadingStyle()
                                        .copyWith(fontWeight: FontWeight.w400)),
                              ],
                            )),
                          )
                        ],
                      ),
                    ),
                    30.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${campaign.total_donations_received}",
                            style: MyTextStyles.HeadingStyle().copyWith(
                                fontSize: 40.h, fontWeight: FontWeight.w700)),
                        Text(" / ${campaign.total_donations_received}",
                            style: MyTextStyles.HeadingStyle().copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 40.h,
                            ))
                      ],
                    ),
                    10.h.verticalSpace,
                  ]),
            ),
            38.h.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${campaign.total_donations_received}",
                          style: MyTextStyles.HeadingStyle().copyWith(
                              fontSize: 48.h,
                              fontWeight: FontWeight.w700,
                              color: myColors.theme_turquoise),
                        ),
                        Text(
                          "Funded",
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 20.h, fontWeight: FontWeight.w400),
                        ),
                        20.h.verticalSpace,
                        Text(
                          "${(double.parse(campaign.total_donations_received) - double.parse(campaign.total_donation_required))}",
                          style: MyTextStyles.HeadingStyle().copyWith(
                              fontSize: 48.h,
                              fontWeight: FontWeight.w700,
                              color: myColors.theme_turquoise),
                        ),
                        Text(
                          "Funds left",
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 20.h, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${daysLeft}",
                          style: MyTextStyles.HeadingStyle().copyWith(
                              fontSize: 48.h,
                              fontWeight: FontWeight.w700,
                              color: myColors.theme_turquoise),
                        ),
                        Text(
                          "Days left",
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 20.h, fontWeight: FontWeight.w400),
                        ),
                        20.h.verticalSpace,
                        Text(
                          '${donationsLength}',
                          style: MyTextStyles.HeadingStyle().copyWith(
                              fontSize: 48.h,
                              fontWeight: FontWeight.w700,
                              color: myColors.theme_turquoise),
                        ),
                        Text(
                          "Donors",
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 20.h, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            30.h.verticalSpace,
          ]
                  .animate(interval: 200.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0)),
        ));
  }
}
