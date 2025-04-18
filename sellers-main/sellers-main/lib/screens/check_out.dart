// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sellers/constants/custom_button.dart';
// import 'package:sellers/constants/routes.dart';
// import 'package:sellers/controllers/firebase_firestore_helper.dart';
// import 'package:sellers/models/product_model.dart';
// import 'package:sellers/providers/app_provider.dart';
// import 'package:sellers/widgets/bottom_bar.dart';

// class CheckOutScreen extends StatefulWidget {
//   final ProductModel singleProduct;
//   const CheckOutScreen({super.key, required this.singleProduct});

//   @override
//   State<CheckOutScreen> createState() => _CheckOutScreenState();
// }

// class _CheckOutScreenState extends State<CheckOutScreen> {
//   int groupValue = 1;
//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(
//       context,
//     );
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: const Text('Checkout'),
//         actions: const [
//           Icon(Icons.person),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 36,
//             ),
//             Container(
//               width: double.infinity,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Row(
//                 children: [
//                   Radio(
//                       value: 1,
//                       groupValue: groupValue,
//                       onChanged: (value) {
//                         setState(() {
//                           groupValue = value!;
//                         });
//                       }),
//                   const Icon(Icons.money),
//                   const SizedBox(width: 20),
//                   const Text(
//                     'Cash on delivery',
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 36,
//             ),
//             Container(
//               width: double.infinity,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Row(
//                 children: [
//                   Radio(
//                       value: 2,
//                       groupValue: groupValue,
//                       onChanged: (value) {
//                         setState(() {
//                           groupValue = value!;
//                         });
//                       }),
//                   const Icon(Icons.money),
//                   const SizedBox(width: 20),
//                   const Text(
//                     'Pay online',
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             CustomButton(
//               title: 'Continue',
//               onPressed: () async {
//                 appProvider.clearBuyProduct();
//                 appProvider.addBuyProduct(widget.singleProduct);

//                 bool value = await FirebaseFirestoreHelper.instance
//                     .uploadOrderedProductFirebase(
//                         appProvider.getBuyproductList,
//                         context,
//                         groupValue == 1 ? 'Cash on delivery' : 'payed');

//                 appProvider.clearBuyProduct();

//                 if (value) {
//                   Future.delayed(const Duration(seconds: 1), () {
//                     Routes.instance.push(
//                         widget: const CustomBottomBar(), context: context);
//                   });
//                 }
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
