import 'package:flutter/material.dart';

class AppBorderRadius {
  AppBorderRadius._();

  static const double smValue = 8;
  static const double mdValue = 12;
  static const double lgValue = 16;
  static const double xlValue = 20;
  static const double roundValue = 100;

  static final sm = BorderRadius.circular(smValue);
  static final md = BorderRadius.circular(mdValue);
  static final lg = BorderRadius.circular(lgValue);
  static final xl = BorderRadius.circular(xlValue);
  static final round = BorderRadius.circular(roundValue);

  static const topLg = BorderRadius.vertical(top: Radius.circular(16));
  static const bottomLg = BorderRadius.vertical(bottom: Radius.circular(16));
}
