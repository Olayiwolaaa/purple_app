import 'package:flutter/material.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:purple_app/size_config.dart';


class PurpleAppButton extends StatelessWidget {
  final VoidCallback onClick;
  final String label;
  final double? width;
  final double? height;
  final Color? textColor;
  final Color background;
  const PurpleAppButton({
    Key? key,
    required this.onClick,
    required this.label,
    this.width,
    this.height,
    this.background = Colors.purple,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Center(
        child: Container(
          width: width ?? screenWidth(context) / 1.9,
          height: height ?? screenAwareSize(75, context),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(label,
                  style: normalTextStyle(context).copyWith(
                    color: textColor ?? Colors.white,
                    fontSize: screenAwareSize(28, context),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
