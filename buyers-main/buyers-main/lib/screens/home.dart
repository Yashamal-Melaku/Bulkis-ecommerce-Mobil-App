// ignore_for_file: prefer_const_constructors

import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/custom_drawer.dart';
import 'package:buyers/widgets/single_category.dart';
import 'package:buyers/widgets/single_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productModelList = [];
  bool isLoding = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoyList();
    // getBestProducts();
    super.initState();
  }

  void getCategoyList() async {
    setState(() {
      isLoding = true;
    });
    FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();
    productModelList.shuffle();
    if (mounted) {
      setState(() {
        isLoding = false;
      });
    }
  }

  TextEditingController search = TextEditingController();
  List<ProductModel> searchList = [];
  void searchProduct(String value) {
    searchList = productModelList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  void getBestProducts() async {
    setState(() {
      isLoding = true;
    });

    productModelList = await FirebaseFirestoreHelper.instance.getBestProducts();

    setState(() {
      isLoding = false;
    });
  }

  final List<Map<String, Object>> locales = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'አማርኛ', 'locale': Locale('am', 'ET')},
    {'name': 'Afaan Oromo ', 'locale': Locale('om', 'ET')},
  ];
  void updateLanguage(Locale local) {
    Get.back();
    Get.updateLocale(local);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('homePage'.tr),
        actions: [
          IconButton(
              onPressed: () {
                print(FirebaseAuth.instance.currentUser!.uid);
              },
              icon: Icon(Icons.add)),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              bool isLightModeEnabled = themeProvider.isLightModeEnabled;
              return IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                icon: Icon(isLightModeEnabled
                    ? Icons.dark_mode
                    : Icons.dark_mode_outlined),
              );
            },
          ),
          PopupMenuButton<Map<String, Object>>(
            icon: Icon(Icons.language),
            itemBuilder: (BuildContext context) => locales.map((locale) {
              return PopupMenuItem(
                value: locale,
                child: GestureDetector(
                    onTap: () {
                      updateLanguage(locale['locale'] as Locale);
                    },
                    child: Text(locale['name'] as String)),
              );
            }).toList(),
          ),
        ],
      ),
      // bottomNavigationBar: CustomBottomBar(),
      drawer: CustomDrawer(),
      body: isLoding
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            child: TextFormField(
                              controller: search,
                              onChanged: (String value) {
                                searchProduct(value);
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: 'search'.tr,
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                            width: double.infinity,
                            child: Divider(
                                //  color: Colors.grey,
                                ),
                          ),
                          Text(
                            'categories'.tr,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              //  color: Colors.blue,
                            ),
                          ),
                          categoriesList.isEmpty
                              ? Center(
                                  child: Text('emptyCategory'.tr),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleCategoryWidget(
                                      categoriesList: categoriesList),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'products'.tr,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              // color: Colors.blue
                            ),
                          ),
                          isSearched()
                              ? Center(
                                  child: Text('noSuchProduct'.tr),
                                )
                              : searchList.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: GridView.builder(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: searchList.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.8,
                                                mainAxisSpacing: 7,
                                                crossAxisSpacing: 20,
                                                crossAxisCount: 2),
                                        itemBuilder: (ctx, index) {
                                          ProductModel singleProduct =
                                              searchList[index];
                                          return SingleProductWidget(
                                              singleProduct: singleProduct);
                                        },
                                      ),
                                    )
                                  : productModelList.isEmpty
                                      ? Center(
                                          child: Text('noProduct'.tr),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: GridView.builder(
                                            padding: const EdgeInsets.only(
                                                bottom: 100),
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: productModelList.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 0.7,
                                                    mainAxisSpacing: 4,
                                                    crossAxisSpacing: 10,
                                                    crossAxisCount: 2),
                                            itemBuilder: (ctx, index) {
                                              ProductModel singleProduct =
                                                  productModelList[index];
                                              return SingleProductWidget(
                                                  singleProduct: singleProduct);
                                            },
                                          ),
                                        ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
