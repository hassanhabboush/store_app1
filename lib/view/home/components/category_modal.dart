import 'package:flutter/material.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/view/product/products_by_category_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class CategoryModal extends StatelessWidget {
  const CategoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Consumer<CategoryService>(
            builder: (context, cp, child) => cp.categoryHome.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < cp.categoryHome.length; i++)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductsByCategoryPage(
                                          categoryName: cp.categoryHome[i].name,
                                        )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: paragraphCommon(
                                    cp.categoryHome[i].name ?? '',
                                    textAlign: TextAlign.left),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: greyFour,
                              )
                            ],
                          ),
                        )
                    ],
                  )
                : Container()),
      ),
    );
  }
}
