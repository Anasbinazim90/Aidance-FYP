import 'package:aidance_app/controllers/DonorViewController/HomeControllerDonor/HomeControllerDonor.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [Center(child: Text('Search'))],
      ),
    ));
  }
}
