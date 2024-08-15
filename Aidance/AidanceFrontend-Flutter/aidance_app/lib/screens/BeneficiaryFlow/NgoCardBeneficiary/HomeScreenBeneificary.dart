import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/AuthControllerBeneficiary.dart';
import 'package:aidance_app/controllers/EndUserModelController.dart';
import 'package:aidance_app/controllers/NgoControllers/AcceptRequestController.dart';
import 'package:aidance_app/models/BeneficiaryModel/BeneficiaryModel.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/horizontal_coupon.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:aidance_app/utils/vertical_coupon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreenBeneficary extends StatelessWidget {
  HomeScreenBeneficary({
    super.key,
    // required this.requestController,
    this.username,
  });
  final EndUserModelController endUserModelController =
      Get.put(EndUserModelController());
  // final RequestController requestController;
  final String? username;

  final _controller = Get.put(AuthControllerBeneficiary());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _controller.signout();
                Get.to(RolesScreen());
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 2,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(),
          backgroundColor: myColors.whiteColor,
          title: Text(
            'Home',
            style: MyTextStyles.HeadingStyle()
                .copyWith(color: myColors.theme_turquoise),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text('Benefiiary home'),
              // Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 30.w),
              //     child: VerticalCouponExample()),
              // HorizontalCouponExample1(),
              // Ngo_Card_Widget(requestController: requestController),
            ],
          ),
        ));
  }
}

class Ngo_Card_Widget extends StatelessWidget {
  final AcceptRequestController acceptRequestController =
      Get.put(AcceptRequestController());
  Ngo_Card_Widget({
    super.key,
    required this.requestController,
  });

  final RequestController requestController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: acceptRequestController.isContainerVisible.value,
        child: SizedBox(
            height: 500.h,
            child: GestureDetector(
              onTap: () {
                // Get.toNamed(AppRoutes.hotelDetail);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Container(
                  margin:
                      EdgeInsets.only(right: 16.w, bottom: 10.h, left: 16.w),
                  height: 250.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: myColors.whitebgcolor,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                          child: Image.asset(
                            AppImages.sandstorm,
                            fit: BoxFit.cover,
                            height: 220.h,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16.w, top: 10.h, bottom: 10.h, right: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Transparent Hands",
                                  style: TextStyle(
                                      fontFamily: 'Epilogue',
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: myColors.HeadingColor)),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                  "Transparent Hands is the largest technology platform for crowdfunding in the healthcare sector of Pakistan. We offer a complete range of free healthcare services including medical and surgical treatments and arranging medical camps for the underprivileged community of Pakistan. Our goal is to reach millions of needy patients all over Pakistan who are suffering because of a lack of healthcare facilities. We continue to serve humanity at large by providing the best healthcare in Pakistan.",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Epilogue',
                                      fontSize: 14.sp,
                                      color: myColors.themeGreyColor)),
                              SizedBox(
                                height: 10.h,
                              ),
                              RatingWidget(rating: 4.7, numberOfRatings: 512),
                              SizedBox(
                                height: 15.h,
                              ),
                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    if (requestController.isRequestSent.value) {
                                      // Show confirmation dialog to cancel request
                                      Get.defaultDialog(
                                        title: 'Confirmation',
                                        middleText:
                                            'Do you want to cancel the request?',
                                        textConfirm: 'Yes',
                                        textCancel: 'No',
                                        onCancel: () {
                                          Get.back();
                                        },
                                        onConfirm: () {
                                          // Toggle the request status when confirmed to cancel
                                          requestController.isRequestSent
                                              .toggle();
                                          Get.back();
                                        },
                                      );
                                    } else {
                                      // Toggle the request status when clicked
                                      requestController.isRequestSent.toggle();
                                    }
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 200.w,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: requestController
                                              .isRequestSent.value
                                          ? Colors
                                              .green // Change color when request is sent
                                          : myColors.theme_turquoise,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        requestController.isRequestSent.value
                                            ? 'Request Sent'
                                            : 'Request Your Voucher',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w200,
                                          color: myColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final double rating;
  final int numberOfRatings;

  RatingWidget({required this.rating, required this.numberOfRatings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          rating.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 5.w),
        Row(
          children: List.generate(
            5,
            (index) {
              return Icon(
                index < rating.floor() ? Icons.star : Icons.star_border,
                color: Colors.orange,
              );
            },
          ),
        ),
        // SizedBox(width: 5.w),
        Text(
          '($numberOfRatings)',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      ],
    );
  }
}

class RequestController extends GetxController {
  RxBool isRequestSent = false.obs;
}
