// ignore_for_file: prefer_const_constructors

import 'package:admin/constants/theme.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/provider/app_provider.dart';

import 'package:admin/views/screens/dashboard_screen.dart';
import 'package:admin/views/widgets/custom_side_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard',
        theme: themeData,
        home: Builder(
          builder: (context) {
            return Scaffold(
              key: _key,
              appBar: AppBar(
                backgroundColor: Colors.green.shade300,
                automaticallyImplyLeading: false,
                title: Text(getTitleByIndex(_controller.selectedIndex)),
              ),
              drawer: CustomeSideBar(controller: _controller),
              body: Expanded(
                child: Row(
                  children: [
                    CustomeSideBar(controller: _controller),
                    Expanded(
                      child: Column(
                        children: [
                          _controller == 0 ? SizedBox.fromSize() : Dashboard(),
                          Expanded(
                            child: MainScreens(
                              controller: _controller,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}






// // class SideMenu extends StatefulWidget {
// //   static const String id = 'side-menu';
// //   const SideMenu({Key? key}) : super(key: key);

// //   @override
// //   State<SideMenu> createState() => _SideMenuState();
// // }

// // class _SideMenuState extends State<SideMenu> {
// //   Widget _selectedScreen = const HomePage();

// //   screenSelector(item) {
// //     switch (item.route) {
// //       case HomePage.id:
// //         setState(() {
// //           _selectedScreen = const HomePage();
// //         });
// //         break;
// //       case CategoryViewScreen.id:
// //         setState(() {
// //           _selectedScreen = const CategoryViewScreen();
// //         });
// //         break;
// //       case OrderListView.id:
// //         setState(() {
// //           _selectedScreen = const OrderListView(
// //             title: 'Completed',
// //           );
// //         });
// //         break;
// //       case ProductView.id:
// //         setState(() {
// //           _selectedScreen = const ProductView();
// //         });
// //         break;
// //       case UserViewScreen.id:
// //         setState(() {
// //           _selectedScreen = const UserViewScreen();
// //         });
// //         break;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AdminScaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: const Text(
// //           'Shop App Admin',
// //           style: TextStyle(letterSpacing: 1),
// //         ),
// //       ),
// //       sideBar: SideBar(
// //         items: const [
// //           AdminMenuItem(
// //             title: 'Home',
// //             route: HomePage.id,
// //             icon: Icons.dashboard_rounded,
// //           ),
// //           AdminMenuItem(
// //             title: 'Categories',
// //             route: CategoryViewScreen.id,
// //             icon: Icons.dashboard_rounded,
// //           ),
// //           AdminMenuItem(
// //             title: 'Order Lists',
// //             icon: Icons.category,
// //             children: [
// //               AdminMenuItem(
// //                 title: 'Completed Order',
// //                 route: OrderListView.id,
// //               ),
// //               AdminMenuItem(
// //                 title: 'pending order',
// //                 route: ProductView.id,
// //               ),
// //               AdminMenuItem(
// //                 title: 'Delivery',
// //                 route: UserViewScreen.id,
// //               ),
// //             ],
// //           ),
// //         ],
// //         selectedRoute: SideMenu.id,
// //         onSelected: (item) {
// //           screenSelector(item);
// //         },
// //         header: Container(
// //           height: 50,
// //           width: double.infinity,
// //           color: const Color(0xff444444),
// //           child: const Center(
// //             child: Text(
// //               'Menu',
// //               style: TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ),
// //         footer: Container(
// //           height: 50,
// //           width: double.infinity,
// //           color: const Color(0xff444444),
// //           child: Center(
// //             child: Text(
// //               DateTimeFormat.format(DateTime.now(),
// //                   format: AmericanDateFormats.dayOfWeek),
// //               style: const TextStyle(
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: _selectedScreen,
// //       ),
// //     );
// //   }
// // }

