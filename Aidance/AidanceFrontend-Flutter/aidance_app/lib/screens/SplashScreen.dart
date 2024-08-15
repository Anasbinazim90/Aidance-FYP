import 'dart:async';

import 'package:aidance_app/screens/onBoardingScreen/OnBoardingScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Get.off(() => LandingScreen());
    }); // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.theme_turquoise,
        body: Center(
          child: Text(
            'aidance.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60.sp,
              fontFamily: GoogleFonts.outfit().fontFamily,
            ),
          ),
        ).animate().shimmer(color: Colors.grey[600], duration: 1500.ms));
  }
}
