import 'package:aidance_app/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.height,
    required this.width,
    required this.image,
  });
  final height;
  final width;
  final image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 16,
        shadowColor: Color(0xff7B8BB2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            // color: Colors.purple[400],
            borderRadius: BorderRadius.circular(24.r),
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
