import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainCampaignCard extends StatelessWidget {
  const MainCampaignCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.campaignDetailScreen);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          margin: EdgeInsets.only(right: 10.w, bottom: 10.h, left: 16.w),
          height: 310.h,
          width: 300.w,
          decoration: BoxDecoration(
            color: myColors.whitebgcolor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Image.asset(AppImages.campaign,
                      width: 300.w, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.w, top: 10.h, bottom: 10.h, right: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text("Turkey Earthquake Emergency",
                                style: TextStyle(
                                    fontFamily: 'Epilogue',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: myColors.HeadingColor)),
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'In Progress',
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
                        "Providing urgent relief to the people of Turkey, affected by the earthquake.",
                        style: MyTextStyles.Subtitle(),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),

                      /// Progress Bar and Percentage

                      Row(
                        children: [
                          const Expanded(
                            child: LinearProgressIndicator(
                              value: 0.7,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  myColors.theme_turquoise),
                              backgroundColor: myColors.light_theme,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Container(
                            width: 50.w,
                            height: 30.h,
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
                                  '70%',
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
                            "12,000\$",
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
                            "24,000\$",
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
