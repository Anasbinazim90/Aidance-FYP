//palette.dart
import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor theme_turquoise = MaterialColor(
    0xff00bdd6, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff1ac4da), //10%
      100: Color(0xff33cade), //20%
      200: Color(0xff4dd1e2), //30%
      300: Color(0xff66d7e6), //40%
      400: Color(0xff80deeb), //50%
      500: Color(0xff99e5ef), //60%
      600: Color(0xffb3edf3), //70%
      700: Color(0xffccf2f7), //80%
      800: Color(0xffe6f8fb), //90%
      900: Color(0xffffffff), //100%
    },
  );
}
