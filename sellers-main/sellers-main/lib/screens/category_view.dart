// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/theme.dart';
import 'package:sellers/models/catagory_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/widgets/custom_drawer.dart';
import 'package:sellers/widgets/single_category_item.dart';

class CategoryViewScreen extends StatelessWidget {
  static const String id = 'category-view-screen';
  const CategoryViewScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text(
          'Categories',
          style: themeData.appBarTheme.titleTextStyle,
        ),
      ),
      drawer: CustomDrawer(),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          AppProvider appProvider = Provider.of<AppProvider>(context);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                GridView.builder(
                  padding: EdgeInsets.all(12),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: value.getCategoryList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    CategoryModel categoryModel = value.getCategoryList[index];
                    return SingleCategoryItem(
                      singleCategory: categoryModel,
                      index: index,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}








