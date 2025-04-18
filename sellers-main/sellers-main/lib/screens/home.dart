// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/models/order_model.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/screens/add_product.dart';
import 'package:sellers/screens/category_view.dart';
import 'package:sellers/widgets/custom_drawer.dart';
import 'package:sellers/widgets/single_dash_item.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home-page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                          SingleDashItem(
                            onPressed: () {
                              Routes.instance.push(
                                widget: const CategoryViewScreen(),
                                context: context,
                              );
                            },
                            icon: Icons.category_outlined,
                            title: 'Categories',
                            subtitle:
                                appProvider.getCategoryList.length.toString(),
                          ),
                          productStreamBuilder(Icons.shop_2, 'Products'),
                          SingleDashItem(
                            onPressed: () {
                              print(FirebaseAuth.instance.currentUser!.uid);
                              Routes.instance.push(
                                widget: const AddProduct(),
                                context: context,
                              );
                            },
                            icon: Icons.money,
                            title: 'Earnings',
                            subtitle: 'ETB ${appProvider.getTotalEarnings}',
                          ),
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













// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sellers/constants/routes.dart';
// import 'package:sellers/controllers/firebase_firestore_helper.dart';
// import 'package:sellers/models/order_model.dart';
// import 'package:sellers/providers/app_provider.dart';
// import 'package:sellers/screens/category_view.dart';
// import 'package:sellers/screens/order_list.dart';
// import 'package:sellers/screens/orders_screen.dart';
// import 'package:sellers/screens/product_view.dart';
// import 'package:sellers/widgets/custom_drawer.dart';
// import 'package:sellers/widgets/single_dash_item.dart';

// class HomePage extends StatefulWidget {
//   static const String id = 'home-page';
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
//   bool isloading = false;
//   void getData() async {
//     setState(() {
//       isloading = true;
//     });
//     AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
//     appProvider.callBackFunction();
//     setState(() {
//       isloading = false;
//     });
//   }

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   Future<void> _showUserInfoDialog({
//     BuildContext? context,
//     IconData? icon,
//     String? title,
//     String? subtitle,
//   }) async {
//     return showDialog(
//       context: context!,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Icon(icon),
//               Text('Total No of $title'),
//             ],
//           ),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(subtitle!),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget ordersStreamBuilder(
//     IconData icon,
//     String title,
//     String status,
//   ) {
//     return StreamBuilder<List<OrderModel>>(
//       stream: status.isEmpty
//           ? _firestoreHelper.getOrderListStream()
//           : _firestoreHelper.getOrderListStream(status: status),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Flexible(
//             child: SingleDashItem(
//               onPressed: () {
//                 _showUserInfoDialog(
//                   context: context,
//                   icon: icon,
//                   title: title,
//                   subtitle: snapshot.data!.length.toString(),
//                 );
//               },
//               icon: icon,
//               title: title,
//               subtitle: snapshot.data!.length.toString(),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//       ),
//       drawer: CustomDrawer(),
//       body: isloading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Column(
//                     children: [
//                       Divider(),
//                       GridView.count(
//                         shrinkWrap: true,
//                         primary: false,
//                         padding: const EdgeInsets.only(top: 20),
//                         crossAxisCount: 2,
//                         children: [
//                           // SingleDashItem(
//                           //     onPressed: () {
//                           //       Routes.instance.push(
//                           //           widget: const UserViewScreen(),
//                           //           context: context);
//                           //     },
//                           //     title: 'Users',
//                           //     subtitle:
//                           //         appProvider.getUserList.length.toString()),
//                           SingleDashItem(
//                               onPressed: () {
//                                 Routes.instance.push(
//                                     widget: const CategoryViewScreen(),
//                                     context: context);
//                               },
//                               icon: Icons.category_outlined,
//                               title: 'Categories',
//                               subtitle: appProvider.getCategoryList.length
//                                   .toString()),
//                           SingleDashItem(
//                             onPressed: () {
//                               Routes.instance.push(
//                                   widget: const ProductView(),
//                                   context: context);
//                             },
//                             icon: Icons.shop_2,
//                             title: 'Products',
//                             subtitle: FutureBuilder<int>(
//                               future: _firestoreHelper.getProducts,
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return CircularProgressIndicator();
//                                 } else if (snapshot.hasError) {
//                                   return Text('Error: ${snapshot.error}');
//                                 } else {
//                                   return Text('Count: ${snapshot.data}');
//                                 }
//                               },
//                             ),
//                           ),
                        
//                           SingleDashItem(
//                               onPressed: () {
//                                 Routes.instance.push(
//                                     widget: const ProductView(),
//                                     context: context);
//                               },
//                               icon: Icons.money,
//                               title: 'Earnings',
//                               subtitle: 'ETB ${appProvider.getTotalEarnings}'),
//                           ordersStreamBuilder(Icons.pending, 'Orders', ''),
//                           ordersStreamBuilder(
//                               Icons.pending, 'Pending order', 'pending'),
//                           ordersStreamBuilder(
//                               Icons.disc_full, 'Completed order', 'completed'),
//                           ordersStreamBuilder(Icons.delivery_dining,
//                               'Delivery order', 'delivery'), 
              
//                           SingleDashItem(
//                               onPressed: () {
//                                 Routes.instance.push(
//                                     widget: OrderListView(title: 'Delivery'),
//                                     context: context);
//                               },
//                               icon: Icons.delivery_dining_rounded,
//                               title: 'Delvery orders',
//                               subtitle: _firestoreHelper
//                                   .getOrderListStream(status: 'delivery')
//                                   .length
//                                   .toString()),
//                           Spacer(),
//                         ],
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//     );
//   }
// }









