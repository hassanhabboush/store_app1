import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/services/search_product_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/search/components/product_filter.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Consumer<TranslateStringService>(
        builder: (context, ln, child) => Consumer<SearchProductService>(
          builder: (context, provider, child) => Row(
            children: [
              //Search bar and dropdown
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  autofocus: true,
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      provider.searchProducts(context, isSearching: true);
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      provider.setSearchText(value);
                      provider.searchProducts(context, isSearching: true);
                    }
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    hintText: ln.getString(ConstString.search),
                    hintStyle: TextStyle(color: greyPrimary.withOpacity(.8)),
                    contentPadding: const EdgeInsets.fromLTRB(18, 15, 10, 15),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: inputFieldBorderColor),
                        borderRadius: BorderRadius.circular(7)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(7)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: warningColor)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(7)),
                  ),
                ),
              ),

              gapW(10),

              productFilterIcon(context),
            ],
          ),
        ),
      ),
    );
  }
}

InkWell productFilterIcon(BuildContext context) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) => const ProductFilter(),
      );
    },
    child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: inputFieldBorderColor)),
        child: SvgPicture.asset(
          'assets/svg/filter.svg',
          height: 23,
        )),
  );
}
