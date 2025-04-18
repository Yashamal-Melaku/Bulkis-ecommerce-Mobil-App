// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/models/order_model.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/widgets/custom_drawer.dart';
import 'package:sellers/widgets/single_dash_item.dart';

class DeliveryHomeScreen extends StatefulWidget {
  static const String id = 'home-page';

  const DeliveryHomeScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
  bool isLoading = false;

  void getData() async {
    setState(() {
      isLoading = true;
    });

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.callBackFunction();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> _showUserInfoDialog({
    BuildContext? context,
    IconData? icon,
    String? title,
    String? subtitle,
  }) async {
    return showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(icon),
              Text('Total No of $title'),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle!),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget productStreamBuilder(
    IconData icon,
    String title,
  ) {
    return FutureBuilder<List<ProductModel>>(
      future: _firestoreHelper.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<ProductModel> productList = snapshot.data!;

          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: productList.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: productList.length.toString(),
          );
        }
      },
    );
  }

  Widget ordersStreamBuilder(
    IconData icon,
    String title,
    String status,
  ) {
    return StreamBuilder<List<OrderModel>>(
      stream: status.isEmpty
          ? _firestoreHelper.getOrderListStream()
          : _firestoreHelper.getOrderListStream(status: status),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleDashItem(
            onPressed: () {
              _showUserInfoDialog(
                context: context,
                icon: icon,
                title: title,
                subtitle: snapshot.data!.length.toString(),
              );
            },
            icon: icon,
            title: title,
            subtitle: snapshot.data!.length.toString(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Divider(),
                      GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.only(top: 20),
                        crossAxisCount: 2,
                        children: [
                          ordersStreamBuilder(Icons.pending, 'Orders', ''),
                          ordersStreamBuilder(
                              Icons.pending, 'Pending orders', 'pending'),
                          ordersStreamBuilder(
                              Icons.disc_full, 'Completed orders', 'completed'),
                          ordersStreamBuilder(Icons.delivery_dining,
                              'Delivery orders', 'delivery'),
                          Spacer(),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
