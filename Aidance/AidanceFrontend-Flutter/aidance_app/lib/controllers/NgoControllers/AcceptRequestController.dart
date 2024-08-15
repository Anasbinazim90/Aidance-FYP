import 'package:get/get.dart';

class AcceptRequestController extends GetxController {
  // ... other code ...

  // Add a boolean variable to track visibility
  var isContainerVisible = false.obs;
  var istrue = false.obs;

  removeRequest() {
    if (isContainerVisible.value = true) {
      istrue.value = true;
    }
  }

  // ... other code ...
}
