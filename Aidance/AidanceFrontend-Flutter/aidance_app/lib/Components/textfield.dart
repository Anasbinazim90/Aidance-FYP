import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final submit;
  final widthh;
  double? labelfont;
  void Function()? onTap;
  // void Function()? onTapOutside;
  bool readOnly = false;

  String? text;
  final controller;
  final suffixIcon;
  final validator;
  final isPassword;
  // final labelText;
  final prefixIcon;
  final hint;
  double? fontsize;
  final colors;
  var icon;
  final heightt;
  final maxlines;
  final fborder;
  final eborder;
  final keyboard;
  bool? isEnabled;
  FocusNode? focus;
  CustomTextField({
    Key? key,
    this.readOnly = false,
    this.labelfont,
    this.submit,
    this.colors,
    this.fontsize,
    this.text,
    this.controller,
    this.hint,
    this.validator,
    this.icon,
    this.suffixIcon,
    required this.widthh,
    required this.isPassword,
    this.prefixIcon,
    this.heightt,
    this.maxlines,
    this.fborder,
    this.eborder,
    this.keyboard,
    this.focus,
    this.isEnabled,
    this.onTap,
    // required this.labelText,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<CustomTextField> {
  bool isObes = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.widthh,
      height: widget.heightt ?? 48.h,
      child: TextFormField(
        readOnly: widget.readOnly,
        controller: widget.controller,
        onTap: widget.onTap,
        textInputAction: TextInputAction.done,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        focusNode: widget.focus,
        maxLines: widget.maxlines ?? 1,
        obscureText: widget.isPassword == true ? isObes : false,
        cursorColor: Colors.grey[400],
        keyboardType: widget.keyboard,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: 20.h),
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          // prefixIcon: Icon(Icons.email),
          filled: true,
          fillColor: const Color(0x379E9E9E),
          prefixIcon: widget.prefixIcon,
          labelText: widget.text,
          hintText: widget.hint,
          labelStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),

          suffixIcon: widget.isPassword == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isObes = !isObes;
                    });
                  },
                  child: Icon(
                    isObes == false
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: (widget.isEnabled ?? false)
                        ? myColors.theme_turquoise
                        : Colors.grey,
                    size: 22.r,
                  ),
                )
              : widget.suffixIcon,
          hintStyle:
              TextStyle(color: Colors.grey.withOpacity(0.7.r), fontSize: 16.sp),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
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
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myColors.theme_turquoise, width: 1.w),
            borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: myColors.theme_turquoise, width: 1.w),
          //   borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
          // ),
        ),
      ),
    );
  }
}
