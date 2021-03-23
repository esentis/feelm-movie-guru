import 'dart:ui';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:feelm/pages/landing_page.dart';
import 'package:feelm/theme_config.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

enum AniProps { width, height, color }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isPlatformDark =
        WidgetsBinding.instance!.window.platformBrightness == Brightness.dark;
    var initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ThemeProvider(
      initTheme: initTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Feelm',
          theme: ThemeProvider.of(context),
          home: const LandingPage(),
        );
      }),
    );
  }
}
