// CustomDrawer.dart
// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/conformation_dialog.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/models/user_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/change_password_screen.dart';
import 'package:buyers/screens/home.dart';
import 'package:buyers/screens/order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  Future<UserModel> getUserInformation(String userId) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
    } else {
      return UserModel(
        id: userId,
        name: 'Default Name',
        email: 'default@email.com',
        phoneNumber: '1234567890',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).listTileTheme;
    return Drawer(
      width: 240,
      child: Container(
        color: theme.tileColor,
        child: SingleChildScrollView(
          child: FutureBuilder<UserModel>(
            future: getUserInformation(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                UserModel userInformation = snapshot.data!;
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userInformation.image ?? ''),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.blue.shade400.withOpacity(0.9),
                      ),
                      accountName: Text(
                        userInformation.name ?? '',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(
                        userInformation.email ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userInformation.image ?? ''),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.light_mode),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('theme'.tr),
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              bool isLightModeEnabled =
                                  themeProvider.isLightModeEnabled;
                              return IconButton(
                                onPressed: () {
                                  themeProvider.toggleTheme();
                                },
                                icon: Icon(isLightModeEnabled
                                    ? Icons.dark_mode
                                    : Icons.dark_mode_outlined),
                              );
                            },
                          ),
                        ],
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: Home(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.home),
                      title: Text('home'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: OrderScreen(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.shopping_bag),
                      title: Text('orders'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: Home(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.settings),
                      title: Text('settings'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        // Handle About Us
                      },
                      leading: const Icon(Icons.info_outline),
                      title: Text('about'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        // Handle Support
                      },
                      leading: const Icon(Icons.support),
                      title: Text('support'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: ChangePasswordScreen(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.change_circle),
                      title: Text('changePassword'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        ConfirmationDialog.show(
                            context, 'Are you shur to logout', [
                          'Yes',
                          'No'
                        ], [
                          () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
                          },
                          () {
                            Navigator.pop(context);
                          }
                        ]);

                        // Close the drawer after signing out
                      },
                      leading: const Icon(Icons.logout),
                      title: Text('logout'.tr),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    const SizedBox(height: 60),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     

//     return Drawer(
//       width: 240,
//       child: Container(
//         width: 200,
//       
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(
//                         appProvider.getUserInformation.image ?? ''),
//                     fit: BoxFit.cover,
//                   ),
//                   color: Colors.blue.shade400.withOpacity(0.9),
//                 ),
//                 accountName: Text(
//                   appProvider.getUserInformation.name ?? '',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 accountEmail: Text(
//                   appProvider.getUserInformation.email ?? '',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundImage:
//                       NetworkImage(appProvider.getUserInformation.image ?? ''),
//                 ),
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






// // ignore_for_file: prefer_const_constructors

// import 'package:buyers/constants/custom_routes.dart';
// import 'package:buyers/main.dart';
// import 'package:buyers/providers/app_provider.dart';
// import 'package:buyers/providers/theme_provider.dart';
// import 'package:buyers/screens/change_password_screen.dart';
// import 'package:buyers/screens/google_map.dart';
// import 'package:buyers/screens/home.dart';
// import 'package:buyers/screens/order_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     final theme = Theme.of(context).listTileTheme;
//     return Drawer(
//       width: 240,
//       child: Container(
//         width: 200,
//         color: theme.tileColor,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(
//                         appProvider.getUserInformation.image ?? ''),
//                     fit: BoxFit.cover,
//                   ),
//                   color: Colors.blue.shade400.withOpacity(0.9),
//                 ),
//                 accountName: Text(
//                   appProvider.getUserInformation.name,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 accountEmail: Text(
//                   appProvider.getUserInformation.email,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundImage:
//                       NetworkImage(appProvider.getUserInformation.image ?? ''),
//                 ),
//               ),
              
//               ListTile(
//                 iconColor: theme.iconColor,
//                 textColor: theme.textColor,
//                 leading: const Icon(Icons.light_mode),
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('theme'.tr),
//                     Consumer<ThemeProvider>(
//                       builder: (context, themeProvider, child) {
//                         bool isLightModeEnabled =
//                             themeProvider.isLightModeEnabled;
//                         return IconButton(
//                           onPressed: () {
//                             themeProvider.toggleTheme();
//                           },
//                           icon: Icon(isLightModeEnabled
//                               ? Icons.dark_mode
//                               : Icons.dark_mode_outlined),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               ListTile(
//                 onTap: () {
//                   Routes.instance.push(
//                     widget: Home(),
//                     context: context,
//                   );
//                 },
//                 leading: const Icon(Icons.home),
//                 title: Text('home'.tr),
//               ),
//               ListTile(
//                 onTap: () {
//                   Routes.instance.push(
//                     widget: OrderScreen(),
//                     context: context,
//                   );
//                 },
//                 leading: const Icon(Icons.shopping_bag),
//                 title: Text('orders'.tr),
//               ),
//               ListTile(
//                 onTap: () {
//                   Routes.instance.push(
//                     widget: Home(),
//                     context: context,
//                   );
//                 },
//                 leading: const Icon(Icons.settings),
//                 title: Text('settings'.tr),
//               ),
//               ListTile(
//                 onTap: () {
//                   // Handle About Us
//                 },
//                 leading: const Icon(Icons.info_outline),
//                 title: Text('about'.tr),
//               ),
//               ListTile(
//                 onTap: () {
//                   // Handle Support
//                 },
//                 leading: const Icon(Icons.support),
//                 title: Text('support'.tr),
//               ),
//               ListTile(
//                 onTap: () {
//                   Routes.instance.push(
//                     widget: ChangePasswordScreen(),
//                     context: context,
//                   );
//                 },
//                 leading: const Icon(Icons.change_circle),
//                 title: Text('changePassword'.tr),
//               ),
//               ListTile(
//                 onTap: () {
//                   FirebaseAuth.instance.signOut();
//                   Navigator.pop(context); // Close the drawer after signing out
//                 },
//                 leading: const Icon(Icons.logout),
//                 title: Text('logout'.tr),
//               ),
//               //Spacer(),
//               // const Text('Version 1.0.0'),
//               const SizedBox(height: 60),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'package:buyers/constants/primary_button.dart';
// import 'package:buyers/constants/routes.dart';
// import 'package:buyers/providers/app_provider.dart';
// import 'package:buyers/screens/change_password_screen.dart';
// import 'package:buyers/screens/edit_profile_screen.dart';
// import 'package:buyers/screens/favorite_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen> {
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         title: const Text('My profile'),
//         actions: const [
//           Icon(Icons.person),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: Container(
//             padding: const EdgeInsets.all(20),
//             color: Colors.white,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(children: [
//                 appProvider.getUserInformation.image == null
//                     ? const Icon(
//                         Icons.person_outline,
//                         size: 100,
//                       )
//                     : CircleAvatar(
//                         radius: 50,
//                         backgroundImage:
//                             NetworkImage(appProvider.getUserInformation.image!),
//                       ),
//                 Text(
//                   appProvider.getUserInformation.name,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   appProvider.getUserInformation.email,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   height: 50,
//                   width: 160,
//                   child: PrimaryButton(
//                     title: 'Edit Profile',
//                     onPressed: () {
//                       Routes.instance
//                           .push(widget: const EditProfile(), context: context);
//                     },
//                   ),
//                 )
//               ]),
//             ),
//           )),
//           Expanded(
//             flex: 2,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       Routes.instance.push(
//                           widget: const ChangePasswordScreen(),
//                           context: context);
//                     },
//                     leading: const Icon(Icons.shopping_bag),
//                     title: const Text('Your orders'),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Routes.instance.push(
//                           widget: const FavoriteScreen(), context: context);
//                     },
//                     leading: const Icon(Icons.favorite_border),
//                     title: const Text('Favorites'),
//                   ),
//                   ListTile(
//                     onTap: () {},
//                     leading: const Icon(Icons.info_outline),
//                     title: const Text('About us'),
//                   ),
//                   ListTile(
//                     onTap: () {},
//                     leading: const Icon(Icons.support),
//                     title: const Text('Support'),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Routes.instance.push(
//                           widget: const ChangePasswordScreen(),
//                           context: context);
//                     },
//                     leading: const Icon(Icons.change_circle),
//                     title: const Text('Change password'),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       FirebaseAuth.instance.signOut();
//                       setState(() {});
//                     },
//                     leading: const Icon(Icons.logout),
//                     title: const Text('Logout'),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text('Version 1.0.0'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
