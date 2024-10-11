import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/cart_services/delivery_address_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/order/delivery_address_page.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class ShippingSelect extends StatelessWidget {
  const ShippingSelect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressService>(
      builder: (context, dProvider, child) => Consumer<TranslateStringService>(
        builder: (context, ln, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ln.getString(ConstString.shippingOption),
                    style: const TextStyle(
                      color: greyParagraph,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const DeliveryAddressPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 9),
                      child: Text(
                        ln.getString(ConstString.addDeliveryAddress),
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                dProvider.selectedShipName,
                maxLines: 1,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: greyFour,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
