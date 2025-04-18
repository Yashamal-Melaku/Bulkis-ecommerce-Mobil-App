import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellers/constants/theme.dart';

class SingleDashItem extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final void Function()? onPressed;
  const SingleDashItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Card(
          elevation: 1,
          surfaceTintColor: Colors.blue,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  subtitle,
                  style: themeData.textTheme.displayMedium,
                ),
              ),
              Icon(icon),
              FittedBox(
                child: Text(
                  title,
                  style: themeData.textTheme.displayLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
