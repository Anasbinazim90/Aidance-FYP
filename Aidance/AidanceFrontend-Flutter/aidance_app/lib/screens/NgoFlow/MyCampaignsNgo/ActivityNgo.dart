// ignore_for_file: avoid_print

import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.whitebgcolor,
        body: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 10.h),
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(right: 7.w, left: 7.w),
              scrollDirection: Axis.vertical,
              itemCount: 2,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.h.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Text(
                        "Today, December 25 2023",
                        style: MyTextStyles.Subtitle()
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                    10.h.verticalSpace,
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10.h,
                      ),
                      height: 82.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: myColors.whitebgcolor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            spreadRadius: 0.1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          10.w.horizontalSpace,
                          CircleAvatar(
                            radius: 35.r,
                            backgroundImage: AssetImage(AppImages.activityImg),
                          ),
                          20.w.horizontalSpace,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              15.h.verticalSpace,
                              Row(
                                children: [
                                  Text(
                                    "chi huan has",
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            color: Colors.grey, fontSize: 11),
                                  ),
                                  Text(
                                    " donated",
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            color: myColors.theme_turquoise,
                                            fontSize: 11),
                                  ),
                                ],
                              ),
                              9.h.verticalSpace,
                              Row(
                                children: [
                                  Text(
                                    "\$25",
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            color: myColors.theme_turquoise,
                                            fontSize: 11),
                                  ),
                                  Text(
                                    " on",
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            color: Colors.grey, fontSize: 11),
                                  ),
                                  Text(
                                    " Help Victims of F..",
                                    style: MyTextStyles.HeadingStyle()
                                        .copyWith(fontSize: 11),
                                  ),
                                ],
                              )
                            ],
                          ),
                          0.04.sw.horizontalSpace,
                          Container(
                            height: 35.h,
                            width: 92.w,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: myColors.theme_turquoise),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.r)),
                            child: Center(
                              child: Text(
                                "Say Thanks",
                                style: MyTextStyles.SecondaryTextStyle()
                                    .copyWith(
                                        color: myColors.theme_turquoise,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
