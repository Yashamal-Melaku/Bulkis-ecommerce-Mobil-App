// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String? title; // Set the default title here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('Home'),
    ));
  }
}
