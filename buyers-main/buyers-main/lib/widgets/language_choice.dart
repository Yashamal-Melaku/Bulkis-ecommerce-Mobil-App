import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageDialog extends StatefulWidget {
  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateLanguage(Locale local) {
    Get.back();
    Get.updateLocale(local);
  }

  final List<Map<String, Object>> locales = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'አማርኛ', 'locale': const Locale('am', 'ET')},
    {'name': 'Afaan Oromo', 'locale': const Locale('om', 'ET')},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          text(title: 'Welcome to Belkis online market ', size: 24),
          Image.asset('assets/images/belkis4.jpg',
              height: 300, width: screenWidth),
          Row(
            children: [
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: const Offset(1, 0),
                  ).animate(_controller),
                  child: Image.asset('assets/images/aaa.png', height: 150),
                ),
              ),
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: const Offset(1, 0),
                  ).animate(_controller),
                  child:
                      Image.asset('assets/images/shopMouse.jpg', height: 150),
                ),
              ),
            ],
          ),
          text(title: 'Select Language', size: 30, color: Colors.black),
          ...locales.map((locale) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Card(
                  child: Text(
                    locale['name'] as String,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () {
                updateLanguage(locale['locale'] as Locale);
                Routes.instance.push(widget: const Welcome(), context: context);
              },
            );
          }).toList(),
          text(title: 'You can change it later on the home page')
        ],
      ),
    );
  }
}
