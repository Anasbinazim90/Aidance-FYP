import 'package:aidance_app/helper/helper_methods.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/screens/NgoFlow/InsightsScreenNgo/InsightScreenNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CompaignCard extends StatelessWidget {
  const CompaignCard({
    super.key,
    required this.campaign,
    this.donationsLength,
  });

  final NGOCampaignModel campaign;
  final donationsLength;

  @override
  Widget build(BuildContext context) {
    double totalDonationsRequired =
        double.parse(campaign.total_donation_required);
    double totalDonationsReceived =
        double.parse(campaign.total_donations_received);

    int timeLeftDonations = (DateTime.parse(campaign.donation_expiration_date)
        .difference(DateTime.now())
        .inDays
        .abs());

    // Calculate the progress value
    double progressValue = totalDonationsReceived / totalDonationsRequired;
    // Calculate the percentage
    int percentage = (progressValue * 100).toInt();
    return Container(
        margin: EdgeInsets.only(right: 10.w, bottom: 20.h, left: 16.w),
        height: 190.h,
        decoration: BoxDecoration(
          color: myColors.whitebgcolor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 0.1,
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  right: 10.w, bottom: 20.h, left: 10.w, top: 10.h),
              height: 125.h,
              width: 332.w,
              decoration: BoxDecoration(
                color: myColors.whitebgcolor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2,
                    spreadRadius: 0.1,
                  )
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    ),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: 113.w,
                      height: 125.h,
                      imageUrl: campaign.cover_photo[0],
                      placeholder: (context, url) =>
                          Container(width: 100.w, color: Colors.grey)
                              .animate(onPlay: (c) => c.repeat)
                              .shimmer(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // child: Image.network(
                    //   campaign.cover_photo[0],
                    //   width: 113.w,
                    //   height: 125.h,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  15.w.horizontalSpace,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.h.verticalSpace,
                      Text(
                        campaign.title,
                        overflow: TextOverflow.ellipsis,
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.sp),
                      ),
                      10.h.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaign.total_donations_received,
                            style: MyTextStyles.SecondaryTextStyle().copyWith(
                                color: myColors.theme_turquoise,
                                fontSize: 12.sp),
                          ),
                          3.w.horizontalSpace,
                          Text("of",
                              style: MyTextStyles.SecondaryTextStyle()
                                  .copyWith(fontSize: 12.sp)),
                          3.w.horizontalSpace,
                          Text(
                            "${campaign.total_donation_required} tokens",
                            style: MyTextStyles.SecondaryTextStyle().copyWith(
                                color: myColors.theme_turquoise,
                                fontSize: 12.sp),
                          ),
                          2.w.horizontalSpace,
                          Text("funded",
                              style: MyTextStyles.SecondaryTextStyle()
                                  .copyWith(fontSize: 12.sp)),
                        ],
                      ),
                      15.h.verticalSpace,
                      Row(
                        children: [
                          SizedBox(
                            width: 170.w,
                            child: LinearProgressIndicator(
                              value: progressValue,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  myColors.theme_turquoise),
                              backgroundColor: myColors.light_theme,
                            ),
                          ),
                        ],
                      ),
                      10.h.verticalSpace,
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${donationsLength} donators',
                            style: MyTextStyles.Subtitle().copyWith(
                                color: myColors.theme_turquoise,
                                fontWeight: FontWeight.w400),
                          ),
                          40.w.horizontalSpace,
                          Text(
                            timeLeftDonations == 0
                                ? 'Completed'
                                : '${timeLeftDonations} days left',
                            style: MyTextStyles.Subtitle().copyWith(
                                color: myColors.theme_turquoise,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppImages.editIcon,
                    width: 18.w,
                    color: myColors.theme_turquoise,
                    fit: BoxFit.scaleDown,
                  ),
                  8.w.horizontalSpace,
                  Text(
                    "Edit",
                    style: MyTextStyles.SecondaryTextStyle(),
                  ),
                  0.48.sw.horizontalSpace,
                  GestureDetector(
                    onTap: () => Get.to(
                        transition: Transition.rightToLeftWithFade,
                        () => InsightScreen(
                              campaign: campaign,
                              donationsLength: donationsLength,
                            )),
                    child: Container(
                      height: 28.h,
                      width: 92.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: myColors.theme_turquoise),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.r)),
                      child: Center(
                        child: Text(
                          "See insights",
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              color: myColors.theme_turquoise, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
