import 'package:flutter/material.dart';
import 'package:store_app/services/category_service.dart';
import 'package:store_app/services/subcategory_service.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          provider.categoryDropdownList.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyFive),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      // menuMaxHeight: 200,
                      isExpanded: true,
                      value: provider.selectedCategory,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: greyFour),
                      iconSize: 26,
                      elevation: 17,
                      style: const TextStyle(color: greyFour),
                      onChanged: (newValue) {
                        provider.setCategoryValue(newValue);

                        // setting the id of selected value
                        provider.setSelectedCategoryId(provider
                                .categoryDropdownIndexList[
                            provider.categoryDropdownList.indexOf(newValue)]);

                        //fetch states based on selected country
                        Provider.of<SubCategoryService>(context, listen: false)
                            .fetchSubCategory(context);
                      },
                      items: provider.categoryDropdownList
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(color: greyPrimary.withOpacity(.8)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [showLoading(primaryColor)],
                ),
        ],
      ),
    );
  }
}
