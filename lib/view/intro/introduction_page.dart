import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/services/intro_service.dart';
import 'package:store_app/services/translate_string_service.dart';
import 'package:store_app/view/home/landing_page.dart';
import 'package:store_app/view/utils/common_helper.dart';
import 'package:store_app/view/utils/config.dart';
import 'package:store_app/view/utils/const_strings.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  int _selectedSlide = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<IntroService>(
          builder: (context, v, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: getScreenHeight(context) - 170,
                  alignment: Alignment.center,
                  child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _selectedSlide = value;
                        });
                      },
                      itemCount: v.introDataList.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: double.infinity,
                                height: getScreenHeight(context) <
                                        fourinchScreenHeight
                                    ? 60
                                    : 180,
                                margin: const EdgeInsets.only(bottom: 24),
                                child: CachedNetworkImage(
                                  imageUrl: v.introDataList[i]['image'] ??
                                      placeHolderUrl,
                                  placeholder: (context, url) => Icon(
                                    Icons.image_outlined,
                                    size: 45,
                                    color: Colors.grey.withOpacity(.4),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Text(
                                v.introDataList[i]['title'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: greyPrimary,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 7,
                              ),

                              // Subtitle =============>
                              paragraphCommon(
                                  v.introDataList[i]['description'].toString(),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<TranslateStringService>(
          builder: (context, ln, child) => Consumer<IntroService>(
            builder: (context, v, child) => Column(children: [
              //slider count show =======>
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < v.introDataList.length; i++)
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 16,
                      width: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _selectedSlide == i
                                  ? primaryColor
                                  : Colors.transparent),
                          shape: BoxShape.circle),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: _selectedSlide == i
                                ? primaryColor
                                : const Color(0xffD0D5DD),
                            shape: BoxShape.circle),
                      ),
                    )
                ],
              ),

              //buttons
              const SizedBox(
                height: 42,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LandingPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          ln.getString(ConstString.skip),
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (_selectedSlide == v.introDataList.length - 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingPage()));
                        } else {
                          _pageController.animateToPage(_selectedSlide + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        }
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            ln.getString(ConstString.continueText),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
