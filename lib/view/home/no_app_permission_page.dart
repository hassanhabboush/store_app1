import 'package:flutter/material.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/responsive.dart';

class NoAppPermissionPage extends StatelessWidget {
  const NoAppPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenPadHorizontal),
        alignment: Alignment.center,
        height: getScreenHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.api,
              size: 50,
              color: greyFour,
            ),
            gapH(10),
            paragraphCommon(
                'You do not have permission to use mobile app API. Kindly upgrade your plan',
                fontsize: 15)
          ],
        ),
      ),
    );
  }
}
