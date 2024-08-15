import 'dart:ui';

import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            SizedBox(
                height: 300.h,
                child: GestureDetector(
                  onTap: () {
                    // Get.toNamed(AppRoutes.hotelDetail);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Container(
                      margin: EdgeInsets.only(
                          right: 10.w, bottom: 10.h, left: 16.w),
                      height: 250.h,
                      width: double.infinity,
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
                          Stack(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    topRight: Radius.circular(16.r),
                                  ),
                                  child: Image.asset(
                                    AppImages.sandstorm,
                                    fit: BoxFit.cover,
                                    height: 140.h,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 15,
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5.0,
                                      sigmaY: 5.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border:
                                              Border.all(color: Colors.white)),
                                      alignment: Alignment.center,
                                      width: 110.w,
                                      height: 30.h,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.clock,
                                              size: 15.h,
                                              color: myColors.whiteColor,
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              '12 Days left',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w200,
                                                color: myColors.whiteColor,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 15,
                                  right: 15,
                                  child: Icon(
                                    CupertinoIcons.heart_fill,
                                    color: myColors.whiteColor,
                                  ))
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 10.h,
                                  bottom: 10.h,
                                  right: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Syria SandStorm",
                                      style: TextStyle(
                                          fontFamily: 'Epilogue',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: myColors.HeadingColor)),

                                  SizedBox(
                                    height: 8.h,
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        "1,280",
                                        style: TextStyle(
                                          color: const Color(0xFF00BDD6),
                                          fontSize: 12.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "Donators",
                                        style: TextStyle(
                                          color: myColors.HeadingColor,
                                          fontSize: 12.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10.h,
                                  ),

                                  /// Progress Bar and Percentage

                                  const Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: 0.7,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  myColors.theme_turquoise),
                                          backgroundColor: myColors.light_theme,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
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
                                      Spacer(),
                                      Container(
                                        width: 50.w,
                                        height: 30.h,
                                        padding: const EdgeInsets.only(
                                            top: 4,
                                            left: 8,
                                            right: 9,
                                            bottom: 4),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: myColors.light_theme,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
