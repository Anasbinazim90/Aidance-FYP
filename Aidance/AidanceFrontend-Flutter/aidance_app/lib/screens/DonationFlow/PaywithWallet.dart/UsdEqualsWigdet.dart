import 'package:aidance_app/controllers/DonationFlow_controllers/PayCryptoController/PayCryptoController.dart';
import 'package:aidance_app/screens/DonationFlow/PaywithWallet.dart/FixedUsdContainer.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UsdEqualsWidget extends StatelessWidget {
  UsdEqualsWidget({super.key});

  final usd_equals_controller = Get.put(PayCryptoController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        usd_equals_controller.OntapUsdField();
        FocusScope.of(context)
            .requestFocus(usd_equals_controller.UsdFieldFocus);
      },
      child: Obx(
        () => Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: const Color(0xFFFAFAFA),
            border: Border.all(
              width: 1.2.w,
              color: usd_equals_controller.istapUsdfield.value
                  ? myColors.theme_turquoise
                  : Colors.transparent,
            ),
          ),
          child: Stack(children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                width: double.infinity.w,
                height: 115.h, //115
                padding: EdgeInsets.only(
                    top: 15.h, bottom: 20.h, left: 16.w, right: 11.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Usd',
                        style: MyTextStyles.SecondaryTextStyle()
                            .copyWith(fontSize: 15.sp)),
                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      width: 190.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        // color: Colors.green.shade100,
                      ),
                      child: PayCrypto_TextField(context),
                    ),
                  ],
                )),
            Positioned(
              right: 20.w,
              bottom: 20.h,
              child: const FixedUsdContainer(),
            ),
          ]),
        ),
      ),
    );
  }

  PayCrypto_TextField(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      cursorHeight: 28.h,
      cursorWidth: 1.5.w,
      cursorColor: const Color.fromARGB(255, 165, 158, 158),
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        isDense: true,
        hintText: '0.00',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.only(left: 5.w, top: 12.h),
      ),
      style: MyTextStyles.SecondaryTextStyle().copyWith(
        fontFamily: GoogleFonts.anton().fontFamily,
        fontSize: 28.sp,
        height: 1.3.h,
        color: Colors.black,
      ),
      focusNode: usd_equals_controller.UsdFieldFocus,
      onTap: () {
        usd_equals_controller.istapUsdfield.value = true;
        usd_equals_controller.cryptoFieldFocus.unfocus();
        usd_equals_controller.istap.value = false;
        usd_equals_controller.UsdFieldFocus.requestFocus();
      },
      onTapOutside: (event) {
        usd_equals_controller.UsdFieldFocus.unfocus();
        usd_equals_controller.istapUsdfield.value = false;
      },
    );
  }
}
