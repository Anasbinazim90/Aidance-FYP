import 'package:aidance_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.back();
      },
      child: SvgPicture.asset(
        AppImages.Img_arrow_left,
        width: 24.w,
        height: 24.h,
      ),
    );
  }
}
