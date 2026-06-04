import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Vertical SizedBoxes
  static const vXs = SizedBox(height: xs);
  static const vSm = SizedBox(height: sm);
  static const vMd = SizedBox(height: md);
  static const vLg = SizedBox(height: lg);
  static const vXl = SizedBox(height: xl);

  // Horizontal SizedBoxes
  static const hXs = SizedBox(width: xs);
  static const hSm = SizedBox(width: sm);
  static const hMd = SizedBox(width: md);
  static const hLg = SizedBox(width: lg);
  static const hXl = SizedBox(width: xl);

  // EdgeInsets
  static const paddingXs = EdgeInsets.all(xs);
  static const paddingSm = EdgeInsets.all(sm);
  static const paddingMd = EdgeInsets.all(md);
  static const paddingLg = EdgeInsets.all(lg);
  static const paddingXl = EdgeInsets.all(xl);

  static const paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  static const paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
}
