import 'package:flutter/material.dart';
import 'constants.dart';

class MyTheme {

  static ThemeData themeData = ThemeData(
    primarySwatch: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,

    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: kSecondaryColor,
        fontFamily: 'Noopla'
      ),
      bodySmall: TextStyle(
        color: kSecondaryColor,
        fontFamily: 'Noopla',
        fontSize: 10
      ),
      bodyMedium: TextStyle(
        color: kPrimaryColor,
        fontFamily: 'Noopla',
        // fontSize: 10
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'Noopla',
        fontSize: 18,
      ),
      titleLarge: TextStyle(
        color: kPrimaryColor,
        fontFamily: 'Noopla',
        fontSize: 18,
      ),
      headlineLarge: TextStyle(
          color: kPrimaryColor,
          fontFamily: 'Noopla',
          fontWeight: FontWeight.w400),
    ),
  );
}
