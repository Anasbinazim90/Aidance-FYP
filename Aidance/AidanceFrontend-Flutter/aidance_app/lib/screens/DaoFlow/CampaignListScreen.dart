import 'dart:developer';

import 'package:aidance_app/components/ActiveNgoCard.dart';
import 'package:aidance_app/components/PendingNgoCard.dart';
import 'package:aidance_app/helper/helper_methods.dart';
import 'package:aidance_app/screens/DaoFlow/CampaignVotingScreen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CampaignListScreen extends StatelessWidget {
  CampaignListScreen({
    super.key,
  });

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(),
          backgroundColor: myColors.whiteColor,
          title: Text(
            'Proposals',
            style: MyTextStyles.HeadingStyle()
                .copyWith(color: Palette.theme_turquoise),
          ),
          centerTitle: true,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            indicatorColor: myColors.theme_turquoise,
            labelColor: myColors.theme_turquoise,
            tabs: [
              Tab(child: Text('Active')),
              Tab(child: Text('Pending')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Active NGO Tab
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('campaigns')
                  .where('status', isEqualTo: 'active')
                  .orderBy('tokenId', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SpinKitWaveSpinner(
                    waveColor: myColors.theme_turquoise,
                    trackColor: myColors.theme_turquoise.withOpacity(0.5),
                    color: myColors.theme_turquoise,
                  ));
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(child: Text('Error fetching data'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No Active Proposals',
                      style: MyTextStyles.HeadingStyle(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];

                    double totalDonationsRequired =
                        double.parse(data['total_donation_required']);
                    double totalDonationsReceived =
                        double.parse(data['total_donations_received']);

                    // Calculate the progress value
                    double progressValue =
                        totalDonationsReceived / totalDonationsRequired;
                    // Calculate the percentage
                    int percentage = (progressValue * 100).toInt();
                    return ActiveNgoCard(
                      progressvalue: progressValue,
                      donation: data['total_donation_required'],
                      title: data['title'],
                      expirationdate:
                          convertDateString(data['donation_expiration_date']),
                      recipient: data['name_of_recipient'],
                      image: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: data['cover_photo'][0],
                        placeholder: (context, url) =>
                            Container(width: 100.w, color: Colors.grey)
                                .animate(onPlay: (c) => c.repeat)
                                .shimmer(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      onTap: () {
                        Get.to(
                            transition: Transition.rightToLeft,
                            () => CampaignVotingScreen(
                                  proposal: data,
                                ));
                      },
                    );
                  },
                );
              },
            ),
            // Pending NGO Tab
            StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('campaigns')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SpinKitWaveSpinner(
                    waveColor: myColors.theme_turquoise,
                    trackColor: myColors.theme_turquoise.withOpacity(0.5),
                    color: myColors.theme_turquoise,
                  ));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No Pending Proposals',
                      style: MyTextStyles.HeadingStyle(),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return PendingNgoCard(
                      status: data['status'],
                      donation: data['total_donation_required'],
                      title: data['title'],
                      expirationdate:
                          convertDateString(data['donation_expiration_date']),
                      recipient: data['name_of_recipient'],
                      image: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: data['cover_photo'][0],
                        placeholder: (context, url) =>
                            Container(width: 100.w, color: Colors.grey)
                                .animate(onPlay: (c) => c.repeat)
                                .shimmer(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      onTap: () {
                        Get.to(
                            transition: Transition.rightToLeft,
                            () => CampaignVotingScreen(
                                  proposal: data,
                                ));
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
