import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  final ProductModel singleProduct;
  const CheckOutScreen({super.key, required this.singleProduct});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int groupValue = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
                // color: Colors.white,
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
                    'Chapa',
                    style: TextStyle(
                        fontSize: 20,
                        //        color: Colors.blue,
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
                // color: Colors.white,
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
                        //   color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'continue'.tr,
              //  color: Colors.green,
              onPressed: () async {
                appProvider.clearBuyProduct();
                appProvider.addBuyProduct(widget.singleProduct);

                bool value = await FirebaseFirestoreHelper.instance
                    .uploadOrderedProductFirebase(appProvider.getBuyproductList,
                        context, groupValue == 1 ? 'Chapa' : 'payed');

                if (value) {
                  Future.delayed(const Duration(seconds: 1), () {
                    Routes.instance.push(
                        widget: const CustomBottomBar(), context: context);
                    appProvider.clearBuyProduct();
                    appProvider.clearCart();
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
