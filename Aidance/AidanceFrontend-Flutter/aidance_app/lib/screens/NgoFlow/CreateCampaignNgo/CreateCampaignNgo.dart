// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:developer';

import 'package:aidance_app/Components/alertDialogues.dart';
import 'package:aidance_app/Components/dropdown.dart';
import 'package:aidance_app/Components/mainbutton.dart';
import 'package:aidance_app/Components/textfield.dart';
import 'package:aidance_app/components/MyTextformfield.dart';
import 'package:aidance_app/controllers/ApiController/create_campaign_controller.dart';
import 'package:aidance_app/controllers/DaoControllers/ProposalDetailController.dart';
import 'package:aidance_app/controllers/NgoCampaignModelController.dart';
import 'package:aidance_app/models/NgoModel/NgoCampaignModel.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DaoFlow/CampaignListScreen.dart';
import 'package:aidance_app/screens/DaoFlow/DaoBottomBar.dart';
import 'package:aidance_app/screens/DonorView/HomeScreenDonor/HomeScreenDonor.dart';
import 'package:aidance_app/screens/NgoFlow/BottomNavScreenNgo/BottomNavScreenNgo.dart';
import 'package:aidance_app/screens/NgoFlow/EditCompaignNgo/EditCompaignNgo.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateCompaignScreen extends StatefulWidget {
  CreateCompaignScreen({super.key});

  @override
  State<CreateCompaignScreen> createState() => _CreateCompaignScreenState();
}

