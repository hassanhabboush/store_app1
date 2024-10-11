import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/services/rtl_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

//common appbar
appbarCommon(String title, BuildContext context, VoidCallback pressed,
    {bool hasBackButton = true, bool centerTitle = true, actions}) {
  return AppBar(
    centerTitle: centerTitle ? true : false,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    iconTheme: const IconThemeData(color: greyPrimary),
    title: Consumer<TranslateStringService>(
      builder: (context, ln, child) => Text(
        ln.getString(title),
        style: const TextStyle(
            color: greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: actions,
    leadingWidth: 75,
    leading: hasBackButton
        ? InkWell(
            onTap: pressed,
            child: Consumer<RtlService>(
              builder: (context, rtl, child) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  rtl.rtl == false
                      ? 'assets/svg/arrow-back-circle.svg'
                      : 'assets/svg/arrow-forward-circle.svg',
                  height: 40,
                ),
              ),
            ),
          )
        : Container(),
  );
}

labelCommon(String title) {
  return Consumer<TranslateStringService>(
    builder: (context, ln, child) => Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
        ln.getString(title),
        style: const TextStyle(
          color: greyThree,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

//common primary button =======>
buttonPrimary(String title, VoidCallback pressed,
    {isloading = false,
    bgColor,
    double paddingVertical = 18,
    double borderRadius = 8,
    double fontsize = 14,
    fontColor = Colors.white}) {
  return InkWell(
    onTap: pressed,
    child: Consumer<TranslateStringService>(
      builder: (context, ln, child) => Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: paddingVertical),
          decoration: BoxDecoration(
              color: bgColor ?? primaryColor,
              borderRadius: BorderRadius.circular(borderRadius)),
          child: isloading == false
              ? Text(
                  ln.getString(title),
                  style: TextStyle(
                    color: fontColor,
                    fontSize: fontsize,
                  ),
                )
              : showLoading(Colors.white)),
    ),
  );
}

borderButtonPrimary(
  String title,
  VoidCallback pressed, {
  double paddingVertical = 17,
  double fontsize = 14,
  double borderRadius = 8,
  Color color = Colors.grey,
  Color borderColor = Colors.grey,
}) {
  return InkWell(
    onTap: pressed,
    child: Consumer<TranslateStringService>(
      builder: (context, ln, child) => Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: paddingVertical),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Text(
            ln.getString(title),
            style: TextStyle(
              color: color,
              fontSize: fontsize,
            ),
          )),
    ),
  );
}

paragraphCommon(String title,
    {TextAlign textAlign = TextAlign.center,
    double fontsize = 14,
    fontweight = FontWeight.w400,
    double lineHeight = 1.4,
    color}) {
  return Text(
    title,
    textAlign: textAlign,
    style: TextStyle(
      color: color ?? greyParagraph,
      height: lineHeight,
      fontSize: fontsize,
      fontWeight: fontweight,
    ),
  );
}

titleCommon(String title,
    {double fontsize = 18, fontweight = FontWeight.bold, color}) {
  return Text(
    title,
    style: TextStyle(
        color: color ?? greyPrimary,
        fontSize: fontsize,
        fontWeight: fontweight),
  );
}

dividerCommon() {
  return const Divider(
    thickness: 1,
    height: 2,
    color: borderColor,
  );
}

checkCircle() {
  return Container(
    padding: const EdgeInsets.all(3),
    decoration:
        const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
    child: const Icon(
      Icons.check,
      size: 13,
      color: Colors.white,
    ),
  );
}

profileImage(String imageLink, double height, double width) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(500),
    child: CachedNetworkImage(
      imageUrl: imageLink,
      placeholder: (context, url) {
        return Image.asset('assets/images/placeholder.png');
      },
      height: height,
      width: width,
      fit: BoxFit.cover,
    ),
  );
}

//no order found
nothingfound(BuildContext context, String title) {
  return Consumer<TranslateStringService>(
    builder: (context, ln, child) => Container(
      alignment: Alignment.center,
      height: getScreenHeight(context) - 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hourglass_empty,
            color: greyFour,
          ),
          gapH(10),
          Text(ln.getString(title)),
        ],
      ),
    ),
  );
}
