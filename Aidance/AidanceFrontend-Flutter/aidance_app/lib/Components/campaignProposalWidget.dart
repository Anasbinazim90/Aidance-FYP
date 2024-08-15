import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CampaignProposalWidget extends StatelessWidget {
  const CampaignProposalWidget(
      {super.key,
      required this.title,
      required this.subtitile,
      required this.heading});

  final String title;
  final String heading;
  final String subtitile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: myColors.themeGreyColor, width: 0.2),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.shade300,
          //   blurRadius: 2.0,
          //   spreadRadius: 2.0,
          //   offset: Offset(1, 2), // shadow direction: bottom right
          // ),
          BoxShadow(
            color: Palette.theme_turquoise.shade200,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: MyTextStyles.SecondaryTextStyle().copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: myColors.themeGreyColor),
          ),
          19.verticalSpace,
          Text(
            heading,
            style: MyTextStyles.HeadingStyle(),
          ),
          16.verticalSpace,
          Text(
            subtitile,
            style: MyTextStyles.SecondaryTextStyle().copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: myColors.themeGreyColor),
          ),
        ],
      ),
    );
  }
}
