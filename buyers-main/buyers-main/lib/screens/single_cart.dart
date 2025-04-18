// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/constants.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

class SIngleCartItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SIngleCartItem({super.key, required this.singleProduct});

  @override
  State<SIngleCartItem> createState() => _SIngleCartItemState();
}

class _SIngleCartItemState extends State<SIngleCartItem> {
  int quantity = 1;

  @override
  void initState() {
    // quantity = widget.singleProduct.quantity ?? 1;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    color: Theme.of(context).colorScheme.primary,
                    child: Image.network(widget.singleProduct.image),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      widget.singleProduct.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        //  color: Colors.black
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                            appProvider.updateQuantity(
                                                widget.singleProduct, quantity);
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        child: const CircleAvatar(
                                          maxRadius: 14,
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.remove),
                                        ),
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // if (quantity <
                                      //     widget.singleProduct.quantity)
                                      CupertinoButton(
                                        onPressed: () {
                                          setState(() {
                                            quantity++;
                                          });
                                          appProvider.updateQuantity(
                                              widget.singleProduct, quantity);
                                        },
                                        padding: EdgeInsets.zero,
                                        child: const CircleAvatar(
                                          maxRadius: 14,
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        if (!appProvider.getFavoriteProductList
                                            .contains(widget.singleProduct)) {
                                          appProvider.addToFavoriteproduct(
                                              widget.singleProduct);
                                          showMessage('addedToFavorits'.tr);
                                        } else {
                                          appProvider.removeFavoriteproduct(
                                              widget.singleProduct);
                                          showMessage(
                                              'removedFormFavorites'.tr);
                                        }
                                      },
                                      child: Text(
                                        appProvider.getFavoriteProductList
                                                .contains(widget.singleProduct)
                                            ? 'removeWishList'.tr
                                            : 'addToWishList'.tr,
                                        style: const TextStyle(
                                            // color: Colors.red,
                                            fontSize: 14),
                                      )),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    child: Text(
                                        'Price: ETB ${(widget.singleProduct.discount == 0.0 ? widget.singleProduct.price : widget.singleProduct.discount).toDouble()}'),
                                  ),
                                  FittedBox(
                                    child: Text(
                                        'Total : ${widget.singleProduct.discount == 0.0 ? widget.singleProduct.price * quantity : widget.singleProduct.discount * quantity}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CupertinoButton(
                              child: const CircleAvatar(
                                //   backgroundColor: Colors.white,
                                maxRadius: 14,
                                child: Icon(
                                  Icons.delete,
                                  // color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                appProvider
                                    .removeCartproduct(widget.singleProduct);
                                showMessage('removedFromCart'.tr);
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
