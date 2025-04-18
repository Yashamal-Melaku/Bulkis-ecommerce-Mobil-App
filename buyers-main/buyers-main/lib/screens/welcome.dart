import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/screens/home.dart';
import 'package:buyers/screens/login.dart';
import 'package:buyers/screens/sign_up.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:buyers/widgets/language_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //  backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                  child:
                      text(title: 'welcome'.tr, size: 40, color: Colors.blue)),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/belkis3.jpg',
                  ),
                ),
              ),
              SizedBox(height: 50),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CustomButton(
                          title: 'signin'.tr,
                          color: Colors.green,
                          onPressed: () {
                            Routes.instance
                                .push(widget: const Login(), context: context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CustomButton(
                          title: 'signup'.tr,
                          color: Colors.blue,
                          onPressed: () {
                            Routes.instance
                                .push(widget: const SignUp(), context: context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              text(
                title: 'OR',
                size: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                      onPressed: () {
                        Routes.instance
                            .push(widget: CustomBottomBar(), context: context);
                      },
                      child: text(
                          title: 'continueAs'.tr, color: Colors.blue, size: 24))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
