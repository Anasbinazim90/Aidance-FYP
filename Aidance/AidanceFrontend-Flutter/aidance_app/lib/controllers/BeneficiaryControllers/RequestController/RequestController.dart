import 'package:get/get.dart';

class RequestController extends GetxController {
  // Reactive variable to track whether the request is accepted or not
  var isRequestAccepted = false.obs;

  // Function to accept the request
  void acceptRequest() {
    // Your logic to accept the request goes here
    // Set isRequestAccepted to true if the request is accepted
    isRequestAccepted(true);
  }
}
