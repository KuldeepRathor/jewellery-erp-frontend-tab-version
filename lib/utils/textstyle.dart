// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final Color? decorationColor;
  final int? maxLines;
  final TextDecoration? decoration;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.decorationColor,
    this.fontWeight,
    this.textAlign,
    this.fontStyle,
    this.overflow,
    this.maxLines,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color ?? primaryTextColor,
        fontSize: fontSize ?? 14.0,
        fontFamily: fontFamily ?? 'Satoshi',
        fontWeight: fontWeight ?? FontWeight.w500,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: decoration,
        decorationColor: decorationColor,
      ),
    );
  }
}

class CustomTextExpanded extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final int flex;

  const CustomTextExpanded({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.textAlign,
    this.fontStyle,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: color ?? primaryTextColor,
          fontSize: fontSize ?? 14.0,
          fontFamily: fontFamily ?? 'Satoshi',
          fontWeight: fontWeight ?? FontWeight.w500,
          fontStyle: fontStyle ?? FontStyle.normal,
        ),
      ),
    );
  }
}
