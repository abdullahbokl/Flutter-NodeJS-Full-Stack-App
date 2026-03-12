import 'package:flutter/material.dart';

class AppShadows {
  static const sm = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
  static const md = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
  static const lg = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0D000000), blurRadius:  8, offset: Offset(0, 2)),
  ];
}

