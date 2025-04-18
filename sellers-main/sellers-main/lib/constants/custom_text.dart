import 'package:flutter/material.dart';

Widget text({
  BuildContext? context,
  String? title,
  double? size,
  Color? color,
  FontWeight? fontWeight,
}) {
  return Text(
    title!,
    style: TextStyle(
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: size ?? 14,
    ),
  );
}
