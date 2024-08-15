import 'package:aidance_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FixedUsdContainer extends StatelessWidget {
  const FixedUsdContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      alignment: Alignment.center,
      width: 90.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.Img_dollar,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              'USD',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter'),
            )
          ]),
    );
  }
}
