// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:sellers/constants/conformation_dialog.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/widgets/custom_drawer.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Card(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        ' Currently you have no permission \nto access the application wait until\n    Belkis Admin respond you ',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            letterSpacing: 1,
                            wordSpacing: 3),
                      ),
                    ),
                    SizedBox(height: 50),
                    CustomButton(
                      title: 'Sign out',
                      onPressed: () {
                        ConfirmationDialog.show(
                          context,
                          'Are you sure you want to sign out?',
                          ['No', 'Yes', 'Not sure'],
                          [
                            () {
                              Navigator.of(context).pop();
                            },
                            () {},
                            () {
                              // Routes.instance.push(
                              //     widget: OrderListView(title: 'pending'),
                              //     context: context);
                            }
                          ],
                          buttonTextColor: [
                            Colors.green,
                            Colors.red,
                            Colors.blue
                          ],
                          buttonBackgroundColor: [
                            Colors.white,
                            Colors.white,
                            Colors.white
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
