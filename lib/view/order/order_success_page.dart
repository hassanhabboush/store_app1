import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/place_order_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/order/order_details_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../services/product_db_service.dart';
import '../home/landing_page.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orderId =
        Provider.of<PlaceOrderService>(context, listen: false).orderId;
    ProductDbService().emptyCartTable();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon('', context, () {
        Provider.of<BottomNavService>(context, listen: false)
            .setCurrentIndex(0);
        Navigator.pop(context);
      }),
      body: Consumer<TranslateStringService>(
        builder: (context, ln, child) => Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/basket.svg',
                  height: 140,
                ),
                gapH(20),
                Text(
                  ln.getString(ConstString.orderSuccessful) + '!',
                  style: const TextStyle(
                      color: greyPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                gapH(10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: ln.getString(ConstString.orderPlacedIdIs),
                    style: const TextStyle(
                        color: greyParagraph, fontSize: 15, height: 1.4),
                    children: <TextSpan>[
                      TextSpan(
                          text: '  #$orderId',
                          style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                gapH(90)
              ]),
        ),
      ),
      bottomNavigationBar: Consumer<ProfileService>(
        builder: (context, profileProvider, child) => SizedBox(
          height: 75,
          child: Row(children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 20),
              child: borderButtonPrimary(ConstString.backToHome, () {
                Provider.of<BottomNavService>(context, listen: false)
                    .setCurrentIndex(0);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LandingPage()),
                    (Route<dynamic> route) => false);
              }),
            )),
            const SizedBox(
              width: 18,
            ),
            if (profileProvider.profileDetails != null)
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(right: 20, bottom: 20),
                child: buttonPrimary(ConstString.seeOrderDetails, () {
                  // Provider.of<OrderDetailsService>(context, listen: false)
                  //     .fetchOrderDetails(orderId);
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => OrderDetailsPage(
                        orderId: orderId,
                      ),
                    ),
                  );
                }),
              ))
          ]),
        ),
      ),
    );
  }
}
