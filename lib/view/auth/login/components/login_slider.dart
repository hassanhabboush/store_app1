import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

import '../../../../services/rtl_service.dart';

class LoginSlider extends StatelessWidget {
  const LoginSlider({
    Key? key,
    required this.title,
  }) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Container(
        color: const Color(0xffF9FAFB),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        height: getScreenHeight(context) / 3.5 - 10,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/hi.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleCommon(ln.getString(ConstString.welcome),
                        fontsize: 18, fontweight: FontWeight.w600),
                    titleCommon(ln.getString(title),
                        fontsize: 20, fontweight: FontWeight.w600),
                  ],
                )
              ],
            ),
            if (Platform.isIOS)
              Padding(
                padding: const EdgeInsets.all(0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Consumer<RtlService>(
                    builder: (context, rtl, child) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: SvgPicture.asset(
                        rtl.rtl == false
                            ? 'assets/svg/arrow-back-circle.svg'
                            : 'assets/svg/arrow-forward-circle.svg',
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
