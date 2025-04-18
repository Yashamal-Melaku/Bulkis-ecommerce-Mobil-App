import 'package:buyers/screens/cart_screen.dart';
import 'package:buyers/screens/home.dart';
import 'package:buyers/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    final Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final PersistentTabController _controller = PersistentTabController();
  final bool _hideNavBar = false;

  List<Widget> _buildScreens() => [
        const Home(),
        const CartScreen(),
        const OrderScreen(),
      ];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          inactiveIcon: const Icon(Icons.home_outlined, size: 20),
          title: 'home'.tr,
          // activeColorPrimary: Theme.of(context).secondaryHeaderColor,
          //inactiveColorPrimary: Theme.of(context).canvasColor,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          inactiveIcon: const Icon(Icons.shopping_cart_outlined, size: 20),
          title: 'cart'.tr,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.circle),
          inactiveIcon: const Icon(Icons.circle_outlined, size: 20),
          title: 'orders'.tr,
        ),
      ];

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: false,
          navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
              ? 0.0
              : kBottomNavigationBarHeight,
          bottomScreenMargin: 0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          hideNavigationBar: _hideNavBar,
          decoration: const NavBarDecoration(),
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 10),
            curve: Curves.bounceIn,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
          ),
          navBarStyle: NavBarStyle.style9,
        ),
      );
}
