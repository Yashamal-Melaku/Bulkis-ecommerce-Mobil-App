// ignore_for_file: use_build_context_synchronously

import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/payment/chapa_payment.dart';
import 'package:buyers/stripe_helper.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartItemCheckout extends StatefulWidget {
  const CartItemCheckout({super.key});

  @override
  State<CartItemCheckout> createState() => _CartItemCheckoutState();
}

class _CartItemCheckoutState extends State<CartItemCheckout> {
  int groupValue = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        // foregroundColor: Colors.white,
        title: Text('checkout'.tr),
        actions: const [
          Icon(Icons.person),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value!;
                        });
                      }),
                  const Icon(Icons.money),
                  const SizedBox(width: 20),
                  const Text(
                    'Pay With Chapa',
                    style: TextStyle(
                        fontSize: 20,
                        // color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                //   color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Radio(
                      value: 2,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value!;
                        });
                      }),
                  const Icon(Icons.money),
                  const SizedBox(width: 20),
                  const Text(
                    'Pay online',
                    style: TextStyle(
                        fontSize: 20,
                        // color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'continue'.tr,
              //   color: Colors.blue.shade300,
              onPressed: () async {
                if (groupValue == 1) {
                  Routes.instance.push(
                      widget: ChapaPayment(
                        title: 'Balkis',
                      ),
                      context: context);
                  // bool value = await FirebaseFirestoreHelper.instance
                  //     .uploadOrderedProductFirebase(
                  //         appProvider.getBuyproductList,
                  //         context,
                  //         'Pay With Chapa');

                  appProvider.clearBuyProduct();
                  appProvider.clearCart();

                  //   if (value) {
                  //     Future.delayed(const Duration(seconds: 1), () {
                  //       Routes.instance.push(
                  //           widget: const CustomBottomBar(), context: context);
                  //     });
                  //   }
                  // } else {
                  //   int value = double.parse(
                  //           appProvider.totalPriceBuyProductList().toString())
                  //       .round()
                  //       .toInt();
                  //   String totalPrice = (value * 100).toString();

                  //   bool isSuccefullPayment = await StripeHelper.instance
                  //       .makePayment(totalPrice.toString());
                  //   if (isSuccefullPayment) {
                  //     bool value = await FirebaseFirestoreHelper.instance
                  //         .uploadOrderedProductFirebase(
                  //             appProvider.getBuyproductList, context, 'payed');

                  //     appProvider.clearBuyProduct();

                  //     if (value) {
                  //       Future.delayed(const Duration(seconds: 1), () {
                  //         Routes.instance.push(
                  //             widget: const CustomBottomBar(), context: context);
                  //       });
                  //     }
                  //   }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
