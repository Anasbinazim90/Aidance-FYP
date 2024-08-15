import 'package:aidance_app/components/glassMorphism.dart';
import 'package:aidance_app/controllers/DonationFlow_controllers/PayCryptoController/PayCryptoController.dart';
import 'package:aidance_app/screens/DonationFlow/PaywithWallet.dart/DropDownWidget.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PayCryptoWidget extends StatelessWidget {
  PayCryptoWidget({super.key, this.controller});

  final controller;

  final pay_crypto_controller = Get.put(PayCryptoController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        pay_crypto_controller.Ontap();
        FocusScope.of(context)
            .requestFocus(pay_crypto_controller.cryptoFieldFocus);
      },
      child: Obx(() => Ink(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.2.w,
                color: pay_crypto_controller.istap.value
                    ? myColors.theme_turquoise
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(16.r),
              color: Color(0xFFFAFAFA),
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
                      Text('Crypto',
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
                        child: PayCrypto_TextField(context, controller),
                      ),
                    ],
                  )),
              Positioned(
                right: 20.w,
                bottom: 20.h,
                child: DropDownWidget2(),
              ),
            ]),
          )),
    ).animate().shimmer(
        duration: 900.ms,
        size: 10,
        color: Palette.theme_turquoise[500],
        delay: 400.ms);
  }

  PayCrypto_TextField(BuildContext context, controller) {
    return TextFormField(
      controller: controller,
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
      focusNode: pay_crypto_controller.cryptoFieldFocus,
      onTap: () {
        pay_crypto_controller.istap.value = true;
        pay_crypto_controller.UsdFieldFocus.unfocus();
        pay_crypto_controller.istapUsdfield.value = false;
        pay_crypto_controller.cryptoFieldFocus.requestFocus();
      },
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        pay_crypto_controller.istap.value = false;
      },
    );
  }
}
