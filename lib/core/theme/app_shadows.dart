import 'package:flutter/material.dart';

class AppShadows {
  static const sm = [
    BoxShadow(color: Color(0x120E2333), blurRadius: 12, offset: Offset(0, 4)),
  ];
  static const md = [
    BoxShadow(color: Color(0x180E2333), blurRadius: 20, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x0CFFFFFF), blurRadius: 3, offset: Offset(0, -1)),
  ];
  static const lg = [
    BoxShadow(color: Color(0x220E2333), blurRadius: 28, offset: Offset(0, 16)),
    BoxShadow(color: Color(0x0FFFFFFF), blurRadius: 4, offset: Offset(0, -1)),
  ];
}
