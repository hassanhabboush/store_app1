import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/view/checkout/components/cart_icon.dart';
import 'package:store_app/view/home/components/category_modal.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class HomeTop extends StatelessWidget {
  const HomeTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<ProfileService>(
          builder: (context, profileProvider, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  profileProvider.profileDetails != null
                      ? Expanded(
                          child: InkWell(
                            onTap: () {
                              Provider.of<BottomNavService>(context,
                                      listen: false)
                                  .setCurrentIndex(3);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                children: [
                                  //name
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${ln.getString(ConstString.hi)}' ',',
                                        style: const TextStyle(
                                          color: greyParagraph,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        profileProvider.profileDetails
                                                ?.userDetails.name ??
                                            '',
                                        style: const TextStyle(
                                          color: blackCustomColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      gapH(12)
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return const CategoryModal();
                                });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            child: SvgPicture.asset(
                              'assets/svg/category-2.svg',
                              height: 25,
                            ),
                          ),
                        ),
                  Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: const CartIcon()),
                ],
              )),
    );
  }
}
