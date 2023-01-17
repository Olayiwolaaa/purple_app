import 'package:flutter/material.dart';

class PurpleAppElevatedButton extends StatelessWidget {
  final Widget? elevatedButton;
  final double? height;
  final card;

  const PurpleAppElevatedButton({
    Key? key,
    required this.elevatedButton,
    this.height,
    this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          padding: EdgeInsets.all(0),
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: height == null ? 500 : height,
                  color: Color(0xFF737373),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: elevatedButton,
                    ),
                  ),
                );
              });
        },
        child: card);
  }
}