class _CreateCompaignScreenState extends State<CreateCompaignScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController totalDonationController = TextEditingController();
  TextEditingController expirationDateController = TextEditingController();
  TextEditingController fundUsageController = TextEditingController();
  TextEditingController recipientNameController = TextEditingController();
  TextEditingController storyController = TextEditingController();
  TextEditingController totalBeneficairiesController = TextEditingController();
  final _timerController = Get.put(TimerController());
  final createCampaignController = Get.put(CreateCampaignController());

  bool activeCheck = false;
  List<String> selectedFiles1 = [];
  List<String> selectedFiles2 = [];
  RxBool filesUploaded1 = false.obs;
  RxBool filesUploaded2 = false.obs;

  List<PlatformFile> selectedFileList = [];

  Future<void> _pickFiles(
      List<String> selectedFiles, RxBool filesUploaded) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.paths.map((path) => path!));
        filesUploaded.value = true;
        // controller.text = 'Files Uploaded';
      });
    }
  }

  // Date and time selection
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expirationDateController.text =
            selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result;

      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
          allowCompression: true,
          type: FileType.custom,
          allowedExtensions: ['mp4', 'mov', 'png', 'jpeg', 'jpg'],
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          allowCompression: true,
          type: FileType.custom,
          allowedExtensions: ['mp4', 'png', 'jpeg', 'jpg'],
        );
      }
      if (result != null) {
        for (var element in result.files) {
          int sizeInBytes = element.size;
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb < 100) {
            if (element.name.contains('.mp4') ||
                element.name.contains('.png') ||
                element.name.contains('.jpeg') ||
                element.name.contains('.jpg')) {
              selectedFileList.add(element);

              setState(() {});
            } else {
              Get.snackbar(
                "Error",
                'Only Audio or Video file can be selected.',
              );
            }
          } else {
            print(sizeInMb);
            Get.snackbar(
              "Error",
              'Selected file is too large',
            );
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // Ngo campaign Proposals List
  // List<NGOCampaignModel> NGOProposals = [];
  final ngoProposalController = Get.put(NGOProposalController());
  //ngo data
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? ngoData;

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

  Future<void> saveCampaignToFirestore(NGOCampaignModel campaign) async {
    try {
      // showDialog(
      //     context: context,
      //     builder: (context) => const Center(
      //           child: CircularProgressIndicator(
      //             color: myColors.theme_turquoise,
      //           ),
      //         ));

      // Upload cover photos and get their download URLs
      List<String> coverPhotoURLs =
          await uploadFiles(user!.uid, selectedFileList, "cover_photos");

      // Upload additional documents and get their download URLs and names
      List<Map<String, String>> additionalDocs = await uploadFilesWithNames(
          user!.uid,
          selectedFiles1.map((path) {
            final file = File(path);
            return PlatformFile(
                name: file.uri.pathSegments.last,
                path: path,
                size: file.lengthSync());
          }).toList(),
          "additional_docs");

      // Add the URLs and names to the campaign model
      campaign.cover_photo = coverPhotoURLs;
      campaign.additional_docs = additionalDocs;

      // Save the campaign to Firestore
      await FirebaseFirestore.instance
          .collection('campaigns')
          .add(campaign.toJson());

      // Get.back();
      print("Campaign Added");
    } catch (e) {
      // Get.back();
      log(e.toString());
    }
  }

  Future<List<Map<String, String>>> uploadFilesWithNames(
      String uid, List<PlatformFile> files, String folderName) async {
    List<Map<String, String>> downloadURLs = [];

    for (PlatformFile file in files) {
      File fileToUpload = File(file.path!);
      String fileName = file.name;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('$uid/campaigns/$folderName/$timestamp-$fileName')
            .putFile(fileToUpload);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        downloadURLs.add({'url': downloadURL, 'name': fileName});
      } catch (e) {
        print('Error uploading file: $fileName, $e');
      }
    }
    return downloadURLs;
  }

  Future<List<String>> uploadFiles(
      String uid, List<PlatformFile> files, String folderName) async {
    List<String> downloadURLs = [];

    for (PlatformFile file in files) {
      File fileToUpload = File(file.path!);
      String fileName = file.name;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('$uid/campaigns/$folderName/$timestamp-$fileName')
            .putFile(fileToUpload);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        downloadURLs.add(downloadURL);
      } catch (e) {
        print('Error uploading file: $fileName, $e');
      }
    }
    return downloadURLs;
  }

  @override
  void initState() {
    fetchCurrentNgoData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.whitebgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: myColors.whitebgcolor,
        title: Text(
          "Create Campaign",
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
          decoration: BoxDecoration(
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
                    GestureDetector(
                      onTap: () async {
                        await pickFile();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          height: 82.h,
                          width: 380.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                color: myColors.theme_turquoise,
                              ),
                              10.h.verticalSpace,
                              Text(
                                "Add Cover Photos",
                                style: MyTextStyles.SecondaryTextStyle()
                                    .copyWith(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: selectedFileList.length,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.w,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 0.058.sh,
                              width: 83.w,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                        File(selectedFileList[index]
                                            .path
                                            .toString()),
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: myColors.theme_turquoise),
                            ),
                            Positioned(
                              left: 20.w,
                              bottom: 40.h,
                              child: GestureDetector(
                                onTap: () {
                                  selectedFileList.removeAt(index);
                                  setState(() {});
                                },
                                child: badges.Badge(
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: Colors.white10,
                                    ),
                                    badgeContent: Icon(
                                      Icons.cancel,
                                      color: myColors.theme_turquoise,
                                    )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    16.h.verticalSpace,
                    Text("Fundraising Details",
                        style: MyTextStyles.HeadingStyle()),
                    16.h.verticalSpace,

                    // title field

                    Text("Title",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      hintText: 'Title',
                      controller: titleController,
                    ),
                    16.h.verticalSpace,

                    // description field

                    Text("Description",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      hintText: 'Description',
                      controller: descController,
                    ),
                    16.h.verticalSpace,

                    Text("Category",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Container(
                        height: 48.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(),
                        child: const DropdownWidget(
                            hint: "Obidience, Protection",
                            items: [
                              "Disaster Relief",
                              "Hunger",
                              "Humanity",
                            ])),
                    16.h.verticalSpace,
                    Text("Total Donation Required",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      suffix: Text(
                        'ETH',
                        style: TextStyle(
                            color: myColors.theme_turquoise,
                            fontSize: 14.h,
                            fontWeight: FontWeight.bold),
                      ),
                      hintText: '0.2',
                      controller: totalDonationController,
                    ),

                    16.h.verticalSpace,
                    Text("Donation Expiration Date",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      readOnly: true,
                      hintText: selectedDate.toLocal().toString().split(' ')[0],
                      controller: expirationDateController,
                      onTap: () {
                        _selectDate(context);
                      },
                      suffixIcon: Icon(
                        Icons.calendar_month_sharp,
                        color: myColors.themeGreyColor,
                      ),
                    ),

                    16.h.verticalSpace,
                    Text("Fund Usage Plan",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      hintText: 'your message',
                      controller: fundUsageController,
                    ),

                    50.h.verticalSpace,
                    Text("Donation Recipient Details",
                        style: MyTextStyles.HeadingStyle()),
                    16.h.verticalSpace,
                    Text("Name of Recipient (People/Organization)",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      hintText: "ex : Children of Palestine",
                      controller: recipientNameController,
                    ),

                    16.h.verticalSpace,
                    Text("Donation Proposal Documents",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    Obx(
                      () => MyTextFormField(
                          hintText: filesUploaded1.value
                              ? 'Files Uploaded'
                              : 'Select Documents',
                          onTap: () {
                            _pickFiles(selectedFiles1, filesUploaded1);
                            setState(() {});
                          },
                          readOnly: true,
                          suffixIcon: Icon(
                            Icons.upload,
                            size: 20,
                          )),
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: selectedFiles1.length,
                      padding: EdgeInsets.symmetric(
                        vertical: 20.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.w,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 0.058.sh,
                              width: 83.w,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                        File(selectedFiles1[index].toString()),
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: myColors.theme_turquoise),
                            ),
                            Positioned(
                              left: 20.w,
                              bottom: 35.h,
                              child: GestureDetector(
                                onTap: () {
                                  selectedFiles1.removeAt(index);
                                  setState(() {});
                                },
                                child: badges.Badge(
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: Colors.white10,
                                    ),
                                    badgeContent: Icon(
                                      Icons.cancel,
                                      color: myColors.theme_turquoise,
                                    )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // SizedBox(height: 8.h),
                    // SizedBox(
                    //   height: Get.height,
                    //   child: ListView.builder(
                    //     itemCount: selectedFiles1.length,
                    //     itemBuilder: (context, index) {
                    //       return ListTile(
                    //         title: Text(selectedFiles1[index]),
                    //       );
                    //     },
                    //   ),
                    // ),

                    Text("Total No of Beneficiaries",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    MyTextFormField(
                      hintText: "ex : 10",
                      controller: totalBeneficairiesController,
                    ),
                    // Text("Upload Additional Documents (if any)",
                    //     style: MyTextStyles.HeadingStyle()
                    //         .copyWith(fontSize: 16.h)),
                    // Obx(
                    //   () => MyTextFormField(
                    //       hintText: filesUploaded2.value
                    //           ? 'Files Uploaded'
                    //           : 'Select Documents',
                    //       onTap: () {
                    //         _pickFiles(selectedFiles2, filesUploaded2);
                    //         setState(() {});
                    //       },
                    //       readOnly: true,
                    //       suffixIcon: Icon(
                    //         Icons.upload_file,
                    //         size: 20,
                    //       )),
                    // ),
                    // SizedBox(height: 8.h),
                    // ListView.builder(
                    //   itemCount: selectedFiles2.length,
                    //   itemBuilder: (context, index) {
                    //     return ListTile(
                    //       title: Text(selectedFiles2[index]),
                    //     );
                    //   },
                    // ),

                    16.h.verticalSpace,
                    Text("Story",
                        style: MyTextStyles.HeadingStyle()
                            .copyWith(fontSize: 16.h)),
                    4.h.verticalSpace,
                    SizedBox(
                      height: 150.h,
                      child: MyTextFormField(
                        hintText: "Story about the recipients",
                        controller: storyController,
                        // expands: true,
                        maxlines: 15,
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
        padding: EdgeInsets.only(bottom: 0.010.sh, top: 0.010.sh),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //     height: 0.056.sh,
            //     width: 110.w,
            //     child: MainButton(
            //       title: "Save",
            //       ontap: () {},
            //       // ontap: () => Get.to(() => EditCompaignScreen(
            //       //       ImagesList: selectedFileList,
            //       //       title: titleController.text,
            //       //       msg: fundUsageController.text,
            //       //       Story: storyController.text,
            //       //       Recipient: recipientNameController.text,
            //       //       donation: totalDonationController.text,
            //       //       date: expirationDateController.text,
            //       //     ))
            //     )),
            // 20.w.horizontalSpace,
            SizedBox(
              height: 0.056.sh,
              // width: 236.w,
              child: Obx(
                () => ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      overlayColor: Colors.white.withOpacity(0.2),
                      backgroundColor: myColors.theme_turquoise,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      )),
                  label: Text(
                    "Create & Submit",
                  ),
                  icon: createCampaignController.loading.value
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.cloud_upload),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _timerController.startTimer();
                    // adding the field values to model inside an array

                    String title = titleController.text;
                    String description = descController.text;
                    String story = storyController.text;
                    String donationamount = totalDonationController.text;
                    String expDate = expirationDateController.text;
                    String recipient = recipientNameController.text;
                    List<String> cover_photo = [];
                    List<Map<String, String>>? additional_docs = [];
                    String fund = fundUsageController.text;
                    String status = "pending";
                    String total_beneficiaries =
                        totalBeneficairiesController.text;

                    // adding to the NgoCampaignModel array
                    NGOCampaignModel proposal = NGOCampaignModel(
                      cover_photo: cover_photo,
                      title: title,
                      description: description,
                      story: story,
                      name_of_recipient: recipient,
                      total_donation_required: donationamount,
                      donation_expiration_date: expDate,
                      fund_usage_plan: fund,
                      ngoName: ngoData!['username'],
                      email: ngoData!['email'],
                      registrationID: ngoData!['ngono'],
                      additional_docs: additional_docs,
                      status: status,
                      total_no_of_beneficiaries: total_beneficiaries,
                      total_donations_received: '0',
                      // total_donations_received: '0',
                    );

                    // Validate fields
                    bool isValid = validateCampaignFields(
                      title: title,
                      description: description,
                      story: story,
                      donationamount: donationamount,
                      expDate: expDate,
                      recipient: recipient,
                      selectedFileList: selectedFileList,
                      fund: fund,
                      totalBeneficiaries: total_beneficiaries,
                    );

                    if (!isValid) {
                      return;
                    }


                    // Create campaign

                    createCampaignController.loading.value = true;
                    Utils.showAlertAndNavigateGeneral(
                        context,
                        true,
                        createCampaignController.loading.value
                            ? 'Creating Campaign..'
                            : 'Successfully Submitted',
                        'Please wait while we create your campaign ! it may take few seconds..',
                        SpinKitWaveSpinner(
                          waveColor: myColors.theme_turquoise,
                          trackColor: myColors.theme_turquoise.withOpacity(0.5),
                          color: myColors.theme_turquoise,
                        ));


                    var result =
                        await createCampaignController.registerCampaignAPi(
                      ngoData!['ngono'],
                      ngoData!['address'],
                      total_beneficiaries,
                      donationamount,
                      proposal,
                      selectedFileList,
                    );


                    // Save the campaign to Firestore
                    // If API call is successful, save the campaign to Firestore
                    if (result != null &&
                        result['response']['message'] ==
                            'Transaction successful') {
                      log('saving to the firestore...');
                      // Set tokenUri in the proposal model
                      proposal.tokenUri = result['tokenUri'];
                      proposal.tokenId = result['response']['tokenId'];
                      // Save the campaign to Firestore
                      await saveCampaignToFirestore(proposal);
                      createCampaignController.loading.value = false;
                      Get.back();
                      FocusManager.instance.primaryFocus?.unfocus();
                      Future.delayed(300.ms, () {
                        return Utils.showAlertAndNavigateGeneral(
                            context,
                            false,
                            "Submit Successful!",
                            "Currently reviewing your campaign proposal. We'll notify you of the update soon.",
                            AppImages.alertIcon);
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    BottomNavScreenNgo(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      });
                    } else {
                      createCampaignController.loading.value = false;
                      Get.snackbar(
                          "Error",
                          result?['response']['message'] ??
                              "Failed to create campaign");
                    }

                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateCampaignFields({
    required String title,
    required String description,
    required String story,
    required String donationamount,
    required String expDate,
    required String recipient,
    required List<PlatformFile> selectedFileList,
    required String fund,
    required String totalBeneficiaries,
  }) {

    final RegExp decimalRegExp = RegExp(r'^\d*\.?\d+$');
    final RegExp integerRegExp = RegExp(r'^\d+$');

    if (title.isEmpty) {
      Get.snackbar("Error", "Title cannot be empty");
      return false;
    }
    if (description.isEmpty) {
      Get.snackbar("Error", "Description cannot be empty");
      return false;
    }
    if (story.isEmpty) {
      Get.snackbar("Error", "Story cannot be empty");
      return false;
    }
    if (donationamount.isEmpty) {
      Get.snackbar("Error", "Donation amount cannot be empty");
      return false;
    }

    if (!decimalRegExp.hasMatch(donationamount)) {
      Get.snackbar("Error", "Invalid donation amount format");
      return false;
    }

    if (expDate.isEmpty) {
      Get.snackbar("Error", "Expiration date cannot be empty");
      return false;
    }
    if (recipient.isEmpty) {
      Get.snackbar("Error", "Recipient name cannot be empty");
      return false;
    }
    if (selectedFileList.isEmpty) {
      Get.snackbar("Error", "Cover photo cannot be empty");
      return false;
    }
    if (fund.isEmpty) {
      Get.snackbar("Error", "Fund usage plan cannot be empty");
      return false;
    }

    if (totalBeneficiaries.isEmpty) {
      Get.snackbar("Error", "Total Beneficiaries cannot be empty");
      return false;
    }

    if (!integerRegExp.hasMatch(totalBeneficiaries)) {
      Get.snackbar("Error", "Invalid total beneficiaries format");
      return false;
    }


    return true;
  }

  void showAlertAndNavigate(BuildContext context) {
    alertDialogue(
      context,
      "Submit Successful!",
      "Currently reviewing your campaign proposal. We'll notify you of the update soon.",
      AppImages.alertIcon,
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BottomNavScreenNgo(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
        (Route<dynamic> route) => false,
      );
    });
  }
}
