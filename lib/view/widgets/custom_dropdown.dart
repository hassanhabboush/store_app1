import 'package:flutter/material.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    this.onChange,
    this.items,
    this.width,
    this.value,
    this.labelText,
  }) : super(key: key);

  final Function(String?)? onChange;
  final List<String>? items;
  final String? value;
  final double? width;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelCommon(labelText ?? ''),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: greyFive),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: greyFour),
              iconSize: 26,
              elevation: 17,
              style: const TextStyle(color: greyFour),
              onChanged: onChange,
              items: items?.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: greyPrimary.withOpacity(.8)),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
