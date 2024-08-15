import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatefulWidget {
  MainButton(
      {super.key,
      this.width = 360,
      this.height = 44,
      required this.title,
      required this.ontap});

  final double width;
  final double height;
  final dynamic title;
  Function ontap;

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.ontap(),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(widget.width.w, widget.height.h),
        backgroundColor: myColors.theme_turquoise,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: Text(
        widget.title,
        style: TextStyle(fontSize: 16.sp, color: Colors.white),
      ),
    );
  }
}
