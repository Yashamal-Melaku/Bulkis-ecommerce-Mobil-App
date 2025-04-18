import 'package:flutter/material.dart';

class TryView extends StatelessWidget {
  static const String id = 'try-view';
  const TryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Triying ',
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}
