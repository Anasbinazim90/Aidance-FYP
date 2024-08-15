import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<dynamic> alertDialogue(
    BuildContext context, String heading, String subHeading, String url) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
        ),
        // contentPadding: const EdgeInsets.all(15),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        // shadowColor: Colors.white,
        actions: [
          Container(
            // padding: const EdgeInsets.all(15),
            height: 321.h,
            width: 318.w,
            decoration: BoxDecoration(
              color: Colors.white,
              backgroundBlendMode: BlendMode.darken,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                30.h.verticalSpace,
                SizedBox(
                    height: 84.h,
                    width: 84.w,
                    child: SvgPicture.asset(
                      url,
                      color: myColors.theme_turquoise,
                      fit: BoxFit.fitHeight,
                    )),
                16.h.verticalSpace,
                Text(heading,
                    textAlign: TextAlign.center,
                    style: MyTextStyles.HeadingStyle()
                        .copyWith(color: myColors.theme_turquoise)),
                16.h.verticalSpace,
                Text(subHeading,
                    textAlign: TextAlign.center,
                    style: MyTextStyles.SecondaryTextStyle()),
                0.024.sh.verticalSpace,
              ],
            ),
          ),
        ],
      );
    },
  );
}
