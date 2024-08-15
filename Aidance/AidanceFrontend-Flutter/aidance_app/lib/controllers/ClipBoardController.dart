import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ClipBoardController extends GetxController {
  final RxString myText =
      "0x00sadnkasjdkansjd23838sdsdsrrrrrsddfttyzskmdlkaslas001".obs;

  void updateText(String newText) {
    myText.value = newText;
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: myText.value));
    Get.back();
    Get.snackbar(
      'Clipboard',
      'Text copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
