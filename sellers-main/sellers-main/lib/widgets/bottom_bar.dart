// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sellers/controllers/firebase_auth_helper.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/delivery/delivery_home.dart';
import 'package:sellers/models/employee_model.dart';
import 'package:sellers/screens/home.dart';
import 'package:sellers/screens/landing_screen.dart';
import 'package:sellers/screens/login.dart';
import 'package:sellers/screens/orders_screen.dart';
import 'package:sellers/screens/product_view.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    final Key? key,
  }) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  final FirebaseFirestoreHelper _firestore = FirebaseFirestoreHelper();
  final PersistentTabController _controller = PersistentTabController();
  final bool _hideNavBar = false;

  List<Widget> _buildScreens() => [
        _getHomeScreen(),
        ProductView(),
        OrdersScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          inactiveIcon: const Icon(Icons.home_outlined, size: 20),
          title: 'Home',
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.deepOrange,
          inactiveColorSecondary: Colors.purple,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shop_rounded),
          inactiveIcon: const Icon(Icons.shop_outlined, size: 20),
          title: 'Products',
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.deepOrange,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.circle),
          inactiveIcon: const Icon(Icons.circle_outlined, size: 20),
          title: 'Orders',
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.deepOrange,
        ),
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 0,
          backgroundColor: Colors.white,
          hideNavigationBar: _hideNavBar,
          decoration: const NavBarDecoration(colorBehindNavBar: Colors.white),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 0),
            // curve: Curves.linear,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: false,
          ),
          navBarStyle: NavBarStyle.style9,
          resizeToAvoidBottomInset: true,
        ),
      );

//   Widget _getHomeScreen() {
//     return StreamBuilder<EmployeeModel>(
//       stream: _firestore.getSellersInfo(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           EmployeeModel? employee = snapshot.data;
//           print('Seller: $employee');
//           print(FirebaseAuth.instance.currentUser!.uid);

//           if (employee != null) {
//             print('Role: ${employee.role}, Approved: ${employee.approved}');

//             if (employee.approved == true) {
//               if (employee.role == 'delivery') {
//                 return DeliveryHomeScreen();
//               } else if (employee.role == 'seller') {
//                 return HomePage();
//               } else {
//                 return Login();
//               }
//             } else {
//               // Handle the case where the user is not approved
//               return LandingScreen();
//             }
//           } else {
//             // Handle the case where the user data is not available
//             return Login();
//           }
//         }
//       },
//     );
//   }
// }

  Widget _getHomeScreen() {
    return StreamBuilder<EmployeeModel>(
      stream: _firestore.getEmployeeInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          EmployeeModel? employee = snapshot.data;
          print('Seller: $employee');
          print(FirebaseAuth.instance.currentUser!.uid);

          if (employee != null) {
            print('Role: ${employee.role}, Approved: ${employee.approved}');

            if (employee.role == 'delivery' && employee.approved == true) {
              return DeliveryHomeScreen();
            } else if (employee.role == 'seller' && employee.approved == true) {
              return HomePage();
            } else {
              return LandingScreen();
            }
          } else {
            return Login();
          }
        }
      },
    );
  }
}
