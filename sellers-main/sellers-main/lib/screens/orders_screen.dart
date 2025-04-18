import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/screens/order_list.dart';
import 'package:sellers/widgets/custom_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    Key? key,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  FirebaseFirestoreHelper _firestore = FirebaseFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text(
            'Orders',
            style: TextStyle(color: Colors.black),
          ),
          actions: const [
            // if (appProvider.getUserList.first.role == 'seller')
            //   const Expanded(
            //       child:
            //           OrderCountIndicator(title: 'All', color: Colors.black54)),
            OrderCountIndicator(title: 'pending', color: Colors.orange),
            OrderCountIndicator(title: 'delivery', color: Colors.blue),
            OrderCountIndicator(title: 'completed', color: Colors.green),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 10, color: Colors.blue)),
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              // if (appProvider.getUserList.first.role == 'seller')
              //   const Tab(
              //     child: Text('All',
              //         style: TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.normal)),
              //   ),
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
        drawer: CustomDrawer(),
        body: const TabBarView(
          children: [
            // if (appProvider.getUserList.first.role == 'seller')
            //   const OrderListView(title: 'All'),
            OrderListView(title: 'Pending'),
            OrderListView(title: 'Delivery'),
            OrderListView(title: 'Completed'),
          ],
        ),
      ),
    );
  }
}

class OrderCountIndicator extends StatefulWidget {
  final String title;
  final Color color;

  const OrderCountIndicator(
      {Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  State<OrderCountIndicator> createState() => _OrderCountIndicatorState();
}

class _OrderCountIndicatorState extends State<OrderCountIndicator> {
  FirebaseFirestoreHelper _firestore = FirebaseFirestoreHelper();
  @override
  Widget build(BuildContext context) {
    Stream<int> orderCountStream =
        _firestore.getOrderCountByStatus(widget.title);

    return StreamBuilder<int>(
      stream: orderCountStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('W...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int orderCount = snapshot.data ?? 0;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CircleAvatar(
                    backgroundColor: widget.color,
                    radius: 50,
                    child: FittedBox(
                      child: Text(
                        '$orderCount',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
