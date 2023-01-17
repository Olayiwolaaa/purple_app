import 'package:flutter/material.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/functions.dart';
import 'package:purple_app/size_config.dart';

class PurpleAppCard extends StatelessWidget {
  final String? label;
  final String? num;
  final Color? colour;
  final page;

  const PurpleAppCard({Key? key, this.label, this.num, this.colour, this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToRoute(context, page),
      child: Container(
          height: 70,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                  "assets/images/curly_path.png",
                ),
                opacity: 0.3,
              ),
              color: colour,),
          child: Center(
            child: Text(
              '$label',
              style: normalTextStyle(context)
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
            ),
          )),
    );
  }
}
