import 'package:flutter/material.dart';

extension ThemeColors on BuildContext {
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
}
