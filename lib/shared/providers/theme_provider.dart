import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';

class ThemeNotifier extends StateNotifier<String> {
  ThemeNotifier(super.state);
  void updateTheme(String theme) {
    state = theme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, String>(
  (ref) {
    final prefTheme = sharedPreferences.getBool("darkmode");
    final theme = prefTheme != null
        ? (prefTheme ? "dark" : "light")
        : (PlatformDispatcher.instance.platformBrightness == Brightness.dark
            ? "dark"
            : "light");
    return ThemeNotifier(theme);
  },
);
