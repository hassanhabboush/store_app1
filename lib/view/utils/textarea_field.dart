import 'package:flutter/material.dart';
import 'package:store_app/view/utils/constant_colors.dart';

class TextareaField extends StatelessWidget {
  const TextareaField({Key? key, this.notesController, this.hintText})
      : super(key: key);
  final notesController;
  final hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: notesController,
        maxLines: 6,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: greyFive),
                borderRadius: BorderRadius.circular(9)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: warningColor)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18)));
  }
}
