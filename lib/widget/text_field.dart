import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purple_app/style/app_style.dart';
import 'package:sizer/sizer.dart';
import 'package:purple_app/size_config.dart';

class PurpleAppTextField extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final Function()? onTap;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Function? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;
  final TextInputFormatter? formatter;
  final bool? isEnabled;
  final int? maxLength;
  const PurpleAppTextField({
    Key? key,
    required this.label,
    this.prefixIcon,
    this.maxLength,
    this.onTap,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.onChanged,
    this.formatter,
    this.validator,
    this.textEditingController,
    this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: normalTextStyle(context).copyWith(
              fontWeight: FontWeight.w900,
              fontSize: screenAwareSize(22, context)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: SizedBox(
            child: Material(
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: TextFormField(
                // autovalidateMode: AutovalidateMode.always,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                enabled: isEnabled,
                onTap: onTap,
                // maxLength: maxLength,
                controller: textEditingController!,
                cursorColor: appBrandColor,
                cursorWidth: 0.7,
                keyboardType: keyboardType,
                obscureText: obscureText ?? false,
                onChanged: (text) {
                  if (onChanged != null) onChanged!(text);
                },
                validator: validator,
                inputFormatters: [
                  formatter ?? FilteringTextInputFormatter.singleLineFormatter
                ],
                style: normalTextStyle(context),
                decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding: const EdgeInsets.only(
                      left: 15.0,
                      top: 19.0,
                    ),
                    // prefixIcon: Padding(
                    //     padding: const EdgeInsets.all(13.0), child: prefixIcon),
                    suffixIcon: suffixIcon,
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: appBrandColor, width: 0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: appBrandColor, width: 0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: appBrandColor, width: 0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
          ),
        )
      ],
    );
  }
}
