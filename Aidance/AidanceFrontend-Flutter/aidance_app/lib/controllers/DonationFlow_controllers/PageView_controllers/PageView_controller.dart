import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewController extends GetxController {
  //PageController
  final pageController = PageController();

  RxInt activeStep = 0.obs;
  RxInt Dotcount = 3.obs;
}
