import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:feelm/constants.dart';
import 'package:feelm/theme_clipper.dart';
import 'package:feelm/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ThemeProvider(
      initTheme: initTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeProvider.of(context),
          home: MyHomePage(),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feelm',
              ),
              ThemeSwitcher(
                clipper: const ThemeCustomClipper(),
                builder: (context) => IconButton(
                  onPressed: () {
                    kLog.wtf(WidgetsBinding.instance.window.platformBrightness);
                    ThemeSwitcher.of(context).changeTheme(
                      theme: ThemeProvider.of(context).brightness ==
                              Brightness.light
                          ? darkTheme
                          : lightTheme,
                    );
                  },
                  tooltip: 'Increment',
                  icon: FaIcon(
                    ThemeProvider.of(context).brightness == Brightness.light
                        ? FontAwesomeIcons.moon
                        : FontAwesomeIcons.sun,
                    color:
                        ThemeProvider.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.yellow,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('hello'),
            ],
          ),
        ),
      ),
    );
  }
}
