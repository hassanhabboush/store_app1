import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../home/landing_page.dart';

class OrderFailedPage extends StatelessWidget {
  const OrderFailedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon('', context, () {
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
                  'assets/svg/cancelled.svg',
                  height: 100,
                ),
                gapH(20),
                Text(
                  ln.getString(ConstString.oops) + '!',
                  style: const TextStyle(
                      color: greyPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                gapH(10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: ln.getString(ConstString.orderFailed),
                    style: const TextStyle(
                        color: greyParagraph, fontSize: 15, height: 1.4),
                  ),
                ),
                gapH(90)
              ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 55,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: buttonPrimary(ConstString.backToHome, () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LandingPage()),
              (Route<dynamic> route) => false);
        }),
      ),
    );
  }
}
