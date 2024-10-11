// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store_app/services/auth_services/login_service.dart';
import 'package:store_app/services/intro_service.dart';
import 'package:store_app/view/home/landing_page.dart';
import 'package:store_app/view/intro/introduction_page.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  loginOrGoHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? keepLogin = prefs.getBool('keepLoggedIn');
    bool? firstRun = prefs.getBool('firstRun');

    if (firstRun == null) {
      //that means user is opening the app for the first time.. so , show the intro
      await Provider.of<IntroService>(context, listen: false)
          .fetchIntro(context);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const IntroductionPage(),
          ),
        );
      });
    } else if (keepLogin == false) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LandingPage(),
          ),
        );
      });
    } else {
      //user logged in with his email and password. so,
      //Try to login with the saved email and password
      debugPrint('trying to log in with email pass');
      String? email = prefs.getString('email');
      String? pass = prefs.getString('pass');
      var result = await Provider.of<LoginService>(context, listen: false)
          .login(email, pass, context, true, isFromLoginPage: false);

      //Whether login failed or succeded, go to home page
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LandingPage(),
        ),
      );
    }
  }
}
