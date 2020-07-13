import 'package:flutter/material.dart';

class ThemeDataUtil {
  static ThemeData themeDefault() {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 32, 57, 204),
        fontFamily: "Red Hat Display",
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: TextTheme(
            bodyText1: TextStyle(color: Color.fromARGB(255, 30, 30, 30))));
  }

  static ThemeData themeDark() {
    return ThemeData(
        fontFamily: "Red Hat Display",
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 103, 125, 255),
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        cardColor: Color.fromARGB(255, 39, 39, 39),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 103, 125, 255)),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)));
  }
}
