import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/widgets/single_favorite_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        // foregroundColor: Colors.white,
        title: Text('favorites'.tr),
        actions: const [
          Icon(
            Icons.favorite,
            // color: Colors.white,
          )
        ],
      ),
      body: appProvider.getFavoriteProductList.isEmpty
          ? Center(
              child: Text('emptyFavorite'.tr),
            )
          : ListView.builder(
              itemCount: appProvider.getFavoriteProductList.length,
              itemBuilder: (ctx, index) {
                return SingleFavoriteWidget(
                    singleProduct: appProvider.getFavoriteProductList[index]);
              }),
    );
  }
}
