import 'dart:ui';

import 'package:flutter/material.dart';

class Themes {
  static ThemeData simple() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Robot',
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.lightBlue[800],
          secondary: Colors.red[500]
      ),
    );
  }
}