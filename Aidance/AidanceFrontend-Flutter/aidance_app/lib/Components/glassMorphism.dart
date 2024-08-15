import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassWidget extends StatelessWidget {
  const GlassWidget(
      {super.key,
      required this.blur,
      required this.opacity,
      required this.child});

  final double blur;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(0.2),
              )),
          child: child,
        ),
      ),
    );
  }
}
