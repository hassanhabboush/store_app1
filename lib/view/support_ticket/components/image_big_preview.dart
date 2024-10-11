import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/view/utils/responsive.dart';

class ImageBigPreviewPage extends StatelessWidget {
  const ImageBigPreviewPage({Key? key, this.networkImgLink, this.assetImgLink})
      : super(key: key);

  final networkImgLink;
  final assetImgLink;
  @override
  Widget build(BuildContext context) {
    print('network image $networkImgLink');
    GlobalKey<ScaffoldState> bigPagekey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: bigPagekey,
      // appBar: AppBar(),
      body: Stack(
        children: [
          networkImgLink != null
              ?
              //show network image
              Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: networkImgLink,
                    placeholder: (context, url) {
                      return Image.asset('assets/images/placeholder.png');
                    },
                    height: getScreenHeight(context) - 150,
                    width: getScreenWidth(context),
                    // fit: BoxFit.fitHeight,
                  ),
                )
              : // else show asset image,
              Container(
                  alignment: Alignment.center,
                  child: Image.file(
                    File(assetImgLink),
                    height: getScreenHeight(context) - 150,
                    width: getScreenWidth(context),
                    // fit: BoxFit.cover,
                  )),
        ],
      ),
    );
  }
}
