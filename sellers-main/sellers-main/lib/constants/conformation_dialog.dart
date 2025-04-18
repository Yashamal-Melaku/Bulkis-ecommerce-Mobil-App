import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<void> show(
    BuildContext context,
    String title,
    List<String> buttonTitles,
    List<Function()> buttonActions, {
    List<Color?>? buttonTextColor,
    List<Color?>? buttonBackgroundColor,
  }) async {
    assert(buttonTitles.length == buttonActions.length,
        "Button titles and actions must have the same length.");

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          actions: List<Widget>.generate(buttonTitles.length, (index) {
            return TextButton(
              onPressed: () {
                buttonActions[index].call();
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    buttonTextColor != null ? buttonTextColor[index] : null,
                backgroundColor: buttonBackgroundColor != null
                    ? buttonBackgroundColor[index]
                    : null,
              ),
              child: Text(buttonTitles[index]),
            );
          }),
        );
      },
    );
  }
  
}
