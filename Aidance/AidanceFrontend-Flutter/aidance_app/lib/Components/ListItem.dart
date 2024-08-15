import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.icon,
    required this.iconbgcolor,
  });

  final dynamic icon;
  final dynamic iconbgcolor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: CircleAvatar(
        radius: 28.h,
        backgroundColor: iconbgcolor,
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
