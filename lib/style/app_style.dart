import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purple_app/size_config.dart';
import 'package:sizer/sizer.dart';


Color get appBrandColor => Colors.purple;
Color get scaffoldBackgroundColor => Colors.white;
Color get black => Colors.black;
Color get appCard1 => const Color(0xFFEEF6FF);
Color get appCard2 => const Color(0xFFFFE3E4);
Color get appCard3 => const Color(0xFFD2FFD9);
Color get appCard4 => const Color(0xFFFFF7E0);

class AppImagePaths {
  static const appLogo = "assets/images/purple_app_logo.png";
  static const logoWithNoBg = "assets/images/logo_with_no_bg.png";
  static const onBoardingImageSvg = "assets/images/on_boarding_image.svg";
  static const onBoardingImagePng = "assets/images/on_boarding_image.png";
}


const kInputDecorationPhone = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
  hintText: "Phone Number",
);

const kInputDecorationEmail = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  ),
  hintText: "Email Address",
);

const kDemoImage =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEoquU_cIklohz_9N4zzLRFpAbT2UGxsT_mA&usqp=CAU";

const kYellowPrimary = Color(0XFFECB063);

TextStyle smallTextStyle(BuildContext? context) => const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: UIHelper.kSmallFont,
    fontFamily: "Poppins");
TextStyle normalTextStyle(BuildContext? context) => const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: UIHelper.kMediumFont,
    fontFamily: "Poppins");

TextStyle bigTextStyle(BuildContext? context) => const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: UIHelper.kLargeFont,
    fontFamily: "Poppins");

addVerticalSpacing(double size) {
  return SizedBox(
    height: size,
  );
}

addHorizontalSpacing(double size) {
  return SizedBox(
    width: size,
  );
}
