import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActiveNgoCard extends StatelessWidget {
  const ActiveNgoCard({
    super.key,
    required this.donation,
    required this.title,
    required this.expirationdate,
    required this.recipient,
    required this.onTap,
    this.image,
    required this.progressvalue,
  });
  final String? donation;
  final dynamic image;
  final String? title;
  final String? expirationdate;
  final String? recipient;
  final void Function()? onTap;
  final double progressvalue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
        height: 125.h,
        width: 332.w,
        decoration: BoxDecoration(
          color: myColors.whitebgcolor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              spreadRadius: 0.1,
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child: Container(width: 100.w, child: image),
            ),
            15.w.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.h.verticalSpace,
                Text(
                  '${title}',
                  style: MyTextStyles.HeadingStyle().copyWith(fontSize: 18),
                ),
                10.h.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${donation} tokens",
                      style: MyTextStyles.SecondaryTextStyle().copyWith(
                          color: myColors.theme_turquoise, fontSize: 12),
                    ),
                    3.w.horizontalSpace,
                    Text("funding required",
                        style: MyTextStyles.SecondaryTextStyle()
                            .copyWith(fontSize: 12)),
                  ],
                ),
                15.h.verticalSpace,
                Row(
                  children: [
                    SizedBox(
                      width: 230.w,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10.r),
                        value: progressvalue,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            myColors.theme_turquoise),
                        backgroundColor: myColors.light_theme,
                      ),
                    ),
                  ],
                ),
                10.h.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${recipient}",
                      style: MyTextStyles.Subtitle().copyWith(
                          color: myColors.theme_turquoise,
                          fontWeight: FontWeight.w400),
                    ),
                    15.w.horizontalSpace,
                    Text(
                      "${expirationdate}",
                      style: MyTextStyles.Subtitle().copyWith(
                          color: myColors.theme_turquoise,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
