// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void customSnackbar(
    {BuildContext? context,
    Color? backgroundColor,
    messageColor,
    closTextColor,
    String? message,
    closLabel,
    Duration? duration,
    String? label,
    double? margin}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    backgroundColor: backgroundColor ?? Colors.red,
    closeIconColor: messageColor ?? Colors.white,

    // showCloseIcon: true,

    dismissDirection: DismissDirection.horizontal,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(margin ?? 25),
    content: Text(message ?? ''),
    duration: duration ?? Duration(seconds: 5),
    action: SnackBarAction(
        label: closLabel ?? 'Ok',
        textColor: closTextColor ?? Colors.white,
        backgroundColor: backgroundColor ?? Colors.red,
        onPressed: () {}),
  ));
}
