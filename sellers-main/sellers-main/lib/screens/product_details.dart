// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/controllers/firebase_storage_helper.dart';
import 'package:sellers/models/catagory_model.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/widgets/custom_drawer.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  final int index;
  const ProductDetails({
    super.key,
    required,
    required this.productModel,
    required this.index,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController price = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController measurement = TextEditingController();
  CategoryModel? _selectedCategory;
  List<String> measurments = ['Kilogram', 'Litter'];
  String? _selectedUnit;

  bool _editable = true;

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      name.text = widget.productModel.name;
      description.text = widget.productModel.description;
      price.text = widget.productModel.price.toStringAsFixed(2);
      discount.text = widget.productModel.discount.toStringAsFixed(2);
      quantity.text = widget.productModel.quantity.toString();
      size.text = widget.productModel.size.toStringAsFixed(3);
      //  name.text = widget.productModel.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
            actions: [
              // _editable == true
              //     ?
              IconButton(
                  onPressed: () {
                    setState(() {
                      _editable = !_editable;
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 32,
                  ))
              // : Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: TextButton(
              //       onPressed: () {
              //         FirebaseFirestoreHelper.instance.updateSingleProduct;
              //         setState(() {
              //           _editable = true;
              //         });
              //       },
              //       style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all(Colors.white)),
              //       child: const Text(
              //         'Save',
              //         style: TextStyle(
              //             color: Colors.blue, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   )
            ],
            title: Text(_editable
                ? '${widget.productModel.name}  Details'
                : '${widget.productModel.name}  Editing...')),
        // drawer: CustomDrawer(),
        body: AbsorbPointer(
          absorbing: _editable,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            children: [
              InkWell(
                onTap: () {
                  takePicture();
                  // setState(() {
                  //   SizedBox(
                  //       height: 200,
                  //       width: double.infinity,
                  //       child: image == null
                  //           ? Image.network(
                  //               widget.productModel.image,
                  //               fit: BoxFit.cover,
                  //             )
                  //           : Image.file(image!));
                  // });
                },
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: image == null
                      ? Image.network(
                          widget.productModel.image,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image!,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    label: Text('Product Name')),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter product name';
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                dropdownColor: Colors.white,
                value: _selectedCategory,
                hint: Text(
                  'Select category',
                ),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                items: appProvider.getCategoryList.map((CategoryModel val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val.name,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: description,
                minLines: 2,
                maxLines: 10,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Product discription'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter product description';
                  }
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Price',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product price';
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: discount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Discount',
                      ),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 12),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: quantity,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Quantity',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product quantity';
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: size,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Size',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product size';
                        }
                      },
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                dropdownColor: Colors.white,
                value: _selectedUnit,
                hint: Text('Measurement unit'),
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                  });
                },
                items: measurments
                    .map<DropdownMenuItem<String>>((String selectedUnit) {
                  return DropdownMenuItem<String>(
                    value: selectedUnit,
                    child: Text(selectedUnit),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),
              const SizedBox(height: 20),
              if (!_editable)
                SizedBox(
                    child: CustomButton(
                        onPressed: () async {
                          if (image == null && name.text.isEmpty) {
                            Navigator.of(context).pop();
                          } else if (image != null) {
                            String imageUrl = await FirebaseStorageHelper
                                .instance
                                .uploadProductImage(
                                    widget.productModel.id, image!);
                            ProductModel productModel = widget.productModel
                                .copyWith(
                                    image: imageUrl,
                                    name: name.text,
                                    description: description.text,
                                    price: double.parse(price.text),
                                    discount: double.parse(discount.text),
                                    quantity: int.parse(quantity.text),
                                    size: double.parse(size.text));
                            appProvider.updateProductList(
                                widget.index, productModel);
                            showMessage('Product updated');
                          } else {
                            ProductModel productModel = widget.productModel
                                .copyWith(
                                    name: name.text,
                                    description: description.text,
                                    price: double.parse(price.text),
                                    discount: double.parse(discount.text),
                                    quantity: int.parse(quantity.text),
                                    size: double.parse(size.text));
                            appProvider.updateProductList(
                                widget.index, productModel);
                            showMessage('Product successfully updated');
                          }
                          Navigator.of(context).pop();
                          //   appProvider.updateUserInfoFirebase(
                          //   context, userModel, image);
                        },
                        title: 'Update'))
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:provider/provider.dart';
// import 'package:sellers/constants/constants.dart';
// import 'package:sellers/constants/primary_button.dart';
// import 'package:sellers/constants/routes.dart';
// import 'package:sellers/models/product_model.dart';
// import 'package:sellers/providers/app_provider.dart';

// class ProductDetails extends StatefulWidget {
//   final ProductModel singleProduct;

//   const ProductDetails({Key? key, required this.singleProduct})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ProductDetailsState createState() => _ProductDetailsState();
// }

// class _ProductDetailsState extends State<ProductDetails> {
//   int quantity = 1;

//   ScrollController? _scrollController;
//   bool _isScrollDown = false;
//   bool _showAppBar = true;

//   @override
//   void initState() {
//     _scrollController = ScrollController();

//     _scrollController!.addListener(() {
//       if (_scrollController!.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         if (!_isScrollDown) {
//           setState(() {
//             _isScrollDown = true;
//             _showAppBar = false;
//           });
//         }
//       }
//       if (_scrollController!.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         if (_isScrollDown) {
//           setState(() {
//             _isScrollDown = false;
//             _showAppBar = true;
//           });
//         }
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(
//       context,
//     );

//     return Scaffold(
//       appBar: _showAppBar
//           ? AppBar(
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     // Routes.instance
//                     //     .push(widget: const CartScreen(), context: context);
//                   },
//                   icon: const Icon(Icons.shopping_cart),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     FirebaseAuth.instance.signOut();
//                     // Routes.instance
//                     //     .push(widget: const FavoriteScreen(), context: context);
//                   },
//                   icon: const Icon(
//                     Icons.favorite,
//                   ),
//                 ),
//               ],
//             )
//           : null,
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 30),
//         children: [
//           SizedBox(
//             height: 200,
//             width: double.infinity,
//             child: Image.network(
//               widget.singleProduct.image,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.singleProduct.name,
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     widget.singleProduct.isFavorite =
//                         !widget.singleProduct.isFavorite;
//                   });
//                   if (widget.singleProduct.isFavorite) {
//                     appProvider.addToFavoriteproduct(widget.singleProduct);
//                     showMessage('Product added to favorites');
//                   } else {
//                     appProvider.removeFavoriteproduct(widget.singleProduct);
//                     showMessage('Product removed from favorites');
//                   }
//                 },
//                 icon: Icon(
//                   appProvider.getFavoriteProductList
//                           .contains(widget.singleProduct)
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             widget.singleProduct.description,
//             style: const TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           Text(
//             '${widget.singleProduct.quantity.toString()}   items Found',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 12,
//           ),
//           Row(
//             children: [
//               if (quantity > 1)
//                 CupertinoButton(
//                   onPressed: () {
//                     if (quantity > 1) {
//                       setState(() {
//                         quantity--;
//                       });
//                     }
//                   },
//                   padding: EdgeInsets.zero,
//                   child: const CircleAvatar(
//                     maxRadius: 14,
//                     foregroundColor: Colors.white,
//                     backgroundColor: Colors.red,
//                     child: Icon(Icons.remove),
//                   ),
//                 ),
//               Text(
//                 quantity.toString(),
//                 style: const TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               quantity < widget.singleProduct.quantity
//                   ? CupertinoButton(
//                       onPressed: () {
//                         setState(() {
//                           quantity++;
//                         });
//                       },
//                       padding: EdgeInsets.zero,
//                       child: const CircleAvatar(
//                         maxRadius: 14,
//                         foregroundColor: Colors.white,
//                         backgroundColor: Colors.blue,
//                         child: Icon(Icons.add),
//                       ),
//                     )
//                   : SizedBox.fromSize(),
//             ],
//           ),
//           const SizedBox(height: 50),
//           Text('Total price: ${widget.singleProduct.price * quantity}'),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               OutlinedButton(
//                 style: ButtonStyle(
//                     shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)))),
//                 onPressed: () {
//                   AppProvider appProvider = Provider.of(context, listen: false);
//                   ProductModel productModel =
//                       widget.singleProduct.copyWith(quantity: quantity);
//                   appProvider.addToCartproduct(productModel);
//                   showMessage('product added to cart');
//                 },
//                 child: const Text('ADD TO CART'),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               SizedBox(
//                 height: 40,
//                 width: 100,
//                 child: CustomButton(
//                   onPressed: () {
//                     ProductModel productModel =
//                         widget.singleProduct.copyWith(quantity: quantity);
//                     // Routes.instance.push(
//                     //     widget: CheckOutScreen(
//                     //       singleProduct: productModel,
//                     //     ),
//                     //     context: context);
//                   },
//                   title: 'BUY',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:provider/provider.dart';
// import 'package:sellers/constants/constants.dart';
// import 'package:sellers/constants/primary_button.dart';
// import 'package:sellers/constants/routes.dart';
// import 'package:sellers/models/product_model.dart';
// import 'package:sellers/providers/app_provider.dart';
// import 'package:sellers/screens/cart_screen.dart';
// import 'package:sellers/screens/check_out.dart';

// class ProductDetails extends StatefulWidget {
//   final ProductModel singleProduct;

//   const ProductDetails({Key? key, required this.singleProduct})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ProductDetailsState createState() => _ProductDetailsState();
// }

// class _ProductDetailsState extends State<ProductDetails> {
//   int quantity = 1;

//   ScrollController? _scrollController;
//   bool _isScrollDown = false;
//   bool _showAppBar = true;

//   @override
//   void initState() {
//     _scrollController = ScrollController();

//     _scrollController!.addListener(() {
//       if (_scrollController!.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         if (!_isScrollDown) {
//           setState(() {
//             _isScrollDown = true;
//             _showAppBar = false;
//           });
//         }
//       }
//       if (_scrollController!.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         if (_isScrollDown) {
//           setState(() {
//             _isScrollDown = false;
//             _showAppBar = true;
//           });
//         }
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(
//       context,
//     );

//     return Scaffold(
//       appBar: _showAppBar
//           ? AppBar(
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     Routes.instance
//                         .push(widget: const CartScreen(), context: context);
//                   },
//                   icon: const Icon(Icons.shopping_cart),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     FirebaseAuth.instance.signOut();
//                     // Routes.instance
//                     //     .push(widget: const FavoriteScreen(), context: context);
//                   },
//                   icon: const Icon(
//                     Icons.favorite,
//                   ),
//                 ),
//               ],
//             )
//           : null,
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 30),
//         children: [
//           SizedBox(
//             height: 300,
//             width: double.infinity,
//             child: Image.network(
//               widget.singleProduct.image,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.singleProduct.name,
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     widget.singleProduct.isFavorite =
//                         !widget.singleProduct.isFavorite;
//                   });
//                   if (widget.singleProduct.isFavorite) {
//                     appProvider.addToFavoriteproduct(widget.singleProduct);
//                     showMessage('Product added to favorites');
//                   } else {
//                     appProvider.removeFavoriteproduct(widget.singleProduct);
//                     showMessage('Product removed from favorites');
//                   }
//                 },
//                 icon: Icon(
//                   appProvider.getFavoriteProductList
//                           .contains(widget.singleProduct)
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             widget.singleProduct.description!,
//             style: const TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           Row(
//             children: [
//               CupertinoButton(
//                 onPressed: () {
//                   if (quantity >= 1) {
//                     setState(() {
//                       quantity--;
//                     });
//                   }
//                 },
//                 padding: EdgeInsets.zero,
//                 child: const CircleAvatar(
//                   maxRadius: 14,
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.red,
//                   child: Icon(Icons.remove),
//                 ),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               Text(
//                 quantity.toString(),
//                 style: const TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               CupertinoButton(
//                 onPressed: () {
//                   setState(() {
//                     quantity++;
//                   });
//                 },
//                 padding: EdgeInsets.zero,
//                 child: const CircleAvatar(
//                   maxRadius: 14,
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   child: Icon(Icons.add),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 50),
//           Text('Total price: ${widget.singleProduct.price * quantity}'),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               OutlinedButton(
//                 style: ButtonStyle(
//                     shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)))),
//                 onPressed: () {
//                   AppProvider appProvider = Provider.of(context, listen: false);
//                   ProductModel productModel =
//                       widget.singleProduct.copyWith(quantity: quantity);
//                   appProvider.addToCartproduct(productModel);
//                   showMessage('product added to cart');
//                 },
//                 child: const Text('ADD TO CART'),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               SizedBox(
//                 height: 40,
//                 width: 100,
//                 child: CustomButton(
//                   onPressed: () {
//                     ProductModel productModel =
//                         widget.singleProduct.copyWith(quantity: quantity);
//                     Routes.instance.push(
//                         widget: CheckOutScreen(
//                           singleProduct: productModel,
//                         ),
//                         context: context);
//                   },
//                   title: 'BUY',
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//         ],
//       ),
//     );
//   }
// }
