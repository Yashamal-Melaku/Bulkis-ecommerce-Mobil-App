// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_null_comparison

import 'dart:math';

import 'package:admin/constants/routes.dart';
import 'package:admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  static const String id = 'product-view';
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final int index = 0;
  final TextEditingController _searchController = TextEditingController();

  /////////////////////////
  ///
  void showSellerDetailsDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Details'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 40,
                        alignment: Alignment.center,
                        color: Colors.red,
                        child: Text(
                          'X',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(),
          ),
          contentPadding: EdgeInsets.fromLTRB(30, 0, 0, 20),
          titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          content: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: product.image == null
                      ? CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person_outline),
                        )
                      : CircleAvatar(
                          radius: 70,
                          child: ClipOval(
                            child: Image.network(product.image),
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product name:   ${product.name ?? ''}'),
                          Text('Price:  ${product.price ?? ''}'),
                          Text('Discount:    ${product.discount ?? ''}'),
                          Text('Description: ${product.description ?? ''}'),
                          Text('No of Items:   ${product.quantity ?? ''}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          // Text('Country:     ${product.country ?? ''}'),
                          // Text('Region:      ${product.region ?? ''}'),
                          // Text('City:        ${product.city ?? ''}'),
                          // Text('Zone:        ${product.zone ?? ''}'),
                          // Text('Woreda:      ${product.woreda ?? ''}'),
                          // Text('Kebele:      ${product.kebele ?? ''}'),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'Search product by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.white,
              // appBar: AppBar(
              //   title: const Text(('Products')),
              //   actions: [
              //     Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: StreamBuilder<List<ProductModel>>(
              //         stream: getProducts(),
              //         builder: (context, snapshot) {
              //           int itemCount =
              //               snapshot.hasData ? snapshot.data!.length : 0;
              //           return Container(
              //             alignment: Alignment.center,
              //             width: 80,
              //             height: 40,
              //             color: Colors.green,
              //             child: Text(
              //               itemCount.toString(),
              //               style: const TextStyle(color: Colors.white),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),

              body: StreamBuilder<List<ProductModel>>(
                stream: getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: const Text('No data available'));
                  } else {
                    List<ProductModel> filteredProducts = snapshot.data!
                        .where((product) => product.name
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                    return Expanded(
                      child: Center(
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.grey.shade700),
                                      showCheckboxColumn: false,
                                      columnSpacing: 100,
                                      dataTextStyle:
                                          TextStyle(fontFamily: 'Normal'),
                                      columns: const [
                                        DataColumn(
                                            label: Text(
                                          'Image',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Id',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        DataColumn(
                                            label: Text('Name',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Quantity',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Price',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Discount',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                      rows: filteredProducts
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final int rowIndex = entry.key;
                                        final ProductModel product =
                                            entry.value;
                                        return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                              (states) => rowIndex % 2 == 0
                                                  ? Colors.grey.shade300
                                                  : Colors.white),
                                          cells: [
                                            DataCell(
                                              SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: Image.network(
                                                  product.image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                //  width: 60,
                                                child: Text(
                                                  product.id,
                                                  style: const TextStyle(
                                                      //    overflow: TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                //  width: 60,
                                                child: Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                      //  overflow: TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                //  width: 30,
                                                child: Text(
                                                  product.quantity.toString(),
                                                  //  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                product.price
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                      product.discount != 0.0
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                product.discount == 0.0
                                                    ? ''
                                                    : product.discount
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                          onSelectChanged: (selected) {
                                            showSellerDetailsDialog(product);
                                            // Routes.instance.push(
                                            //   widget: ProductDetails(
                                            //     productModel: product,
                                            //     index: index,
                                            //   ),
                                            //   context: context,
                                            // );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            ),
                            // Positioned(
                            //   bottom: 30,
                            //   right: 2,
                            //   child: FloatingActionButton(
                            //     backgroundColor: Colors.green,
                            //     onPressed: () {
                            //       Routes.instance.push(
                            //         widget: const AddProduct(),
                            //         context: context,
                            //       );
                            //     },
                            //     child: const Icon(
                            //       Icons.add,
                            //       color: Colors.white,
                            //       size: 30,
                            //     ),
                            //   ),
                            // ),
                          
                          
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> getProducts() {
    return _firebaseFirestore
        .collectionGroup('products')
        .snapshots()
        .map((querySnapshot) {
      List<ProductModel> productList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return productList;
    });
  }
}








// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sellers/constants/routes.dart';
// import 'package:sellers/models/product_model.dart'; // Import your ProductModel class
// import 'package:sellers/providers/app_provider.dart';
// import 'package:sellers/screens/add_product.dart';
// import 'package:sellers/screens/product_details.dart';
// import 'package:sellers/widgets/custom_drawer.dart';

// class ProductView extends StatefulWidget {
//   static const String id = 'product-view';
//   const ProductView({Key? key}) : super(key: key);

//   @override
//   State<ProductView> createState() => _ProductViewState();
// }

// class _ProductViewState extends State<ProductView> {
//   final int index = 0;
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(('Products').toUpperCase()),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.green,
//               child: Text(
//                 appProvider.getProducts.length.toString(),
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//       drawer: CustomDrawer(),
//       body: FutureBuilder<List<ProductModel>>(
//         future:
//             getProducts(), // Replace with your function to fetch data from Firebase
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('No data available');
//           } else {
//             return Stack(
//               children: [
//                 SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       DataTable(
//                         headingRowColor: MaterialStateColor.resolveWith(
//                             (states) => Colors.green),
//                         columns: [
//                           DataColumn(
//                               label: Text(
//                             'Image',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           )),
//                           DataColumn(
//                               label: Text('Name',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold))),
//                           DataColumn(
//                               label: Text('Price',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold))),
//                           DataColumn(
//                               label: Text('Discount',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold))),
//                           DataColumn(
//                               label: Text('Quantity',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold))),
//                           DataColumn(
//                               label: Text('More',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold))),
//                         ],
//                         columnSpacing: 10,
//                         rows: snapshot.data!.asMap().entries.map((entry) {
//                           final int rowIndex = entry.key;
//                           final ProductModel product = entry.value;
//                           return DataRow(
//                             color: MaterialStateColor.resolveWith((states) =>
//                                 rowIndex % 2 == 0
//                                     ? Colors.grey
//                                         .shade300 // Zebra color for even rows
//                                     : Colors.white),
//                             cells: [
//                               DataCell(
//                                 SizedBox(
//                                   height: 30,
//                                   width: 30,
//                                   child: Image.network(
//                                     product.image,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     product.name,
//                                     style: TextStyle(
//                                         overflow: TextOverflow.ellipsis,
//                                         fontSize: 14,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 Text(
//                                   product.price.toStringAsFixed(2),
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     decoration: product.discount != 0.0
//                                         ? TextDecoration.lineThrough
//                                         : null,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 product.discount != 0.0
//                                     ? Text(
//                                         product.discount.toStringAsFixed(2),
//                                         style: TextStyle(
//                                             fontSize: 14, color: Colors.black),
//                                       )
//                                     : Text(''),
//                               ),
//                               DataCell(
//                                 Container(
//                                   width: 30,
//                                   child: Text(
//                                     product.quantity.toString(),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                         fontSize: 14, color: Colors.black),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(
//                                 ElevatedButton(
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                         MaterialStateProperty.all(Colors.white),
//                                     side: MaterialStateProperty.all(
//                                         BorderSide(color: Colors.grey)),
//                                     shape: MaterialStateProperty.all(
//                                       RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(8.0),
//                                       ),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Handle button tap
//                                     Routes.instance.push(
//                                       widget: ProductDetails(
//                                         productModel: product,
//                                         index: index,
//                                       ),
//                                       context: context,
//                                     );
//                                   },
//                                   child: FittedBox(
//                                     child: Text(
//                                       'More',
//                                       style: TextStyle(
//                                         color: Colors.green,
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                       SizedBox(
//                         height: 100,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 30,
//                   right: 2,
//                   child: FloatingActionButton(
//                     backgroundColor: Colors.green,
//                     onPressed: () {
//                       Routes.instance.push(
//                         widget: AddProduct(),
//                         context: context,
//                       );
//                     },
//                     child: Icon(
//                       Icons.add,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }

//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   Future<List<ProductModel>> getProducts() async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
//         .collectionGroup('products')
//         .where('sellerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .get();

//     print('Number of Products: ${querySnapshot.size}');

//     List<ProductModel> productList =
//         querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();

//     print('Product List: $productList');
//     return productList;
//   }
// }







// import 'package:admin/constants/routes.dart';
// import 'package:admin/constants/top_titles.dart';
// import 'package:admin/custom_drawer.dart';
// import 'package:admin/models/product_model.dart';
// import 'package:admin/provider/app_provider.dart';
// import 'package:admin/widgets/add_product.dart';
// import 'package:admin/widgets/single_product_item.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProductView extends StatefulWidget {
//   static const String id = 'product-view';
//   const ProductView({super.key});

//   @override
//   State<ProductView> createState() => _ProductViewState();
// }

// class _ProductViewState extends State<ProductView> {
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('products'),
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {
//       //         Routes.instance.push(widget: AddProduct(), context: context);
//       //       },
//       //       icon: Icon(Icons.add_circle),
//       //     ),
//       //   ],
//       // ),

//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             TopTitles(
//                 title: 'Products',
//                 subtitle: appProvider.getProducts.length.toString()),
//             GridView.builder(
//                 padding: const EdgeInsets.only(bottom: 20, top: 20),
//                 shrinkWrap: true,
//                 primary: false,
//                 itemCount: appProvider.getProducts.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 0.8,
//                     mainAxisSpacing: 20,
//                     crossAxisSpacing: 20,
//                     crossAxisCount: 4),
//                 itemBuilder: (ctx, index) {
//                   var singleProduct = appProvider.getProducts[index];
//                   return SingleProductItem(
//                       singleProduct: singleProduct, index: index);
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }
