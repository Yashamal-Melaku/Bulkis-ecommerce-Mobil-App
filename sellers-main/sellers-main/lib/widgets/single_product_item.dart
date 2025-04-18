// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/constants/theme.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/screens/edit_product.dart';
import 'package:sellers/screens/product_details.dart';

class SingleProductItem extends StatefulWidget {
  final int index;
  final ProductModel singleProduct;
  const SingleProductItem({
    Key? key,
    required this.singleProduct,
    required this.index,
  }) : super(key: key);

  @override
  State<SingleProductItem> createState() => _SingleProductItemState();
}

class _SingleProductItemState extends State<SingleProductItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.singleProduct.quantity > 0
          ? DataTable(
              columns: [
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Discount')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('More')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.network(
                          widget.singleProduct.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        widget.singleProduct.name,
                        style: themeData.textTheme.bodyLarge,
                      ),
                    ),
                    DataCell(
                      Text(
                        'ETB ${widget.singleProduct.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          decoration: widget.singleProduct.discount != 0.0
                              ? TextDecoration.lineThrough
                              : null,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      widget.singleProduct.discount != 0.0
                          ? Row(
                              children: [
                                Text(
                                  'ETB ${widget.singleProduct.discount.toStringAsFixed(2)}',
                                  style: themeData.textTheme.bodySmall,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${(((widget.singleProduct.price - widget.singleProduct.discount) / (widget.singleProduct.price)) * 100).toStringAsFixed(0)} % off',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(''),
                    ),
                    DataCell(
                      Text(
                        widget.singleProduct.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: themeData.textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          // Handle button tap
                          Routes.instance.push(
                            widget: ProductDetails(
                              index: widget.index,
                              productModel: widget.singleProduct,
                            ),
                            context: context,
                          );
                        },
                        child: Text('Tap Me'),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : SizedBox.fromSize(),
    );
  }
}
