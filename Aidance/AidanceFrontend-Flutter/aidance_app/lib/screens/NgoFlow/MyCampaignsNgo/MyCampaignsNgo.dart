// ignore_for_file: avoid_print

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/ApiController/register_ngo_controller.dart';
import 'package:aidance_app/controllers/AuthControllerNgo.dart';
import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/ActivityNgo.dart';
import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/CampaignsNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyCompaignScreen extends StatelessWidget {
  MyCompaignScreen({super.key});

  final auth_controller_ngo = Get.put(AuthControllerNgo());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: myColors.whitebgcolor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: myColors.theme_turquoise,
                  indicatorColor: myColors.theme_turquoise,
                  unselectedLabelColor: Colors.grey.shade500,
                  // labelStyle: TextStyle(
                  //   fontFamily: 'Epilogue',
                  //   fontSize: 16.sp,
                  //   fontWeight: FontWeight.w600,
                  // ),
                  // unselectedLabelStyle: MyTextStyles.SecondaryTextStyle()
                  //     .copyWith(fontSize: 21.h),
                  tabs: [
                    Tab(
                      text: "My Campaigns",
                      // child: Text(
                      //   "My Compaigns",
                      //   // style: TextStyle(
                      //   //   fontFamily: 'Epilogue',
                      //   //   fontSize: 16.sp,
                      //   // ),
                      // ),
                    ),
                    Tab(
                      text: "Activity",
                      // child: Text(
                      //   "Activity",
                      //   // style: TextStyle(
                      //   //   fontFamily: 'Epilogue',
                      //   //   fontSize: 16.sp,
                      //   // ),
                      // ),
                    ),
                  ]),
            ),
            body: const TabBarView(children: [
              CompaignView(),
              ActivityView(),
            ])));
  }
}
