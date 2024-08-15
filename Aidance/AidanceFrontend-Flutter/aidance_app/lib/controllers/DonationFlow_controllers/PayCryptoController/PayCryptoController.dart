import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayCryptoController extends GetxController {
  // crypto text field
  RxBool istap = false.obs;
  RxBool istapUsdfield = false.obs;
  FocusNode cryptoFieldFocus = FocusNode();
  FocusNode UsdFieldFocus = FocusNode();

  Ontap() {
    istap.value = true;
  }

  OntapUsdField() {
    istapUsdfield.value = true;
  }

  //DropDown
  RxBool isDropDownTapped = false.obs;

  //Connect your Wallet Choice Chip
  RxBool isChoiceChipSelected = false.obs;
}
