import 'package:flutter/material.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../../services/product_details_service.dart';

class ColorAndSize extends StatefulWidget {
  const ColorAndSize({Key? key}) : super(key: key);

  @override
  State<ColorAndSize> createState() => _ColorAndSizeState();
}

class _ColorAndSizeState extends State<ColorAndSize> {
  int selectedColor = -1;
  int selectedSize = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
      builder: (context, pdProvider, child) => Row(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pdProvider.inventoryKeys == null
                  ? [const SizedBox()]
                  : pdProvider.inventoryKeys
                      .map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              paragraphCommon(
                                  ('${e.replaceFirst('_code', ' ')}:')
                                      .capitalize()),
                              const SizedBox(
                                height: 12,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffF2F4F7),
                                    borderRadius: BorderRadius.circular(30)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: generateDynamicAttrribute(
                                            context,
                                            pdProvider,
                                            e,
                                            pdProvider.allAtrributes[e]))),
                              ),
                              // gapH(15),
                            ],
                          ))
                      .toList()),
        ],
      ),
    );
  }

  List<Widget> generateDynamicAttrribute(BuildContext context,
      ProductDetailsService pdService, fieldName, mapdata) {
    RegExp hex = RegExp(
        r'^#([\da-f]{3}){1,2}$|^#([\da-f]{4}){1,2}$|(rgb|hsl)a?\((\s*-?\d+%?\s*,){2}(\s*-?\d+%?\s*,?\s*\)?)(,\s*(0?\.\d+)?|1)?\)');

    List<Widget> list = [];
    String value = '';
    final keys = mapdata.keys;
    for (var elemnt in keys) {
      list.add(
        GestureDetector(
          onTap: () {
            if (pdService.selectedAttributes.contains(elemnt)) {
              return;
            }
            if (!pdService.isInSet(fieldName, elemnt, mapdata[elemnt])) {
              pdService.clearSelection();
            }
            pdService.setProductInventorySet(mapdata[elemnt]);
            value = elemnt;
            manageInventorySet(pdService, elemnt);
            pdService.addSelectedAttribute(elemnt);
            pdService.addAdditionalPrice();
          },
          child: hex.hasMatch(elemnt)
              ? colorBox(context, pdService, fieldName, elemnt, mapdata)
              : Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: pdService.isASelected(elemnt)
                              ? primaryColor
                              : Colors.white,
                          border: Border.all(
                              color: pdService.isASelected(elemnt)
                                  ? Colors.transparent
                                  : greyFive,
                              width: .5)),
                      child: Text(
                        elemnt,
                        style: TextStyle(
                            color: pdService.isASelected(elemnt)
                                ? Colors.white
                                : blackCustomColor),
                      ),
                    ),
                    if (!pdService.isInSet(fieldName, elemnt, mapdata[elemnt]))
                      Container(
                        margin: const EdgeInsets.all(3),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white60),
                        child: Text(
                          elemnt,
                          style: const TextStyle(color: Colors.transparent),
                        ),
                      )
                  ],
                ),
        ),
      );
    }
    return list;
  }

  manageInventorySet(
    ProductDetailsService pdService,
    selectedValue,
  ) {
    final selectedInventorySetIndex = pdService.selectedInventorySetIndex;
    final allAtrributes = pdService.allAtrributes;
    setProductInventorySet(List<String>? value) {
      // print(
      //     selectedInventorySetIndex.toString() + 'inven........................');
      // print(value.toString() + 'val........................');

      if (selectedInventorySetIndex != value) {
        // if (value!.length == 1) {
        //   selectedInventorySetIndex = value;selectedValue
        // print(selectedInventorySetIndex);
        for (var element in pdService.inventoryKeys) {
          if (selectedValue != null) {
            selectedValue = pdService.deselect(
                    value, allAtrributes[element]![selectedValue])
                ? selectedValue
                : null;
          }
        }
      }
      if (selectedInventorySetIndex.isEmpty) {
        pdService.selectedInventorySetIndex = value ?? [];

        return;
      }
      if (selectedInventorySetIndex.isNotEmpty &&
          selectedInventorySetIndex.length > value!.length) {
        pdService.selectedInventorySetIndex = value;
        return;
      }
    }
  }

  Widget colorBox(BuildContext context, ProductDetailsService pdService,
      fieldName, value, mapdata) {
    final color = value.replaceAll('#', '0xff');
    return Stack(
      children: [
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(int.parse(color)),
          ),
          child: Icon(
            pdService.isASelected(value) ? Icons.check : null,
            color: Colors.white,
            size: 20,
          ),
        ),
        if (!pdService.isInSet(fieldName, value, mapdata[value]))
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white60,
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.transparent),
            ),
          )
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
