import 'package:flutter/material.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/screens/login.dart';
import 'package:sellers/screens/sign_up.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/belkis3.jpg',
                  scale: 1,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: 'Sign In',
                onPressed: () {
                  Routes.instance.push(widget: const Login(), context: context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                title: 'Sign Up',
                onPressed: () {
                  Routes.instance
                      .push(widget: const SignUp(), context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
