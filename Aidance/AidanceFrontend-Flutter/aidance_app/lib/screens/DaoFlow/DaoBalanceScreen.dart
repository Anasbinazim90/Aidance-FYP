import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/AuthControllerDao.dart';
import 'package:aidance_app/controllers/get_balance_controller.dart';
import 'package:aidance_app/response/status.dart';
import 'package:aidance_app/screens/DaoFlow/DaoHomeScreen.dart';
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

class DaoBalanceScreen extends StatefulWidget {
  const DaoBalanceScreen({super.key});

  @override
  State<DaoBalanceScreen> createState() => _DaoBalanceScreenState();
}

class _DaoBalanceScreenState extends State<DaoBalanceScreen> {
  final _controller = Get.put(GetBalanceController());
  final auth_controller_dao = Get.put(DaoAuthController());

  // String? userAddress;
  // Future<void> _fetchUserData() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();
  //     setState(() {
  //       userAddress = userDoc['address'];
  //     });
  //   }
  // }
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? DaouserData;

  Future<void> fetchCurrentUserData() async {
    if (user != null) {
      DocumentSnapshot DaoDoc = await FirebaseFirestore.instance
          .collection('daoUsers')
          .doc(user!.uid)
          .get();

      setState(() {
        DaouserData = DaoDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  void copyToClipboard(context) {
    FlutterClipboard.copy(DaouserData!['address'] ?? '').then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  @override
  initState() {
    // _fetchUserData();
    Future.delayed(Duration.zero, () {
      _controller.getBalanceApi(userAddress.toString());
    });
    fetchCurrentUserData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Obx(() {
      switch (_controller.RxRequestStatus.value) {
        case Status.LOADING:
          return Center(
            child: SpinKitWaveSpinner(
              waveColor: myColors.theme_turquoise,
              trackColor: myColors.theme_turquoise.withOpacity(0.5),
              color: myColors.theme_turquoise,
            ),
          );
        case Status.ERROR:
          return Text("Error");
        case Status.COMPLETED:
          // return Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Text("Address : ${userAddress.toString()}"),
          //     Text(
          //         "Balance : ${_controller.balanceList.value.balance.toString()}"),
          //   ],
          // );

          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                scrolledUnderElevation: 0,
                backgroundColor: myColors.theme_turquoise,
                foregroundColor: Colors.white,
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              backgroundColor: Colors.white,
              body: DaouserData == null

                  ? Center(
                      child: SpinKitWaveSpinner(
                        waveColor: myColors.theme_turquoise,
                        trackColor: myColors.theme_turquoise.withOpacity(0.5),
                        color: myColors.theme_turquoise,
                      ),
                    )

                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.h, vertical: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${DaouserData!['username']}",
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
                            "${DaouserData!['email']}",
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
                                    '${Utils().shortenAddress(DaouserData!['address'])}',
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            fontSize: 16.sp,
                                            color: myColors.theme_turquoise,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          20.h.verticalSpace,
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Reg. Number',
                          //       style: TextStyle(
                          //         fontSize: 16.sp,
                          //         color: myColors.themeGreyColor,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     Text(
                          //       '${DaouserData!['ngono']}',
                          //       style: MyTextStyles.SecondaryTextStyle()
                          //           .copyWith(
                          //               fontSize: 16.sp,
                          //               color: myColors.theme_turquoise,
                          //               fontWeight: FontWeight.bold),
                          //     ),
                          //   ],
                          // ),
                          50.h.verticalSpace,
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'DAO Token Balance',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${_controller.balanceList.value.balance.toString()}",
                                  style: TextStyle(
                                    fontSize: 100.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Adn",
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    color: myColors.theme_turquoise,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          100.h.verticalSpace,
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
                                        title: Text(
                                            'Are you sure you want to log out?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: myColors
                                                        .theme_turquoise,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                auth_controller_dao.signout();
                                                Get.to(RolesScreen());
                                              },
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: myColors
                                                        .theme_turquoise,
                                                    fontWeight:
                                                        FontWeight.bold),
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
    });
  }
}
