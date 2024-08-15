import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: myColors.theme_turquoise,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
