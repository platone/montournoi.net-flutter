import 'dart:ui';

class Styles {
  static TextStyle _h1 = TextStyle(color: const Color(0xFF000000), fontSize: 26, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold,);

  static TextStyle? h1() {
    return _h1;
  }
}