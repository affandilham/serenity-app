import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;
}

abstract final class AppRadius {
  static const small = Radius.circular(10);
  static const medium = Radius.circular(16);
  static const large = Radius.circular(22);
  static const pill = Radius.circular(999);

  static const card = BorderRadius.all(large);
  static const button = BorderRadius.all(medium);
}
