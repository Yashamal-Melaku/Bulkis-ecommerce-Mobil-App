// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void customSnackbar(
    {BuildContext? context,
    Color? backgroundColor,
    color,
    String? message,
    String? label,
    double? margin,
    Padding? padding}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    backgroundColor: backgroundColor ?? Colors.black54,
    closeIconColor: color ?? Colors.white,
    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: margin!, vertical: margin!),
    content: Text(message!),
    duration: Duration(seconds: 5),
    action: SnackBarAction(
        label: label ?? 'Ok',
        onPressed: () {
          Navigator.of(context).pop();
        }),
  ));
}
