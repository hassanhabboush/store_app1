import 'package:flutter/material.dart';
import 'package:store_app/services/child_category_service.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class ChildCategories extends StatelessWidget {
  const ChildCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChildCategoryService>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          provider.childCategoryDropdownList.isNotEmpty
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
                      value: provider.selectedChildCategory,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: greyFour),
                      iconSize: 26,
                      elevation: 17,
                      style: const TextStyle(color: greyFour),
                      onChanged: (newValue) {
                        provider.setChildCategoryValue(newValue);

                        // setting the id of selected value
                        provider.setSelectedChildCategoryId(
                            provider.childCategoryDropdownIndexList[provider
                                .childCategoryDropdownList
                                .indexOf(newValue)]);

                        //fetch states based on selected country
                        // provider.fetchStates(
                        //     provider.selectedCountryId, context);
                      },
                      items: provider.childCategoryDropdownList
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
