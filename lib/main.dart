import 'package:browser/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/src/constants.dart';
import 'screens/homepage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      themeMode: AppTheme.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // home: const HomePage(),
      initialRoute: '/',
      routes: {
        "/": (context) => const HomePage(),
      },
    );
  }
}
