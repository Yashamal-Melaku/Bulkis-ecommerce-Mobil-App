// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/controllers/firebase_storage_helper.dart';
import 'package:sellers/models/catagory_model.dart';
import 'package:sellers/models/product_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/widgets/custom_drawer.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  final int index;
  const EditProduct(
      {super.key, required, required this.productModel, required this.index});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  // final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Product edit')),
      //  drawer: CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: const CircleAvatar(
                    radius: 55,
                    child: Icon(Icons.camera_alt),
                  ),
                )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Image.file(image!),
                  ),
                ),
          SizedBox(height: 12),
          TextFormField(
            controller: name,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: widget.productModel.name),
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
                hintText: widget.productModel.description),
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
                    hintText: widget.productModel.price.toString(),
                  ),
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
                    hintText: widget.productModel.discount.toString(),
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
                    hintText: widget.productModel.quantity.toString(),
                  ),
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
                    hintText: widget.productModel.size.toString(),
                  ),
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
          SizedBox(
              child: CustomButton(
                  onPressed: () async {
                    () async {
                      if (image == null && name.text.isEmpty) {
                        Navigator.of(context).pop();
                      } else if (image != null) {
                        String imageUrl = await FirebaseStorageHelper.instance
                            .uploadProductImage(widget.productModel.id, image!);
                        ProductModel productModel =
                            widget.productModel.copyWith(
                          image: imageUrl,
                          name: name.text.isEmpty ? null : name.text,
                          description: description.text.isEmpty
                              ? null
                              : description.text,
                          price: price.text.isEmpty
                              ? null
                              : double.parse(price.text),
                          discount: discount.text.isEmpty
                              ? null
                              : double.parse(discount.text),
                          quantity: quantity.text.isEmpty
                              ? null
                              : int.parse(quantity.text),
                        );

                        appProvider.updateProductList(
                            widget.index, productModel);
                        showMessage('Category successfuly updated');
                      } else {
                        ProductModel productModel =
                            widget.productModel.copyWith(
                          name: name.text.isEmpty ? null : name.text,
                          description: description.text.isEmpty
                              ? null
                              : description.text,
                          price: price.text.isEmpty
                              ? null
                              : double.parse(price.text),
                          discount: discount.text.isEmpty
                              ? null
                              : double.parse(discount.text),
                          quantity: quantity.text.isEmpty
                              ? null
                              : int.parse(quantity.text),
                        );

                        appProvider.updateProductList(
                            widget.index, productModel);
                        showMessage('Category successfully updated');
                      }
                      Navigator.of(context).pop();
                      //   appProvider.updateUserInfoFirebase(
                      //   context, userModel, image);
                    };
                  },
                  title: 'Update product')),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
