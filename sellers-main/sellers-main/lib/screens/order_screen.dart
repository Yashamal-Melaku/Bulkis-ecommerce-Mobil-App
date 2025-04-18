// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:sellers/controllers/firebase_firestore_helper.dart';
// import 'package:sellers/models/order_model.dart';
// import 'package:sellers/widgets/custom_drawer.dart';

// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   ScrollController? _scrollController;
//   bool _isScrollDown = false;
//   bool _showAppBar = true;

//   @override
//   void initState() {
//     _scrollController = ScrollController();

//     _scrollController!.addListener(() {
//       if (_scrollController!.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         if (!_isScrollDown) {
//           setState(() {
//             _isScrollDown = true;
//             _showAppBar = false;
//           });
//         }
//       }
//       if (_scrollController!.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         if (_isScrollDown) {
//           setState(() {
//             _isScrollDown = false;
//             _showAppBar = true;
//           });
//         }
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _showAppBar
//           ? AppBar(
//               foregroundColor: Colors.white,
//               title: const Text('Orders'),
//               actions: const [
//                 Icon(Icons.person),
//               ],
//             )
//           : null,
//       drawer: CustomDrawer(),
//       body: FutureBuilder(
//           future: FirebaseFirestoreHelper.instance.getUserOrder(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (snapshot.data!.isEmpty ||
//                 snapshot.data == null ||
//                 !snapshot.hasData) {
//               return const Center(
//                 child: Text('No order found'),
//               );
//             }
//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 OrderModel orderModel = snapshot.data![index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ExpansionTile(
//                     tilePadding: EdgeInsets.zero,
//                     backgroundColor: Colors.white,
//                     collapsedShape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: BorderSide(
//                           color: Colors.blue,
//                         )),
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Colors.grey)),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             height: 150,
//                             width: 80,
//                             color: Colors.grey.shade400,
//                             child: Image.network(
//                               orderModel.products[0].image,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 3,
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     orderModel.products[0].name,
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.black),
//                                   ),
//                                   if (orderModel.products.length > 1) ...[
//                                     SizedBox(height: 10),
//                                     Text(
//                                         'Quantity: ${orderModel.products[0].quantity.toString()}'),
//                                   ],
//                                   SizedBox(height: 10),
//                                   FittedBox(
//                                     child: Text(
//                                         'Total price: ETB ${orderModel.totalprice.toString()}'),
//                                   ),
//                                   SizedBox(height: 10),
//                                   FittedBox(
//                                     child: Text(
//                                       'Order Status: ${orderModel.status}',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: orderModel.status == 'pending'
//                                             ? Colors.yellow.shade900
//                                             : (orderModel.status == 'canceled'
//                                                 ? Colors.red
//                                                 : (orderModel.status ==
//                                                             'completed' ||
//                                                         orderModel.status ==
//                                                             'delivery'
//                                                     ? Colors.green
//                                                     : Colors.black)),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 12),
//                                   if (orderModel.status == 'pending' ||
//                                       orderModel.status == 'delivery')
//                                     ElevatedButton(
//                                       onPressed: () async {
//                                         await FirebaseFirestoreHelper.instance
//                                             .updateOrder(
//                                                 orderModel, 'canceled');
//                                         orderModel.status = 'canceled';
//                                         setState(() {});
//                                       },
//                                       child: Text(
//                                         'Cancel',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   SizedBox(height: 12),
//                                   if (orderModel.status == 'delivery')
//                                     ElevatedButton(
//                                       onPressed: () async {
//                                         await FirebaseFirestoreHelper.instance
//                                             .updateOrder(
//                                                 orderModel, 'completed');
//                                         orderModel.status = 'completed';
//                                         setState(() {});
//                                       },
//                                       child: Text('Delivered',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     children: orderModel.products.length > 1
//                         ? [
//                             Text('Details'),
//                             Divider(color: Colors.grey),
//                             ...orderModel.products.map((singleProduct) {
//                               return Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       height: 80,
//                                       width: 80,
//                                       color: Colors.grey.shade400,
//                                       child: Image.network(
//                                         singleProduct.image,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 1,
//                                     child: SizedBox(
//                                       height: 140,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               singleProduct.name,
//                                               style: const TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.black),
//                                             ),
//                                             Text(
//                                                 'Quantity:${singleProduct.quantity.toString()}'),
//                                             SizedBox(height: 10),
//                                             FittedBox(
//                                               child: Text(
//                                                   'Price: ETB ${singleProduct.price.toString()}'),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               orderModel.products[0].status,
//                                               style: const TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.black),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               );
//                             }).toList()
//                           ]
//                         : [],
//                   ),
//                 );
//               },
//             );
//           }),
//     );
//   }
// }
