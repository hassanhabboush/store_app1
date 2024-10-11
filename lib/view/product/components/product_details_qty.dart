import 'package:flutter/material.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class ProductDetailsQty extends StatelessWidget {
  const ProductDetailsQty({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
      builder: (context, pProvider, child) => Row(
        children: [
          Container(
            width: 120,
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //decrease quanity
                InkWell(
                  onTap: () {
                    pProvider.decreaseQty();
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.2),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      color: Colors.black.withOpacity(.5),
                      size: 19,
                    ),
                  ),
                ),

                //Quantity text
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${pProvider.qty}',
                      style: const TextStyle(
                          color: greyPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),

                //increase quantity
                InkWell(
                  onTap: () {
                    pProvider.increaseQty();
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.2),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: Colors.black.withOpacity(.5),
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
