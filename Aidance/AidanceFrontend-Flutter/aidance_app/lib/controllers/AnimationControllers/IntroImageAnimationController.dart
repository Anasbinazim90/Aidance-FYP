import 'package:get/get.dart';

class IntroImagesAnimation extends GetxController {
  RxBool animate = false.obs;

  Future StartAnimaton() async {
    await Future.delayed(const Duration(milliseconds: 200));
    animate.value = true;
  }
}
