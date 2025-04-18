// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:js';

import 'package:admin/provider/app_provider.dart';
import 'package:admin/views/screens/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> refreshOrders() async {
    AppProvider appProvider = Provider.of<AppProvider>(
      context as BuildContext,
    );
    await appProvider.getCompletedOrderList();
    await appProvider.getPendingOrders();
    await appProvider.getDeliveryOrders();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 10, color: Colors.blue)),
            labelPadding: EdgeInsets.symmetric(horizontal: 100),
            tabs: [
              Tab(
                child: Text('All Orders ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
              Tab(
                child: Text('Pending',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
              Tab(
                child: Text('Delivery',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
              Tab(
                child: Text('Completed',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refreshOrders,
          child: const TabBarView(
            children: [
              OrderListView(title: 'All'),
              OrderListView(title: 'Pending'),
              OrderListView(title: 'Delivery'),
              OrderListView(title: 'Completed'),
            ],
          ),
        ),
      ),
    );
  }
}

// class OrderCountIndicator extends StatelessWidget {
//   final String title;
//   final Color color;

//   const OrderCountIndicator(
//       {Key? key, required this.title, required this.color})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     int orderCount = getOrderCount(appProvider);

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: CircleAvatar(
//               backgroundColor: color,
//               radius: 50,
//               child: FittedBox(
//                 child: Text(
//                   '$orderCount',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           // Text(
//           //   title,
//           //   style: const TextStyle(color: Colors.black),
//           // ),
//         ],
//       ),
//     );
//   }

//   int getOrderCount(AppProvider appProvider) {
//     switch (title) {
//       case 'All':
//         return appProvider.getAllOrderList.length;
//       case 'Pending':
//         return appProvider.getPendingOrderList.length;
//       case 'Completed':
//         return appProvider.getCompletedOrder.length;
//       case 'Delivery':
//         return appProvider.getDeliveryOrderList.length;
//       default:
//         return 0;
//     }
//   }
// }
