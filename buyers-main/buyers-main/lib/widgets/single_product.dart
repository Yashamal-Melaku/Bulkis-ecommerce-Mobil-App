import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/screens/product_details.dart';
import 'package:flutter/material.dart';

class SingleProductWidget extends StatelessWidget {
  const SingleProductWidget({
    super.key,
    required this.singleProduct,
  });

  final ProductModel singleProduct;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routes.instance.push(
            widget: ProductDetails(singleProduct: singleProduct),
            context: context);
      },
      child: Card(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(
                //     color:
                //         Colors.pink),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      singleProduct.name,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child:
                          Image.network(singleProduct.image, fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    if (singleProduct.discount != 0.0)
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              'ETB ${singleProduct.discount.toStringAsFixed(2)}',
                              // style:
                              //     themeData.textTheme.bodySmall
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(((singleProduct.price - singleProduct.discount) / (singleProduct.price)) * 100).toStringAsFixed(0)} %  off',
                              style: TextStyle(
                                  // color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    Text(
                      'Price: ETB ${singleProduct.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          decoration: singleProduct.discount != 0.0
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    Text(
                      'Description: ${singleProduct.description}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(' ${singleProduct.quantity} items found'),
                    if (singleProduct.size != 0.0)
                      // Text(
                      //     ' ${singleProduct.size} ${singleProduct.measurement} '),
                      const SizedBox(
                        height: 6.0,
                      ),
                  ],
                ),
              ),
            ),
            //   Container(
            //     color: Colors
            //         .deepOrange,
            //     height: 30,
            //     width: 30,
            //     alignment: Alignment
            //         .center,
            //     child: IconButton(
            //         onPressed: () {
            //           Routes.instance.push(
            //               widget: ProductDetails(
            //                   singleProduct:
            //                       singleProduct),
            //               context:
            //                   context);
            //           Routes.instance.push(
            //               widget: CheckOutScreen(
            //                   singleProduct:
            //                       singleProduct),
            //               context:
            //                   context);
            //         },
            //         icon: Icon(
            //             Icons
            //                 .shopping_cart_checkout,
            //             color: Colors
            //                 .white)),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
