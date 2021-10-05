//#FF6085

import 'package:flutter/material.dart';

primaryColor() => MaterialColor(0xFF20002C, customColor(32, 0, 44));
secondaryColor() => MaterialColor(0xFFCBB4D4, customColor(203, 180, 212));

Map<int, Color> customColor(int r, g, b) {
  return {
    50: Color.fromRGBO(r, g, b, .1),
    100: Color.fromRGBO(r, g, b, .2),
    200: Color.fromRGBO(r, g, b, .3),
    300: Color.fromRGBO(r, g, b, .4),
    400: Color.fromRGBO(r, g, b, .5),
    500: Color.fromRGBO(r, g, b, .6),
    600: Color.fromRGBO(r, g, b, .7),
    700: Color.fromRGBO(r, g, b, .8),
    800: Color.fromRGBO(r, g, b, .9),
    900: Color.fromRGBO(r, g, b, 1),
  };
}
