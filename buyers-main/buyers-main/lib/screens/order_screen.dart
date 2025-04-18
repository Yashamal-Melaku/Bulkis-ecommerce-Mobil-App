// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:buyers/constants/theme.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/order_model.dart';
import 'package:buyers/screens/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController? _scrollController;
  bool _isScrollDown = false;
  bool _showAppBar = true;

  @override
  void initState() {
    _scrollController = ScrollController();

    _scrollController!.addListener(() {
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollDown) {
          setState(() {
            _isScrollDown = true;
            _showAppBar = false;
          });
        }
      }
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollDown) {
          setState(() {
            _isScrollDown = false;
            _showAppBar = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Scaffold(
        appBar: _showAppBar
            ? AppBar(
                centerTitle: true,
                //foregroundColor: Colors.black,
                title: Text('orders'.tr),
                actions: const [
                  Icon(Icons.person),
                ],
              )
            : null,
        drawer: CustomDrawer(),
        body: FutureBuilder(
            future: FirebaseFirestoreHelper.instance.getUserOrder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty ||
                  snapshot.data == null ||
                  !snapshot.hasData) {
                return Center(
                  child: Text('noOrder'.tr),
                );
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  OrderModel orderModel = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 1, 1),
                    child: Container(
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green, width: 2)),

                      //shadowColor: Colors.black,
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        //backgroundColor: Colors.white,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // side: BorderSide(
                          //   color: Colors.blue,
                          // )
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                width: 80,
                                // color: Colors.white,
                                child: Image.network(
                                  orderModel.products[0].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // VerticalDivider(color: Colors.red),
                            Expanded(
                              flex: 3,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            orderModel.products[0].name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                //   color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // Spacer(),
                                          if (orderModel.products.length >
                                              1) ...[
                                            CircleAvatar(
                                              // backgroundColor: Colors.black45,
                                              radius: 12,
                                              child: Text(
                                                orderModel.products[0].quantity
                                                    .toString(),
                                                style: TextStyle(
                                                    //   color: Colors.white
                                                    ),
                                              ),
                                            ),
                                          ],
                                          if (orderModel.status == 'completed')
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      FittedBox(
                                        child: Text(
                                          'total Price ETB ${orderModel.totalprice.toString()}',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      FittedBox(
                                        child: Text(
                                          ' ${orderModel.status}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: orderModel.status ==
                                                    'pending'
                                                ? Colors.yellow.shade900
                                                : (orderModel.status ==
                                                        'canceled'
                                                    ? Colors.red
                                                    : (orderModel.status ==
                                                                'completed' ||
                                                            orderModel.status ==
                                                                'delivery'
                                                        ? Colors.green
                                                        : Colors.black)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      // if (orderModel.status == 'pending' ||
                                      //     orderModel.status == 'delivery')
                                      // ElevatedButton(
                                      //   onPressed: () async {
                                      //     await FirebaseFirestoreHelper
                                      //         .instance
                                      //         .updateOrder(
                                      //             orderModel, 'canceled');
                                      //     orderModel.status = 'canceled';
                                      //     setState(() {});
                                      //   },
                                      //   child: Text(
                                      //     'Cancel',
                                      //     style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // ),

                                      SizedBox(height: 12),
                                      if (orderModel.status == 'delivery')
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.green),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Adjust the border radius as needed
                                                  side: const BorderSide(
                                                      color: Colors.white,
                                                      width: 1.0),
                                                ),
                                              )),
                                          onPressed: () async {
                                            String qrCodeData =
                                                await FirebaseFirestoreHelper
                                                    .instance
                                                    .generateQRCode(
                                                        orderModel.orderId);
                                            showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(10),
                                                ),
                                              ),
                                              builder: (BuildContext context) {
                                                return Container(
                                                  //  color: Colors.white,
                                                  //  height: 450,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            color: Colors.red,
                                                            child: TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                'X',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        30),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        width: 250,
                                                        height: 250,
                                                        child: QrImageView(
                                                          data: qrCodeData,
                                                          version:
                                                              QrVersions.auto,
                                                          size: 250.0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'scanQrCode'.tr,
                                                        // style: themeData
                                                        //     .textTheme
                                                        //     .bodyLarge
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        color: Colors.green,
                                                        height: 40,
                                                      ),
                                                      SizedBox(height: 20)
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'conformDelivery'.tr,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        children: orderModel.products.length > 1
                            ? [
                                Text('details'.tr),
                                Divider(color: Colors.grey),
                                ...orderModel.products.map((singleProduct) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.grey.shade400,
                                          child: Image.network(
                                            singleProduct.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    singleProduct.name,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Spacer(),
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      Colors.black38,
                                                  child: Text(
                                                    singleProduct.quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            FittedBox(
                                              child: Text(
                                                  'Price: ETB ${singleProduct.price.toString()}'),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              orderModel.products[0].status,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: const Color.fromRGBO(
                                                      230, 74, 25, 1)),
                                            ),
                                            Divider(color: Colors.pink)
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }).toList()
                              ]
                            : [],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
