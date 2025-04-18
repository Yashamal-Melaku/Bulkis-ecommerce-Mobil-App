import 'package:flutter/material.dart';

Widget text({
  BuildContext? context,
  String? title,
  double? size,
  Color? color,
  FontWeight? fontWeight,
  TextOverflow? overflow, // Corrected to TextOverflow
}) {
  return FittedBox(
    child: Text(
      title!,
      style: TextStyle(
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: size ?? 14,
      ),
      overflow: overflow ??
          TextOverflow.ellipsis, // Set a default value if not provided
    ),
  );
}
