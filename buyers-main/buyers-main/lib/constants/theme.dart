// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade400,
    foregroundColor: Colors.black,
  ),
  cardColor: Colors.white,
  scaffoldBackgroundColor: Colors.grey.shade50,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  dividerTheme: DividerThemeData(color: Colors.grey.shade300),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade400, foregroundColor: Colors.white),
  ),
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade600),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.grey,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Colors.blue,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade700,
    contentTextStyle: TextStyle(color: Colors.white),
    actionTextColor: Colors.blue,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.blue,
    unselectedLabelColor: Colors.grey,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: BorderSide(color: Colors.blue),
    ),
  ),
  dialogBackgroundColor: Colors.white,
  badgeTheme: BadgeThemeData(
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  ),
  bannerTheme: MaterialBannerThemeData(
    backgroundColor: Colors.blue,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  buttonBarTheme: ButtonBarThemeData(
    alignment: MainAxisAlignment.start,
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Colors.blue,
    selectedColor: Colors.white,
    fillColor: Colors.blue,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue,
    selectionColor: Colors.blue.withOpacity(0.5),
    selectionHandleColor: Colors.blue,
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.white,
    hourMinuteColor: Colors.black,
    dayPeriodColor: Colors.black,
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.black,
    ),
    textStyle: TextStyle(color: Colors.white),
  ),
  dataTableTheme: DataTableThemeData(
    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
    dataRowColor:
        MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    selectedTileColor: Colors.blue.withOpacity(0.2),
    iconColor: Colors.blue.shade700,
    textColor: Colors.black,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade50,
    primary: Colors.white70,
    secondary: Colors.grey.shade700,
  ).copyWith(background: Colors.grey.shade50),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade700,
    foregroundColor: Colors.white,
  ),
  cardColor: Colors.grey.shade700,
  scaffoldBackgroundColor: Colors.grey.shade800,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  dividerTheme: DividerThemeData(color: Colors.grey.shade600),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade300,
      foregroundColor: Colors.white,
    ),
  ),
  // ignore: deprecated_member_use
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade600),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey.shade800,
  ),

  popupMenuTheme: PopupMenuThemeData(
    color: Colors.grey.shade800,
  ),
  dropdownMenuTheme: DropdownMenuThemeData(),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.grey.shade900,
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade700,
    contentTextStyle: TextStyle(color: Colors.white),
    actionTextColor: Colors.blue,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.blue,
    unselectedLabelColor: Colors.grey,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: BorderSide(color: Colors.blue),
    ),
  ),
  dialogBackgroundColor: Colors.grey.shade800,
  badgeTheme: BadgeThemeData(
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  ),
  bannerTheme: MaterialBannerThemeData(
    backgroundColor: Colors.blue,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  buttonBarTheme: ButtonBarThemeData(
    alignment: MainAxisAlignment.start,
  ),

  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Colors.blue,
    selectedColor: Colors.white,
    fillColor: Colors.blue,
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue,
    selectionColor: Colors.blue.withOpacity(0.5),
    selectionHandleColor: Colors.blue,
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: Colors.grey.shade800,
    hourMinuteColor: Colors.white,
    dayPeriodColor: Colors.white,
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    textStyle: TextStyle(color: Colors.black),
  ),
  dataTableTheme: DataTableThemeData(
    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
    dataRowColor:
        MaterialStateColor.resolveWith((states) => Colors.grey.shade700),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.grey.shade800,
    selectedTileColor: Colors.blue.withOpacity(0.2),
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800,
    primary: Colors.grey.shade700,
    secondary: Colors.grey.shade200,
  ).copyWith(background: Colors.grey.shade800),
);
