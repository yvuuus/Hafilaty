import 'package:bus_tracking_app/screens/main_page.dart';
import 'package:bus_tracking_app/screens/register_screen.dart';
import 'package:bus_tracking_app/screens/login_screen.dart';
import 'package:bus_tracking_app/screens/choice_page.dart'; // Importation de choice_page.dart
import 'package:bus_tracking_app/screens/splash_page.dart';
import 'package:bus_tracking_app/themeProvider/theme_provider.dart';
import 'package:flutter/material.dart';

void main() {
  debugPrint = (String? message, {int? wrapWidth}) {};
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Définition de la page d'accueil
    );
  }
}
