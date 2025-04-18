
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/providers/app_provider.dart';

class SingleFavoriteWidget extends StatefulWidget {
  final ProductModel singleProduct;
  const SingleFavoriteWidget({super.key, required this.singleProduct});

  @override
  State<SingleFavoriteWidget> createState() => _SingleFavoriteWidgetState();
}

class _SingleFavoriteWidgetState extends State<SingleFavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 3),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    color: Colors.blue,
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
                                  Text(
                                    widget.singleProduct.name,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        AppProvider appProvider =
                                            Provider.of(context, listen: false);
                                        appProvider.removeFavoriteproduct(
                                            widget.singleProduct);
                                        showMessage('Removed to wishlst');
                                      },
                                      child: const Text('Remove from wishlist'))
                                ],
                              ),
                              Text(
                                  'Price: ETB ${(widget.singleProduct.price).toDouble()}'),
                            ],
                          ),
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
