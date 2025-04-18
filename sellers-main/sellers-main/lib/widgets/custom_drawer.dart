// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/screens/change_password_screen.dart';
import 'package:sellers/screens/favorite_screen.dart';
import 'package:sellers/screens/home.dart';
import 'package:sellers/screens/orders_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Drawer(
      width: 240,
      child: Container(
        width: 200,
        color: Colors.white30.withOpacity(0.9),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(appProvider.getUserList.isNotEmpty
                        ? appProvider.getUserList.first.idCard ?? ''
                        : ''),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.deepOrange.shade400.withOpacity(0.9),
                ),
                accountName: Text(
                  appProvider.getUserList.isNotEmpty
                      ? appProvider.getUserList.first.firstName ?? ''
                      : '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  appProvider.getUserList.isNotEmpty
                      ? appProvider.getUserList.first.email ?? ''
                      : '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      appProvider.getUserList.isNotEmpty
                          ? appProvider.getUserList.first.idCard ?? ''
                          : ''),
                ),
              ),

              ListTile(
                onTap: () {
                  Routes.instance.push(
                    widget: HomePage(),
                    context: context,
                  );
                },
                leading: const Icon(Icons.home),
                title: const Text('Home'),
              ),
              ListTile(
                onTap: () {
                  Routes.instance.push(
                    widget: OrdersScreen(),
                    context: context,
                  );
                },
                leading: const Icon(Icons.shopping_bag),
                title: const Text('Orders'),
              ),
              ListTile(
                onTap: () {
                  Routes.instance.push(
                    widget: FavoriteScreen(),
                    context: context,
                  );
                },
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
              ),
              ListTile(
                onTap: () {
                  // Handle About Us
                },
                leading: const Icon(Icons.info_outline),
                title: const Text('About us'),
              ),
              ListTile(
                onTap: () {
                  // Handle Support
                },
                leading: const Icon(Icons.support),
                title: const Text('Support'),
              ),
              ListTile(
                onTap: () {
                  Routes.instance.push(
                    widget: ChangePasswordScreen(),
                    context: context,
                  );
                },
                leading: const Icon(Icons.change_circle),
                title: const Text('Change password'),
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  // Close the drawer after signing out
                },
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
              ),
              //Spacer(),
              // const Text('Version 1.0.0'),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
