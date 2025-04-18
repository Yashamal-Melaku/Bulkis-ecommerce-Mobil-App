import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/custom_drawer.dart';
import 'package:buyers/screens/cart_checkout.dart';
import 'package:buyers/screens/google_map.dart';
import 'package:buyers/screens/single_cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
      //  foregroundColor: Colors.white,
        title: Text('cart'.tr),
        actions: const [
          Icon(Icons.shopping_bag),
        ],
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: appProvider.getCartProductList.isNotEmpty
          ? Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total'.tr,
                            style: TextStyle(
                                fontSize: 20,
                               // color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'ETB ${appProvider.totalPrice().toString()}',
                            style: const TextStyle(
                                fontSize: 20,
                              //  color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: CustomButton(
                              title: 'checkout'.tr,
                           //   color: Colors.green,
                              onPressed: () {
                                appProvider.clearBuyProduct();
                                appProvider.addBuyProductCartList();
                                // appProvider.clearCart();
                                if (appProvider.getBuyproductList.isEmpty) {
                                  showMessage('Cart is empty');
                                } else {
                                  Routes.instance.push(
                                      widget: const MapScreen(),
                                      context: context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.fromSize(),
      body: appProvider.getCartProductList.isEmpty
          ? Center(
              child: Text('emptyCart'.tr),
            )
          : ListView.builder(
              itemCount: appProvider.getCartProductList.length,
              itemBuilder: (ctx, index) {
                return SIngleCartItem(
                    singleProduct: appProvider.getCartProductList[index]);
              },
            ),
    );
  }
}
