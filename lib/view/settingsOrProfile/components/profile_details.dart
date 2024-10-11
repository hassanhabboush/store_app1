import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/services/common_service.dart';
import 'package:store_app/services/profile_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/auth/login/login.dart';
import 'package:store_app/view/settingsOrProfile/components/settings_helper.dart';
import 'package:store_app/view/settingsOrProfile/profile_edit_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslateStringService>(
      builder: (context, ln, child) => Consumer<ProfileService>(
          builder: (context, profileProvider, child) => profileProvider
                      .profileDetails !=
                  null
              ? Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenPadHorizontal),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //profile image, name ,desc
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                //Profile image section =======>
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const ProfileEditPage(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //profile image
                                      profileImage(
                                          profileProvider
                                                  .profileDetails
                                                  ?.userDetails
                                                  .profileImageUrl ??
                                              userPlaceHolderUrl,
                                          62,
                                          62),

                                      const SizedBox(
                                        width: 15,
                                      ),

                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 12,
                                                ),

                                                //user name
                                                titleCommon(profileProvider
                                                        .profileDetails
                                                        ?.userDetails
                                                        .name ??
                                                    ''),

                                                //phone
                                                paragraphCommon(
                                                  ln.getString(ConstString
                                                          .memberSince) +
                                                      ' ${getDateOnly(profileProvider.profileDetails?.userDetails.createdAt) ?? '-'}',
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              width: 15,
                                            ),

                                            //profile edit button
                                            Container(
                                              height: 32,
                                              width: 56,
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: primaryColor,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/svg/edit.svg',
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            //
                          ]),
                    ),

                    // Personal information ==========>
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenPadHorizontal),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapH(30),
                            bRow(
                              ln.getString(ConstString.phone),
                              '${profileProvider.profileDetails?.userDetails.mobile}',
                              icon: 'assets/svg/phone.svg',
                            ),
                            bRow(
                              ln.getString(ConstString.email),
                              '${profileProvider.profileDetails?.userDetails.email}',
                              icon: 'assets/svg/email.svg',
                            ),
                            bRow(
                                ln.getString(ConstString.country),
                                profileProvider.profileDetails?.userDetails
                                        .userCountry?.name ??
                                    "-",
                                icon: 'assets/svg/location.svg',
                                lastItem: true),
                          ]),
                    ),

                    SettingsHelper().borderBold(35, 8),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/notlogin.png',
                          height: 160,
                        ),
                      ),
                      gapH(6),
                      titleCommon(ln.getString(ConstString.notLoggedIn)),
                      gapH(5),
                      paragraphCommon(
                          ln.getString(ConstString.accountInfoNotAvailable)),
                      gapH(15),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: buttonPrimary(ConstString.login, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        }),
                      )
                    ],
                  ),
                )),
    );
  }
}
