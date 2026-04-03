import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Padding shortcuts
  static const EdgeInsets paddingAll_s = EdgeInsets.all(s);
  static const EdgeInsets paddingAll_m = EdgeInsets.all(m);
  static const EdgeInsets paddingAll_l = EdgeInsets.all(l);

  static const EdgeInsets paddingH_m = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets paddingV_m = EdgeInsets.symmetric(vertical: m);

  static const EdgeInsets paddingPage = EdgeInsets.symmetric(horizontal: m, vertical: l);
}
