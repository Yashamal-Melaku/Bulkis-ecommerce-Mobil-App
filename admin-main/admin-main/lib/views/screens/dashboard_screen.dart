// ignore_for_file: prefer_const_constructors

import 'package:admin/provider/app_provider.dart';
import 'package:admin/views/widgets/count_dashboard.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'home-page';
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isloading = false;
  void getData() async {
    setState(() {
      isloading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.callBackFunction();
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return TotalCounts(appProvider: appProvider);
  }
}

// class AdminTotals extends StatelessWidget {
//   const AdminTotals({
//     super.key,
//     required this.appProvider,
//   });

//   final AppProvider appProvider;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30.0),
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//               color: Colors.grey.shade300,
//               height: 100,
//               width: MediaQuery.of(context).size.width,
//               child: Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: const UserViewScreen(),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.verified_user_outlined,
//                       title: 'Users',
//                       subtitle: appProvider.getUserList.length.toString(),
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: const CategoryViewScreen(),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.category,
//                       title: 'Category',
//                       subtitle: appProvider.getCategoryList.length.toString(),
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: const ProductView(),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.shop_2,
//                       title: 'Products',
//                       subtitle: appProvider.getProducts.length.toString(),
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: const ProductView(),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.money,
//                       title: 'Earnings',
//                       subtitle: 'ETB ${appProvider.getTotalEarnings}',
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: OrderListView(title: 'All'),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.pending,
//                       title: 'All orders',
//                       subtitle: appProvider.getAllOrderList.length.toString(),
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: OrderListView(title: 'Pending'),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.pending,
//                       title: 'Pending order',
//                       subtitle:
//                           appProvider.getPendingOrderList.length.toString(),
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: OrderListView(title: 'Completed'),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.disc_full,
//                       title: 'Completed order',
//                       subtitle: appProvider.getCompletedOrder.length.toString(),
//                     ),
//                     SingleDashItem(
//                       onPressed: () {
//                         Routes.instance.push(
//                           widget: OrderListView(title: 'Delivery'),
//                           context: context,
//                         );
//                       },
//                       icon: Icons.delivery_dining,
//                       title: 'Delivered order',
//                       subtitle:
//                           appProvider.getDeliveryOrderList.length.toString(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
