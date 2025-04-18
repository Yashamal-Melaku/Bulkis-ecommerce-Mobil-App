
import 'package:admin/views/screens/category_view.dart';
import 'package:admin/views/screens/delivery_mans.dart';
import 'package:admin/views/screens/home_page.dart';
import 'package:admin/views/screens/orders_screen.dart';
import 'package:admin/views/screens/product_view.dart';
import 'package:admin/views/screens/sellers_view.dart';
import 'package:admin/views/screens/user_view.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomeSideBar extends StatefulWidget {
  const CustomeSideBar({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  State<CustomeSideBar> createState() => _CustomeSideBarState();
}

class _CustomeSideBarState extends State<CustomeSideBar> {
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.black,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/belkis1.jpg',
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              Text(
                'Admin Name',
                style: TextStyle(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
              Text(
                'Admin@gmail.com                ',
                style: TextStyle(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        );
      },
      items: const [
        SidebarXItem(label: "Dashboard", icon: Icons.home),
        SidebarXItem(label: "Categories", icon: Icons.category),
        SidebarXItem(label: "Products", icon: Icons.shop_2),
        SidebarXItem(label: "Sellers", icon: Icons.group),
        SidebarXItem(label: "Delivery", icon: Icons.delivery_dining),
        SidebarXItem(label: "Customers", icon: Icons.person),
        SidebarXItem(label: "Orders", icon: Icons.circle),
        SidebarXItem(label: "Logout", icon: Icons.logout),
      ],
    );
  }
}

class MainScreens extends StatelessWidget {
  const MainScreens({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          // final pageTitle = _getTitleByIndex(controller.selectedIndex);
          switch (controller.selectedIndex) {
            case 0:
              return HomePageScreen();
            case 1:
              return CategoryScreen();
            case 2:
              return ProductView();
            case 3:
              return SellersView();
            case 4:
              return DeliveryMansView();
            case 5:
              return UserViewScreen();
            case 6:
              return OrdersScreen();
              
            default:
              return Container();
          }
        });
  }
}

String getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Dashboard';
    case 1:
      return 'Categories';
    case 2:
      return 'Products';
    case 3:
      return 'Sellers';
    case 4:
      return 'Delivery';
    case 5:
      return 'Customers';
    case 6:
      return 'Orders';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
