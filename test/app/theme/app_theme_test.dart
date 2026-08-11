import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/app/theme/app_theme.dart';

void main() {
  test('provides distinct light and dark Serenity themes', () {
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.brightness, Brightness.dark);
    expect(AppTheme.light.colorScheme.primary, const Color(0xFF5C7C67));
  });
}
