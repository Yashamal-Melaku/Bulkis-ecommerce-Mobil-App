// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blue,
    primarySwatch: Colors.green,
    // canvasColor: Colors.red,

    ////////////////////////////////////////////////
    inputDecorationTheme: InputDecorationTheme(
        // border: outlineInputBorder,
        // errorBorder: outlineInputBorder,
        // enabledBorder: outlineInputBorder,
        // focusedBorder: outlineInputBorder,
        // disabledBorder: outlineInputBorder,
        prefixIconColor: Colors.blue,
        suffixIconColor: Colors.green,
        fillColor: Colors.white,
        filled: true),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        disabledForegroundColor: Colors.blue.shade100,
        disabledBackgroundColor: Colors.grey, // Add this line
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey, // Add this line
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Regular'),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white70,
      elevation: 2,
      titleSpacing: 2,
      foregroundColor: Colors.black,
      titleTextStyle:
          TextStyle(fontSize: 22, color: Colors.black54, fontFamily: 'Regular'),
      iconTheme: IconThemeData(color: Colors.grey.shade700),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          color: Colors.grey.shade700, fontSize: 28, fontFamily: 'Regular'),
      displayMedium: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 22,
          fontWeight: FontWeight.bold),
      displaySmall: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold),
      bodyLarge:
          TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Regular'),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
    ));


// OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
//   borderSide: BorderSide(
//     color: Colors.grey,
//     //style: BorderStyle.solid,
//     width: 1,
//   ),
//   borderRadius: BorderRadius.all(Radius.circular(12.0)),
// );
