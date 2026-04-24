import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class CustomInkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final Color? focusColor;
  final bool autofocus;
  final KeyEventResult Function(KeyEvent)? onKeyEvent;

  const CustomInkButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = primaryColor,
    this.textColor = Colors.white,
    this.height = 38,
    this.width = 140,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.all(8),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.isLoading = false,
    this.focusColor = secondaryColor,
    this.autofocus = false,
    this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusColor: focusColor,
        autofocus: autofocus,
        onTap: isLoading ? null : onPressed, // Disable onTap when loading
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
          child: Center(
            child:
                isLoading
                    ? SizedBox(
                      height: fontSize, // Match the size with text
                      width: fontSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                    : Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                        fontWeight: fontWeight,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
