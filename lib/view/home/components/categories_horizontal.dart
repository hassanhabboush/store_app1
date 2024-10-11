import 'package:flutter/material.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/view/product/products_by_category_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:provider/provider.dart';

class CategoriesHorizontal extends StatelessWidget {
  const CategoriesHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
      builder: (context, cp, child) => cp.categoryHome.isNotEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 5),
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < cp.categoryHome.length; i++)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsByCategoryPage(
                                      categoryName: cp.categoryHome[i].name,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: Colors.grey.withOpacity(.4))),
                        child: paragraphCommon(cp.categoryHome[i].name ?? ''),
                      ),
                    )
                ],
              ),
            )
          : Container(),
    );
  }
}
