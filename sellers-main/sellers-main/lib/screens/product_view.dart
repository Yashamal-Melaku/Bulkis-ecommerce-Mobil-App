// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sellers/constants/custom_text.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/models/product_model.dart'; // Import your ProductModel class
import 'package:sellers/screens/add_product.dart';
import 'package:sellers/screens/product_details.dart';
import 'package:sellers/widgets/custom_drawer.dart';

class ProductView extends StatefulWidget {
  static const String id = 'product-view';
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
  final int index = 0;
  @override
  Widget build(BuildContext context) {
    //   AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(('Products')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
              child: Container(
                alignment: Alignment.center,
                width: 80,
                height: 40,
                color: Colors.green,
                child: Text(
                  _firestoreHelper.getProducts.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          FutureBuilder<List<ProductModel>>(
            future: _firestoreHelper.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data available');
              } else {
                return Stack(
                  children: [
                    text(title: snapshot.data!.length.toString()),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green),
                              showCheckboxColumn: false,
                              //columnSpacing: 0.0,
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'Image',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text('Name',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Quantity',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Price',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Discount',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: snapshot.data!.asMap().entries.map((entry) {
                                final int rowIndex = entry.key;
                                final ProductModel product = entry.value;
                                return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                      (states) => rowIndex % 2 == 0
                                          ? Colors.grey
                                              .shade300 // Zebra color for even rows
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
                                        width: 60,
                                        child: Text(
                                          product.name,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: 30,
                                        child: Text(
                                          product.quantity.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        product.price.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 14,
                                          decoration: product.discount != 0.0
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      product.discount != 0.0
                                          ? Text(
                                              product.discount
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            )
                                          : Text(''),
                                    ),
                                  ],
                                  onSelectChanged: (selected) {
                                    Routes.instance.push(
                                      widget: ProductDetails(
                                        productModel: product,
                                        index: index,
                                      ),
                                      context: context,
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              Routes.instance.push(
                widget: AddProduct(),
                context: context,
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
