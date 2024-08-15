import 'dart:math';
import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/AuthControllerNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NgoProfileScreen extends StatefulWidget {
  NgoProfileScreen({super.key});

  @override
  State<NgoProfileScreen> createState() => _NgoProfileScreenState();
}

class _NgoProfileScreenState extends State<NgoProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? ngoData;
  String? generatedCode; // Variable to store the generated code

  final auth_controller_ngo = Get.put(AuthControllerNgo());
  final box = GetStorage();
  Future<void> fetchCurrentNgoData() async {
    if (user != null) {
      DocumentSnapshot ngoDoc = await FirebaseFirestore.instance
          .collection('Ngousers')
          .doc(user!.uid)
          .get();

      setState(() {
        ngoData = ngoDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  void copyToClipboard(context) {
    FlutterClipboard.copy(ngoData!['address'] ?? '').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  void generateCode() {
    final random = Random();
    final newCode = (random.nextInt(9000) + 1000)
        .toString(); // Generate a unique 4-digit code
    setState(() {
      generatedCode = newCode;
    });
    box.write(
        'generatedCode', newCode); // Store the generated code in GetStorage
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentNgoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          backgroundColor: myColors.whitebgcolor,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ngoData == null
            ? Center(
                child: SpinKitWaveSpinner(
                waveColor: myColors.theme_turquoise,
                trackColor: myColors.theme_turquoise.withOpacity(0.5),
                color: myColors.theme_turquoise,
              ))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${ngoData!['username']}",
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${ngoData!['email']}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: myColors.themeGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    50.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: myColors.themeGreyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(left: 14.w),
                              iconSize: 18.sp,
                              icon: Icon(Icons.copy),
                              onPressed: () => copyToClipboard(context),
                            ),
                            Text(
                              '${Utils().shortenAddress(ngoData!['address'])}',
                              style: MyTextStyles.SecondaryTextStyle().copyWith(
                                  fontSize: 16.sp,
                                  color: myColors.theme_turquoise,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reg. Number',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: myColors.themeGreyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${ngoData!['ngono']}',
                          style: MyTextStyles.SecondaryTextStyle().copyWith(
                              fontSize: 16.sp,
                              color: myColors.theme_turquoise,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    50.h.verticalSpace,
                    Center(
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        child: Padding(
                          padding: EdgeInsets.all(40.h),
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: myColors.theme_turquoise,
                                    overlayColor:
                                        Colors.white.withOpacity(0.2)),
                                onPressed: generateCode,
                                child: Text(
                                  'Generate Code',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              if (generatedCode != null)
                                Text(
                                  'Generated Code: $generatedCode',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    50.h.verticalSpace,
                    Center(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: myColors.theme_turquoise,
                          overlayColor: Colors.white.withOpacity(0.2)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title:
                                      Text('Are you sure you want to log out?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              color: myColors.theme_turquoise,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          auth_controller_ngo.signout();
                                          Get.to(RolesScreen());
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: myColors.theme_turquoise,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ));
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                  ],
                ),
              ));
  }
}
