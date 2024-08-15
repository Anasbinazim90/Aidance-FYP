import 'package:get/get.dart';

class ChipsController extends GetxController {
  int currentIndex = 0;
  int catIndex = 0;
  setCattIndex(int value) {
    catIndex = value;
    update();
  }

  // setCurrentIndex(int value) {
  //   currentIndex = value;
  //   update();
  // }
}
