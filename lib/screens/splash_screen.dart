import 'package:flutter/material.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/screens/on_boarding_ui.dart';
import 'package:purple_app/size_config.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<dynamic> _navigateToOnBoarding() {
    return Future.delayed(const Duration(seconds: 3), () {
      navigateAndRemoveUntilRoute(context, const PurpleAppOnboading());
    });
  }

  @override
  void initState() {
    _navigateToOnBoarding();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImagePaths.appLogo,
              width: screenHeight(context) / 4.5,
              height: screenHeight(context) / 4.5,
            ),
          ],
        ),
      ),
    );
  }
}