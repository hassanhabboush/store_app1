import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:store_app/services/privacy_terms_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<PrivacyTermsService>(context, listen: false)
        .fetchPrivacyData(context);

    return Scaffold(
      appBar: appbarCommon(ConstString.privacyPolicy, context, (() {
        Navigator.pop(context);
      })),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
          child: Consumer<PrivacyTermsService>(
              builder: (context, v, child) => v.privacyData != null
                  ? Column(children: [
                      HtmlWidget(
                        v.privacyData,
                        textStyle: const TextStyle(
                          color: greyParagraph,
                          height: 1.4,
                          fontSize: 14,
                        ),
                      )
                    ])
                  : Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: showLoading(primaryColor),
                    )),
        ),
      ),
    );
  }
}
