import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/rtl_service.dart';
import 'package:store_app/services/slider_service.dart';
import 'package:store_app/view/product/products_by_category_page.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

import '../../../services/campaign_service.dart';
import '../../campaigns/campaign_products_by_category.dart';

class SliderHome extends StatelessWidget {
  const SliderHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderService>(
      builder: (context, sliderProvider, child) => sliderProvider
              .sliderImageList.isNotEmpty
          ? Container(
              height: 165,
              margin: const EdgeInsets.only(top: 24),
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: sliderProvider.sliderImageList.length,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  initialPage: 1,
                ),
                itemBuilder: (BuildContext context, int i, int pageViewIndex) =>
                    Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: sliderProvider.sliderImageList[i].image ??
                              placeHolderUrl,
                          placeholder: (context, url) => Icon(
                            Icons.image_outlined,
                            size: 45,
                            color: Colors.grey.withOpacity(.4),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Consumer<RtlService>(
                      builder: (context, rtlP, child) => Positioned(
                          left: rtlP.rtl == false ? 25 : 0,
                          right: rtlP.rtl == false ? 0 : 25,
                          top: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  '${sliderProvider.sliderImageList[i].title}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: greyFour,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  '${sliderProvider.sliderImageList[i].description}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: greyFour,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              if (sliderProvider
                                      .sliderImageList[i].buttonText !=
                                  null)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: whiteColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (sliderProvider
                                              .sliderImageList[i].category ==
                                          null) {
                                        Provider.of<CampaignService>(context,
                                                listen: false)
                                            .fetchCampaignProducts(
                                                context,
                                                sliderProvider
                                                    .sliderImageList[i]
                                                    .campaign);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                const CampaignProductByCategory(
                                              endDate: null,
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductsByCategoryPage(
                                                    categoryName: sliderProvider
                                                        .sliderImageList[i]
                                                        .category,
                                                  )));
                                    },
                                    child: Text(sliderProvider
                                            .sliderImageList[i].buttonText ??
                                        ''))
                            ],
                          )),
                    )
                  ],
                ),
              ),
            )
          : sliderProvider.noItems
              ? const SizedBox()
              : showLoading(primaryColor),
    );
  }
}
