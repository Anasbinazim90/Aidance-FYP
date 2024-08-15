// ignore_for_file: avoid_print

import 'dart:io';

import 'package:aidance_app/Components/dropdown.dart';
import 'package:aidance_app/Components/mainbutton.dart';
import 'package:aidance_app/Components/textfield.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EditCompaignScreen extends StatefulWidget {
  List<PlatformFile> ImagesList;
  String title;
  String donation;
  String msg;
  String Recipient;
  String Story;
  var date;
  EditCompaignScreen({
    super.key,
    required this.ImagesList,
    required this.title,
    required this.msg,
    required this.Story,
    required this.Recipient,
    required this.donation,
    required this.date,
  });

  @override
  State<EditCompaignScreen> createState() => _EditCompaignScreenState();
}

class _EditCompaignScreenState extends State<EditCompaignScreen> {
  late TextEditingController titleController;
  late TextEditingController totalDonationController;
  late TextEditingController expirationDateController;
  late TextEditingController fundUsageController;
  late TextEditingController recipientNameController;
  late TextEditingController storyController;
  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    totalDonationController = TextEditingController(text: widget.donation);
    expirationDateController = TextEditingController(text: widget.date);
    fundUsageController = TextEditingController(text: widget.msg);
    recipientNameController = TextEditingController(text: widget.Recipient);
    storyController = TextEditingController(text: widget.Story);
    super.initState();
  }

  // List<File> imageList = [];

  bool activeCheck = false;

  // List<PlatformFile>? selectedFileList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.whitebgcolor,
      appBar: AppBar(
        backgroundColor: myColors.whitebgcolor,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: myColors.theme_turquoise,
          ),
        ),
        title: Text(
          "Create Compaign",
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
          // padding: EdgeInsets.only(top: 32.h),
          height: Get.height,
          width: Get.width,
          // margin: EdgeInsets.only(top: 0.03.sh),
          decoration: const BoxDecoration(
            color: myColors.whitebgcolor,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.076.sw,
                vertical: 0.040.sh,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          height: 200.h,
                          width: 380.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                  File(widget.ImagesList[1].path.toString() ??
                                      ""),
                                ),
                                fit: BoxFit.cover),
                          ),
                        )),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.ImagesList.length,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // childAspectRatio: 1,
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.w,
                        // mainAxisSpacing: 5.h,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          // height: 0.058.sh,
                          width: 83.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                  File(
                                      widget.ImagesList[index].path.toString()),
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.black.withOpacity(0.2),
                          ),
                        );
                      },
                    ),
                    16.h.verticalSpace,
                    Text("Fundraising Details",
                        style: MyTextStyles.HeadingStyle()),
                    16.h.verticalSpace,
                    Text("Title",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        colors: titleController,
                        widthh: double.infinity,
                        isPassword: false,
                        hint: "Title",
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Category",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                        decoration: const BoxDecoration(),
                        child: const DropdownWidget(
                            hint: "Obidience, Protection",
                            items: [
                              "Obidience, Protection 1",
                              "Obidience, Protection 2",
                              "Obidience, Protection 3",
                            ])),
                    16.h.verticalSpace,
                    Text("Total Dination Required",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        controller: totalDonationController,
                        widthh: double.infinity,
                        isPassword: false,
                        hint: '12,000 \$',
                        suffixIcon: SvgPicture.asset(
                          AppImages.dollarIcon,
                          fit: BoxFit.scaleDown,
                          height: 40.h,
                          width: 40.w,
                        ),
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Donation Expiration Date",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        controller: expirationDateController,
                        widthh: double.infinity,
                        isPassword: false,
                        hint: 'Select Date',
                        suffixIcon: SvgPicture.asset(
                          AppImages.mycalenderIcon,
                          fit: BoxFit.scaleDown,
                          height: 40.h,
                          width: 40.w,
                        ),
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Fund Usage Plan",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    4.h.verticalSpace,
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        controller: fundUsageController,
                        widthh: double.infinity,
                        isPassword: false,
                        maxlines: 5,
                        hint: "your message ",
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Donation Recipient Details",
                        style: MyTextStyles.HeadingStyle()),
                    16.h.verticalSpace,
                    Text("Name of Recipient (People/Organization)",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        controller: recipientNameController,
                        widthh: double.infinity,
                        isPassword: false,
                        hint: "ex : Children of Palestine",
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Donation Proposal Documents",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        widthh: double.infinity,
                        isPassword: false,
                        hint: 'Select Documents',
                        suffixIcon: SvgPicture.asset(
                          AppImages.cloudIcon,
                          fit: BoxFit.scaleDown,
                          height: 40.h,
                          width: 40.w,
                        ),
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Upload Additional Documents (if any)",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        widthh: double.infinity,
                        isPassword: false,
                        hint: 'Select Document',
                        suffixIcon: SvgPicture.asset(
                          AppImages.cloudIcon,
                          fit: BoxFit.scaleDown,
                          height: 40.h,
                          width: 40.w,
                        ),
                      ),
                    ),
                    16.h.verticalSpace,
                    Text("Story",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    4.h.verticalSpace,
                    Container(
                      decoration: const BoxDecoration(),
                      child: CustomTextField(
                        controller: storyController,
                        widthh: double.infinity,
                        isPassword: false,
                        maxlines: 5,
                        hint: "Story about the recipients",
                      ),
                    ),
                    16.h.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              activeCheck = !activeCheck;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 18.h,
                                width: 18.h,
                                // padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1.w,
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.r)),
                                ),
                                child: activeCheck
                                    ? Icon(
                                        Icons.check,
                                        size: 15.r,
                                        color: myColors.theme_turquoise,
                                      )
                                    : const SizedBox(),
                              ),
                              20.w.horizontalSpace,
                              Text("I agree to the Terms of Services & Privacy",
                                  style: MyTextStyles.SecondaryTextStyle()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          )),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            bottom: 0.010.sh, top: 0.010.sh, right: 0.030.sw, left: 0.030.sw),
        child: MainButton(
          title: "Update & Submit",
          ontap: () {},
        ),
      ),
    );
  }
}
