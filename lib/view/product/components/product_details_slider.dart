import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/product_details_service.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class ProductDetailsSlider extends StatefulWidget {
  const ProductDetailsSlider({Key? key}) : super(key: key);

  @override
  State<ProductDetailsSlider> createState() => _ProductDetailsSliderState();
}

class _ProductDetailsSliderState extends State<ProductDetailsSlider> {
  final PageController _pageController = PageController();
  int _selectedSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsService>(
      builder: (context, provider, child) {
        int galleryLength =
            provider.productDetails?.product?.galleryImages.length ?? 0;
        var galleryImages = provider.productDetails?.product?.galleryImages;

        var slideCountLength = provider.additionalInfoImage == null
            ? (galleryLength == 0 ? 1 : galleryLength)
            : 0;
        var image = provider.productDetails?.product?.image ?? placeHolderUrl;
        return Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 270,
                    child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            _selectedSlide = value;
                          });
                        },
                        itemCount: provider.additionalInfoImage == null
                            ? (galleryLength == 0 ? 1 : galleryLength)
                            : 1,
                        itemBuilder: (context, i) {
                          return CachedNetworkImage(
                            imageUrl: provider.additionalInfoImage == null
                                ? '${galleryLength == 0 ? image : provider.productDetails?.product?.galleryImages[i].image}'
                                : provider.additionalInfoImage.toString(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            placeholder: (context, url) => Icon(
                              Icons.image_outlined,
                              size: 45,
                              color: Colors.grey.withOpacity(.4),
                            ),
                            fit: BoxFit.cover,
                          );
                        }),
                  ),
                ),

                //slider count show
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //if image gallery exists in database then show it, else show only the thumbnail image
                      for (int i = 0; i < slideCountLength; i++)
                        AnimatedContainer(
                          //slider dot /pagination
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: _selectedSlide == i
                                ? primaryColor // change color here to see active dot color
                                : Colors.white,
                          ),
                          width: _selectedSlide == i ? 15 : 6,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                        )
                    ],
                  ),
                ),
              ],
            ),

            //Slider bottom images ===================>
          ],
        );
      },
    );
  }
}
