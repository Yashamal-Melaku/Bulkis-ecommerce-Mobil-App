// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/constants/custom_text.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/delivery/google_map.dart';
import 'package:sellers/models/order_model.dart';

class OrderListView extends StatefulWidget {
  final String title;

  const OrderListView({Key? key, required this.title}) : super(key: key);

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  // final QrCodeScanner _qrScanner = QrCodeScanner();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StreamBuilder<List<OrderModel>>(
              stream: getOrderStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<OrderModel> orders = snapshot.data ?? [];
                  return DataTable(
                    headingRowColor:
                        MaterialStateColor.resolveWith((states) => Colors.grey),
                    showCheckboxColumn: false,
                    columnSpacing: 10,
                    columns: [
                      DataColumn(
                          label: text(
                              title: 'Image', color: Colors.green, size: 16)),
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
                      if (orders.first.status != 'completed')
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                    rows: orders.map((order) {
                      return DataRow(
                        color: MaterialStateColor.resolveWith((states) =>
                            orders.indexOf(order) % 2 == 0
                                ? Colors.grey.shade300
                                : Colors.white),
                        cells: [
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
                          DataCell(
                            order.products.length > 1
                                ? IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 60,
                                    ),
                                    onPressed: () {
                                      showBottomSheet(context, order);
                                    },
                                  )
                                : Text(
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
                          if (order.status != 'completed')
                            DataCell(
                              CustomButton(
                                onPressed: () {
                                  handleCompleteButtonClick(order);
                                },
                                title: getActionButtonText(
                                  order.status,
                                ),
                                color: order.status == 'pending'
                                    ? Colors.white
                                    : Colors.white,
                                width: order.status == 'pending' ? 100 : 130,
                                height: 40,
                                textStyle: TextStyle(
                                    color: order.status == 'pending'
                                        ? Colors.deepOrange
                                        : Colors.green,
                                    fontSize: 14),
                              ),
                            )
                        ],
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

  String getActionButtonText(String status) {
    switch (status) {
      case 'pending':
        return 'Accept';
      case 'delivery':
        return 'Complete';
      default:
        return '';
    }
  }

  void updateOrderStatus(OrderModel order) async {
    String newStatus;
    switch (order.status) {
      case 'pending':
        newStatus = 'delivery';
        break;
      case 'delivery':
        newStatus = 'completed';
        break;
      default:
        newStatus = order.status;
    }

    // Call the new function to update delivery order
    await updateDeliveryOrder(order, newStatus);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateDeliveryOrder(OrderModel orderModel, String status) async {
   String deliveryId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> sellerSnapshot =
          await _firestore.collection('employees').doc(deliveryId).get();

      if (sellerSnapshot.exists) {
        String deliveryName = sellerSnapshot['firstName'];
        String deliveryPhone = sellerSnapshot['phoneNumber'];
        String deliveryId = sellerSnapshot['employeeId'];
        String userIdFromDatabase = orderModel.userId;
        await _firestore
            .collection('userOrders')
            .doc(userIdFromDatabase)
            .collection('orders')
            .doc(orderModel.orderId)
            .update({
          'status': status,
          'deliveryId': deliveryId,
          'deliveryName': deliveryName,
          'deliveryPhone': deliveryPhone,
        });

        await _firestore.collection('orders').doc(orderModel.orderId).update({
          'status': status,
          'deliveryId': deliveryId,
          'deliveryName': deliveryName,
          'deliveryPhone': deliveryPhone,
        });
      } else {
        print('Seller document does not exist.');
      }
    } catch (e) {
      print('Error updating order: $e');
      print(orderModel.orderId);
    }
  }

  Future showBottomSheet(BuildContext context, OrderModel order) {
    return showModalBottomSheet(
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
                          style: TextStyle(color: Colors.black87, fontSize: 24),
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
              DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey.shade300,
                ),
                columns: [
                  DataColumn(
                      label: text(
                          title: 'Image',
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
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
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        );
      },
    );
  }

  Stream<List<OrderModel>> getOrderStream() {
    if (widget.title == 'All') {
      var orderListStream = _firestoreHelper.getOrderListStream();
      return orderListStream;
    } else if (widget.title == 'Pending') {
      return _firestoreHelper.getOrderListStream(status: 'pending');
    } else if (widget.title == 'Completed') {
      return _firestoreHelper.getOrderListStream(status: 'completed');
    } else if (widget.title == 'Delivery') {
      return _firestoreHelper.getOrderListStream(status: 'delivery');
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
        return Colors.black38;
    }
  }

  void handleCompleteButtonClick(OrderModel order) async {
    if (order.status == 'delivery') {
      Routes.instance.push(
          widget: MapScreen(
            orderId: order.orderId,
          ),
          context: context);
    } else {
      updateOrderStatus(order);
    }
  }

}




// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:sellers/constants/custom_button.dart';
// import 'package:sellers/constants/custom_text.dart';
// import 'package:sellers/constants/routes.dart';
// import 'package:sellers/controllers/firebase_firestore_helper.dart';
// import 'package:sellers/delivery/google_map.dart';
// import 'package:sellers/delivery/qr_code_scanner.dart';
// import 'package:sellers/models/order_model.dart';

// class OrderListView extends StatefulWidget {
//   final String title;

//   const OrderListView({Key? key, required this.title}) : super(key: key);

//   @override
//   State<OrderListView> createState() => _OrderListViewState();
// }

// class _OrderListViewState extends State<OrderListView> {
//   final FirebaseFirestoreHelper _firestore = FirebaseFirestoreHelper();
//   final QrCodeScanner _qrScanner = QrCodeScanner();

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: StreamBuilder<List<OrderModel>>(
//               stream: getOrderStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   List<OrderModel> orders = snapshot.data ?? [];
//                   return DataTable(
//                     headingRowColor:
//                         MaterialStateColor.resolveWith((states) => Colors.grey),
//                     showCheckboxColumn: false,
//                     columnSpacing: 10,
//                     columns: [
//                       DataColumn(
//                           label: text(
//                               title: 'Image', color: Colors.green, size: 16)),
//                       DataColumn(
//                         label: Text(
//                           ' Name',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Quantity',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Total(ETB)',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       DataColumn(
//                         label: Text(
//                           'Status',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       if (orders.first.status != 'completed')
//                         DataColumn(
//                           label: Text(
//                             'Action',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                     rows: orders.map((order) {
//                       return DataRow(
//                         color: MaterialStateColor.resolveWith((states) =>
//                             orders.indexOf(order) % 2 == 0
//                                 ? Colors.grey.shade300
//                                 : Colors.white),
//                         cells: [
//                           DataCell(
//                             SizedBox(
//                               height: 30,
//                               width: 30,
//                               child: Image.network(
//                                 order.products[0].image,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             Text(
//                               order.products[0].name,
//                               style: TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 14,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             order.products.length > 1
//                                 ? IconButton(
//                                     icon: Icon(
//                                       Icons.keyboard_arrow_down_sharp,
//                                       size: 60,
//                                     ),
//                                     onPressed: () {
//                                       showBottomSheet(context, order);
//                                     },
//                                   )
//                                 : Text(
//                                     order.products[0].quantity.toString(),
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                           ),
//                           DataCell(
//                             Text(
//                               order.totalprice.toString(),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           DataCell(
//                             Text(
//                               order.status,
//                               style: TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: orderStatusColor(order.status),
//                               ),
//                             ),
//                           ),
//                           if (order.status != 'completed')
//                             DataCell(
//                               CustomButton(
//                                 onPressed: () {
//                                   handleCompleteButtonClick(order);
//                                 },
//                                 title: getActionButtonText(
//                                   order.status,
//                                 ),
//                                 color: order.status == 'pending'
//                                     ? Colors.white
//                                     : Colors.white,
//                                 width: order.status == 'pending' ? 100 : 130,
//                                 height: 40,
//                                 textStyle: TextStyle(
//                                     color: order.status == 'pending'
//                                         ? Colors.deepOrange
//                                         : Colors.green,
//                                     fontSize: 14),
//                               ),
//                             )
//                         ],
//                       );
//                     }).toList(),
//                   );
//                 }
//               },
//             ),
//           ),
//           SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   String getActionButtonText(String status) {
//     switch (status) {
//       case 'pending':
//         return 'Accept';
//       case 'delivery':
//         return 'Complete';
//       default:
//         return '';
//     }
//   }

//   void updateOrderStatus(OrderModel order) async {
//     String newStatus;
//     switch (order.status) {
//       case 'pending':
//         newStatus = 'delivery';
//         break;
//       case 'delivery':
//         newStatus = 'completed';
//         break;
//       default:
//         newStatus = order.status;
//     }

//     try {
//       await _firestore.updateOrder(order, newStatus);
//     } catch (e) {
//       print('Error updating order status: $e');
//     }
//   }

//   Future showBottomSheet(BuildContext context, OrderModel order) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(2),
//                 bottom: Radius.circular(3),
//               ),
//               border: Border.all(color: Colors.white)),
//           padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                         child: Text(
//                           'Details',
//                           style: TextStyle(color: Colors.black87, fontSize: 24),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 40,
//                       color: Colors.red,
//                       child: TextButton(
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                         ),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           'X',
//                           style: TextStyle(color: Colors.white, fontSize: 30),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith(
//                   (states) => Colors.grey.shade300,
//                 ),
//                 columns: [
//                   DataColumn(
//                       label: text(
//                           title: 'Image',
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold)),
//                   DataColumn(label: Text('Name')),
//                   DataColumn(label: Text('Quantity')),
//                   DataColumn(label: Text('Total(ETB)')),
//                 ],
//                 rows: order.products.map((singleProduct) {
//                   return DataRow(cells: [
//                     DataCell(
//                       Container(
//                         height: 30,
//                         width: 30,
//                         color: Colors.grey.shade400,
//                         child: Image.network(
//                           singleProduct.image,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Text(
//                         singleProduct.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Text(
//                         singleProduct.quantity.toString(),
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                     DataCell(
//                       FittedBox(
//                         child: Text(
//                           singleProduct.price.toString(),
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ),
//                   ]);
//                 }).toList(),
//               ),
//               Divider(
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Stream<List<OrderModel>> getOrderStream() {
//     if (widget.title == 'All') {
//       var orderListStream = _firestore.getOrderListStream();
//       return orderListStream;
//     } else if (widget.title == 'Pending') {
//       return _firestore.getOrderListStream(status: 'pending');
//     } else if (widget.title == 'Completed') {
//       return _firestore.getOrderListStream(status: 'completed');
//     } else if (widget.title == 'Delivery') {
//       return _firestore.getOrderListStream(status: 'delivery');
//     } else {
//       return Stream.value([]);
//     }
//   }

//   Color orderStatusColor(String status) {
//     switch (status) {
//       case 'pending':
//         return Colors.yellow.shade900;
//       case 'completed':
//         return Colors.green;
//       case 'delivery':
//         return Colors.blue;
//       default:
//         return Colors.black38;
//     }
//   }

//   void handleCompleteButtonClick(OrderModel order) async {
//     if (order.status == 'delivery') {
//       Routes.instance.push(widget: MapScreen(), context: context);
//     } else {
//       updateOrderStatus(order);
//     }
//   }

//   void updateOrderStatusWithQR(OrderModel order, String scannedOrderID) async {
//     if (scannedOrderID == order.orderId) {
//       updateOrderStatus(order);
//     } else {
//       print('Mismatched order IDs');
//     }
//   }
// }
