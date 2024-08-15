import 'package:aidance_app/components/ListItem.dart';
import 'package:aidance_app/components/glassMorphism.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/DonationInfo_controllers/DonationInfo_controller.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class InputFields {
  // controllers
  final fieldcontroller = Get.put(FieldController());
  final Source_of_funds_controller = Get.put(SourceOfFundsController());

  // Name Field
  NameField(BuildContext context, controller) {
    return Column(children: [
      SizedBox(
        height: 48.h,
        child: TextFormField(
          controller: controller,
          onTapOutside: (event) {
            fieldcontroller.namefocus.value.unfocus();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {}
            return null;
          },
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          // onTap: () {},
          onFieldSubmitted: (value) => FocusScope.of(context)
              .requestFocus(fieldcontroller.emailfocus.value),
          // controller: loginController.email,
          focusNode: fieldcontroller.namefocus.value,
          textInputAction: TextInputAction.next,
          // autofocus: true,
          maxLines: null,
          cursorColor: myColors.theme_turquoise,

          style: TextStyle(
            // height: 1.h,
            fontSize: 16.sp,
          ),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
            filled: true,
            fillColor: const Color(0x379E9E9E),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: myColors.theme_turquoise,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            hintText: 'Name',
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
            ),

            // prefixIcon: Icon(EvaIcons.email, color: myColors.theme_turquoise.blue)
          ),
        ),
      )
    ]);
  }

  // EmailField
  EmailField(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 48.h,
        child: TextFormField(
          onTapOutside: (event) {
            fieldcontroller.emailfocus.value.unfocus();
          },
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          // onTap: () {},
          // onFieldSubmitted: (value) => FocusScope.of(context)
          //     .requestFocus(fieldController.passwordfocus.value),
          // controller: loginController.email,
          focusNode: fieldcontroller.emailfocus.value,
          textInputAction: TextInputAction.next,
          // autofocus: true,
          maxLines: null,
          cursorColor: myColors.theme_turquoise,
          style: TextStyle(
            // height: 1.h,
            fontSize: 16.sp,
          ),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
            floatingLabelAlignment: FloatingLabelAlignment.start,

            filled: true,
            fillColor: const Color(0x379E9E9E),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: myColors.theme_turquoise,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            hintText: 'Example@gmail.com',
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
            ),
            // prefixIcon: Icon(EvaIcons.email, color: mytheme.blue)
          ),
        ),
      )
    ]);
  }

  // Source Of Funds Dropdown
  SourceOfFunds_Dropdown(context) {
    return Column(children: [
      SizedBox(
        height: 48.h,
        child: Obx(
          () => TextFormField(
            readOnly: true,

            onTap: () {
              Source_of_funds_controller.Unfoucs_DropDown();

              BottomSheet(context);
            },
            enabled: Source_of_funds_controller.isTextFieldEnabled.value,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            // onTap: () {},
            onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
            controller: Source_of_funds_controller.sourceofFunds_value_contrllr,
            focusNode: fieldcontroller.DropDownfocus.value,
            textInputAction: TextInputAction.done,
            // autofocus: true,
            maxLines: null,
            cursorColor: Colors.grey[400],
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
              // labelStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
              // label: Text('Source Of Funds'),
              floatingLabelAlignment: FloatingLabelAlignment.start,
              filled: true,
              fillColor: const Color(0x379E9E9E),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: myColors.theme_turquoise,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              hintText: 'Select Source',
              hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
              // prefixIcon: Icon(EvaIcons.email, color: mytheme.blue)
              suffixIcon: Icon(
                BoxIcons.bxs_down_arrow,
                color: Colors.grey[600],
                size: 14.sp,
              ),
            ),
          ),
        ),
      )
    ]);
  }

  //Drop Down Bottom Sheet
  Future<dynamic> BottomSheet(context) {
    return showModalBottomSheet(
        enableDrag: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassWidget(
                blur: 15,
                opacity: 0.9,
                child: Container(
                    alignment: Alignment.bottomCenter,
                    // height: 300,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        // color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.r),
                            topRight: Radius.circular(25.r))),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 350,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          // border: Border.all(width: 2),
                        ),
                        margin: EdgeInsets.only(top: 5.h),
                        child: ListView.builder(
                          // shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              Source_of_funds_controller.SourceOfFunds.length,
                          itemBuilder: ((context, index) {
                            return Obx(
                              () => Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 28.w),
                                  onTap: () {
                                    Source_of_funds_controller.changeIndex(
                                        index);
                                    Source_of_funds_controller
                                        .istappedListTile();
                                    Source_of_funds_controller.setValue(index);

                                    Get.back();
                                    print('tapp');
                                    print(
                                        Source_of_funds_controller.istap.value);
                                  },
                                  leading: Image(
                                    image: AssetImage(Source_of_funds_controller
                                        .SourceOfFundsIcon[index]),
                                    width: 35.w,
                                    height: 35.h,
                                  ),
                                  enabled: true,
                                  tileColor:
                                      Source_of_funds_controller.currentIndex ==
                                              index
                                          ? myColors.theme_turquoise
                                              .withOpacity(0.3)
                                          : Colors.transparent,
                                  title: Text(
                                    Source_of_funds_controller
                                        .SourceOfFunds[index],
                                    style: MyTextStyles.SecondaryTextStyle()
                                        .copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ))),
              )
                  .animate()
                  .saturate(begin: 0.0, end: 1.0, duration: 1000.ms)
                  .shimmer(),
            ],
          );
        }));
  }

// MessageBox
  MessgaeBox(context, controller) {
    return Column(children: [
      Container(
        // height: 55.h,
        child: TextFormField(
          controller: controller,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.top,
          // onTap: () {},
          onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
          // controller: loginController.email,
          focusNode: fieldcontroller.msgfocus.value,
          textInputAction: TextInputAction.next,
          // autofocus: true,
          maxLines: 8,

          cursorColor: Colors.grey[400],
          // cursorColor: myColors.theme_turquoise,
          style: TextStyle(
            // height: 1.h,
            fontSize: 16.sp,
          ),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            // labelStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
            // label: Text('Your Message'),
            contentPadding:
                EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),

            alignLabelWithHint: true,

            floatingLabelAlignment: FloatingLabelAlignment.start,

            filled: true,
            fillColor: const Color(0x379E9E9E),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: myColors.theme_turquoise,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            hintText: 'write message',
            hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[500]),
            // prefixIcon: Icon(EvaIcons.email, color: mytheme.blue)
          ),
        ),
      )
    ]);
  }
}
