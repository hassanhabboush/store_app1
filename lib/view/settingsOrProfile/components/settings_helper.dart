import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/auth_services/logout_service.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsHelper {
  borderBold(double marginTop, double marginBottom) {
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      child: const Divider(
        height: 0,
        thickness: 4,
        color: borderColor,
      ),
    );
  }

  settingOption(String icon, String title, VoidCallback pressed) {
    return ListTile(
      onTap: pressed,
      leading: SvgPicture.asset(
        icon,
        height: 23,
      ),
      title: Text(
        title,
        style: const TextStyle(color: greyFour, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 17,
      ),
    );
  }

  logoutPopup(BuildContext context) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<TranslateStringService>(
            builder: (context, ln, child) => Column(
              children: [
                Text(
                  '${ln.getString(ConstString.areYouSure)}?',
                  style: const TextStyle(color: greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: borderButtonPrimary(
                            ln.getString(ConstString.cancel), () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Consumer<LogoutService>(
                      builder: (context, provider, child) => Expanded(
                          child: buttonPrimary(ln.getString(ConstString.logout),
                              () {
                        if (provider.isloading == false) {
                          provider.logout(context);
                        }
                      },
                              isloading:
                                  provider.isloading == false ? false : true)),
                    ),
                  ],
                )
              ],
            ),
          ),
        )).show();
  }
}
