import 'package:aidance_app/controllers/DaoControllers/ngoTimerController.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Ngotimerscreen extends StatelessWidget {
  final Ngotimercontroller _timerController = Get.put(Ngotimercontroller());

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Text(
        _formatDuration(_timerController.remainingTime.value),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          // Use your color here
          color: myColors.theme_turquoise,
        ),
      );
    });
  }
}
