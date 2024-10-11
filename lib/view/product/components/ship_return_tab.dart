import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:provider/provider.dart';

class ShipReturnTab extends StatelessWidget {
  const ShipReturnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlWidget(
              provider.productDetails?.returnPolicy.shippingReturnDescription ??
                  '')
        ],
      ),
    );
  }
}
