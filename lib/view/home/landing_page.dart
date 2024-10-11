// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:store_app/services/bottom_nav_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/discover/discover_page.dart';
import 'package:store_app/view/favourite/favourite_item_list_page.dart';
import 'package:store_app/view/home/home.dart';
import 'package:store_app/view/settingsOrProfile/settings_page.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../utils/others_helper.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    DiscoverPage(),
    FavouriteItemListPage(),
    SettingsPage()
  ];

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          final tlsProvider =
              Provider.of<TranslateStringService>(context, listen: false);
          showToast(tlsProvider.getString(ConstString.pressAgainToExit),
              Colors.black);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<BottomNavService>(
          builder: (context, provider, child) => Center(
            child: _widgetOptions.elementAt(provider.currentIndex),
          ),
        ),
        bottomNavigationBar: Consumer<TranslateStringService>(
          builder: (context, ln, child) => Consumer<BottomNavService>(
            builder: (context, bottomNavProvider, child) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: primaryColor,
                    color: Colors.black,
                    tabs: [
                      GButton(
                        icon: Icons.home_outlined,
                        text: ln.getString(ConstString.home),
                        iconColor: greyParagraph,
                      ),
                      GButton(
                        icon: Icons.album_outlined,
                        text: ln.getString(ConstString.discover),
                        iconColor: greyParagraph,
                      ),
                      GButton(
                        icon: Icons.favorite_outline,
                        text: ln.getString(ConstString.likes),
                        iconColor: greyParagraph,
                      ),
                      GButton(
                        icon: Icons.settings_outlined,
                        text: ln.getString(ConstString.menu),
                        iconColor: greyParagraph,
                      ),
                    ],
                    selectedIndex: bottomNavProvider.currentIndex,
                    onTabChange: (index) {
                      Provider.of<BottomNavService>(context, listen: false)
                          .setCurrentIndex(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
