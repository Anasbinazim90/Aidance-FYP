import 'dart:async';

import 'package:get/get.dart';

class VotingBoxController extends GetxController {
  RxString selectedOption = ''.obs;
  var hasVoted = false.obs;

  void castVote(String option) {
    if (!hasVoted.value) {
      selectedOption.value = option;
      hasVoted.value = true;
    }
  }
}

class TimerController extends GetxController {
  Rx<Duration> remainingTime = Duration(minutes: 5).obs;
  late Timer _timer;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _startTimer();
  // }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      remainingTime.value = remainingTime.value - Duration(seconds: 1);
      if (remainingTime.value.inSeconds <= 0) {
        timer.cancel();

        // Timer ended
        // You can navigate to another screen or perform any other action here
        print('Timer ended!');
      }
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
