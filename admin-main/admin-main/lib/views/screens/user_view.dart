// ignore_for_file: unused_import

import 'package:admin/models/user_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserViewScreen extends StatelessWidget {
  static const String id = 'user-view-screen';
  const UserViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Consumer<AppProvider>(builder: (context, value, child) {
        return ListView.builder(
            itemCount: value.getUserList.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              // UserModel userModel = value.getUserList[index];
              // return SingleUserCard(
              //   index: index,
              //   userModel: userModel,
              // );
            });
      }),
    );
  }
}
