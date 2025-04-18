// ignore_for_file: prefer_const_constructors

import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/firebase_options.dart';
import 'package:buyers/local_strings.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/welcome.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:buyers/widgets/language_choice.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Chapa.configure(privateKey: "CHASECK_TEST-w6sbpyY5ffpNwyQEftmEzhuL7RHj0f9d");
  // Stripe.publishableKey =
  //     'pk_test_51OFnrbL5s11I9QDMOFtPyDVhgwlglgvExwrsPoeZwvmFJa3hv6kdqMY06muBIWP3OgnqOGeQpMwmzOocYcWECL8k00hpdzUzvM';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: LocalStrings(),
        locale: Locale('en', 'US'),
        title: 'Belkis ',
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomBottomBar();
              } else {
                return  LanguageDialog();
              }
            }),
      ),
    );
  }
}
