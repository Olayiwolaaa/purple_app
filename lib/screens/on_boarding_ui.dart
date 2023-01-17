import 'package:flutter/material.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/screens/sign_in.dart';
import 'package:purple_app/size_config.dart';
import 'package:purple_app/widget/button.dart';

class PurpleAppOnboading extends StatefulWidget {
  const PurpleAppOnboading({super.key});

  @override
  State<PurpleAppOnboading> createState() => _PurpleAppOnboadingState();
}

class _PurpleAppOnboadingState extends State<PurpleAppOnboading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: screenAwareSize(90, context),
                width: screenAwareSize(90, context),
                child: Image.asset(
                  AppImagePaths.appLogo,
                  width: screenHeight(context) / 5,
                  height: screenHeight(context) / 5,
                ),
              ),
            )),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              addVerticalSp(50.0),
              Text('Welcome \nto the \nPurple App',
                  textAlign: TextAlign.center,
                  style: bigTextStyle(context).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 50,
                      letterSpacing: -2)),
              addVerticalSp(100.0),
              PurpleAppButton(
                onClick: () {
                  navigateToRoute(context, SignIn());
                },
                label: "Continue",
                width: MediaQuery.of(context).size.width / 1.30,
                height: MediaQuery.of(context).size.height / 14,
              )
            ],
          ),
        ));
  }
}
