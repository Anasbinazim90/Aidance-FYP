import 'dart:developer';

import 'package:aidance_app/controllers/NgoModelController.dart';
import 'package:aidance_app/helper/helper_methods.dart';
import 'package:aidance_app/models/NgoModel/NgoModel.dart';
import 'package:aidance_app/screens/DaoFlow/NgoVotingScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class NgoApprovalScreen extends StatefulWidget {
  NgoApprovalScreen({super.key});

  @override
  State<NgoApprovalScreen> createState() => _NgoApprovalScreenState();
}

class _NgoApprovalScreenState extends State<NgoApprovalScreen> {
  final NgoModelController ngoModelController = Get.put(NgoModelController());
  List<DocumentSnapshot> ngos = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchNgos();
    super.initState();
  }

  // Fetch NGOs from Firestore
  void fetchNgos() async {
    try {
      // show pending ngos only
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Ngousers')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        ngos = querySnapshot.docs;
        log(ngos.length.toString());
      });
    } catch (e) {
      print('Error fetching NGOs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(),
          backgroundColor: myColors.theme_turquoise,
          title: Text(
            'NGO Approval',
            style: MyTextStyles.HeadingStyle().copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Ngousers')
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitWaveSpinner(
                    waveColor: myColors.theme_turquoise,
                    trackColor: myColors.theme_turquoise.withOpacity(0.5),
                    color: myColors.theme_turquoise,
                  ),
                );
              }

              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Center(child: Text('Error fetching NGO\'s'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No pending NGO available'));
              }

              // var pendingNgos = snapshot.data!.docs;

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 20.h),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];

                  return NgoApprovalCard(
                    ngoName: data['username'],
                    ngoDescription: data['ngono'],
                    email: data['email'],
                    createdAt: data['createdAt'],
                    onTap: () {
                      Get.to(
                          transition: Transition.rightToLeft,
                          () => NgoVotingscreen(
                                ngoData: data,
                              ));
                    },
                  );
                },
              );
            }));
  }
}

class NgoApprovalCard extends StatelessWidget {
  final String? ngoName;
  final String? ngoDescription;
  final String? email;
  final dynamic createdAt;
  final void Function()? onTap;
  const NgoApprovalCard({
    super.key,
    required this.ngoName,
    required this.ngoDescription,
    required this.email,
    this.onTap,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0, 4))
            ],
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(15.r),
            color: myColors.whiteColor,
          ),
          height: 120.h,
          width: double.infinity,
          child: Card(
            color: myColors.whiteColor,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                      maxRadius: 35.r,
                      backgroundColor: myColors.light_theme,
                      backgroundImage: AppImages.help),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ngoName!,
                      style: TextStyle(
                        color: myColors.HeadingColor,
                        fontSize: 20.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          email!,
                          style: TextStyle(
                            color: myColors.HeadingColor,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        )
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 250.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ngoDescription!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: true,
                            style: TextStyle(
                              color: myColors.themeGreyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            FormatedDate(createdAt!),
                            style: TextStyle(
                                color: myColors.HeadingColor, fontSize: 12.sp),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
