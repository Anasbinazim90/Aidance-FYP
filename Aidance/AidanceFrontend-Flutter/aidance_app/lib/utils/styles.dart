import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextStyles {
  static TextStyle HeadingStyle() {
    return TextStyle(
      fontFamily: 'Epilogue',
      fontSize: 21.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xff171A1F),
    );
  }

  static TextStyle SecondaryTextStyle() {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w300,
      color: const Color(0xff171A1F),
    );
  }

  static TextStyle BtnTextStyle(Color color) {
    return TextStyle(
      fontFamily: 'Metropolis',
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle Subtitle() {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w200,
      color: const Color(0xff171A1F),
    );
  }
}

class MyPaddingStyle {
  static EdgeInsets myPadding =
      EdgeInsets.symmetric(horizontal: 25.w, vertical: 50.h);
}
