// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:admin/controllers/firebase_firestore_helper.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListView extends StatefulWidget {
  final String title;

  const OrderListView({Key? key, required this.title}) : super(key: key);

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  FirebaseFirestoreHelper _firestore = FirebaseFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Stream<List<OrderModel>> ordersStream = getOrderStream(appProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StreamBuilder<List<OrderModel>>(
              stream: ordersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<OrderModel> orders = snapshot.data ?? [];
                  return DataTable(
                    headingRowColor:
                        MaterialStateColor.resolveWith((states) => Colors.grey),
                    showCheckboxColumn: false,
                    columnSpacing: 180,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          ' Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Quantity',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total(ETB)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: orders.map((order) {
                      List<DataCell> cells = [
                        DataCell(
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.network(
                              order.products[0].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            order.products[0].name,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (order.products.length > 1)
                          DataCell(
                            IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 60,
                              ),
                              onPressed: () {
                                ShowBottomSheet(context, order);
                              },
                            ),
                          )
                        else
                          DataCell(
                            Text(
                              order.products[0].quantity.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        DataCell(
                          Text(
                            order.totalprice.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            order.status,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: orderStatusColor(order.status),
                            ),
                          ),
                        ),
                      ];

                      return DataRow(
                        color: MaterialStateColor.resolveWith((states) =>
                            orders.indexOf(order) % 2 == 0
                                ? Colors.grey.shade300
                                : Colors.white),
                        cells: cells,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  PersistentBottomSheetController<dynamic> ShowBottomSheet(
      BuildContext context, OrderModel order) {
    return showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(2),
                bottom: Radius.circular(3),
              ),
              border: Border.all(color: Colors.white)),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            'Details',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        color: Colors.red,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'X',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.grey.shade300,
                    ),
                    columns: [
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Total(ETB)')),
                    ],
                    rows: order.products.map((singleProduct) {
                      return DataRow(cells: [
                        DataCell(
                          Container(
                            height: 30,
                            width: 30,
                            color: Colors.grey.shade400,
                            child: Image.network(
                              singleProduct.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            singleProduct.name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            singleProduct.quantity.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        DataCell(
                          FittedBox(
                            child: Text(
                              singleProduct.price.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Stream<List<OrderModel>> getOrderStream(AppProvider appProvider) {
    if (widget.title == 'All') {
      return _firestore.getOrderListStream();
    } else if (widget.title == 'Pending') {
      return _firestore.getOrderListStream(status: 'pending');
    } else if (widget.title == 'Completed') {
      return _firestore.getOrderListStream(status: 'completed');
    } else if (widget.title == 'Delivery') {
      return _firestore.getOrderListStream(status: 'delivery');
    } else {
      return Stream.value([]);
    }
  }

  Color orderStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.yellow.shade900;
      case 'completed':
        return Colors.green;
      case 'delivery':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
