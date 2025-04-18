import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/category_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCategoryWidget extends StatelessWidget {
  const SingleCategoryWidget({
    super.key,
    required this.categoriesList,
  });

  final List<CategoryModel> categoriesList;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    bool isLightModeEnabled = themeProvider.isLightModeEnabled;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categoriesList
          .map(
            (category) => Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Column(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Routes.instance.push(
                          widget: CategoryView(categoryModel: category),
                          context: context);
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          // backgroundColor:
                          //  Colors.white,
                          radius: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 65,
                                width: 65,
                                child: ClipOval(
                                  child: Image.network(
                                    category.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 10,
                          child: Container(
                            width: 70,
                            height: 20,
                            color: isLightModeEnabled
                                ? Colors.white
                                : Colors.grey.shade700,
                            alignment: Alignment.center,
                            child: Text(category.name,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                  letterSpacing: 1,

                                  color: isLightModeEnabled
                                      ? Colors.black
                                      : Colors.white,

                                  //  color: Colors
                                  // .black
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
