import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.expands,
    this.maxlines,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffix,
  });
  final String hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final bool? expands;
  final int? maxlines;
  final void Function(String)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextFormField(
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        expands: expands ?? false,
        controller: controller,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        // onTap: () {},
        // onFieldSubmitted: (value) => FocusScope.of(context)
        //     .requestFocus(fieldcontroller.emailfocus.value),
        // controller: loginController.email,
        // focusNode: fieldcontroller.namefocus.value,
        textInputAction: TextInputAction.next,

        // autofocus: true,
        maxLines: maxlines,
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
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[500],
          ),
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,

          // prefixIcon: Icon(EvaIcons.email, color: myColors.theme_turquoise.blue)
        ),
      ),
    );
  }
}
