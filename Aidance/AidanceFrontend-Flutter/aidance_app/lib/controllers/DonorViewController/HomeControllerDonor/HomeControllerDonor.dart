import 'package:aidance_app/controllers/DonorViewController/BottomNavControllerDonor/BottomNavControllerDonor.dart';
import 'package:get/get.dart';

class HomeControllerDonor extends GetxController
    with GetSingleTickerProviderStateMixin {
  final BottomNavControllerUser navController =
      Get.put(BottomNavControllerUser());

  showDrawer() {
    print("showDrawer");

    refresh();
    navController.update();
  }

  hideDrawer() {
    print("hideDrawer");

    refresh();
    navController.update();
  }
}
