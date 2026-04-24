import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String? shortcutText;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double width;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? focusColor;

  const CustomActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.shortcutText,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFF28328B), // primaryColor
    this.textColor = Colors.white,
    this.height = 38,
    this.width = 140,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.focusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        focusColor: focusColor,
        onTap: isLoading ? null : onPressed,
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: textColor,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          fontWeight: fontWeight,
                        ),
                      ),
                      if (shortcutText != null)
                        Text(
                          " ($shortcutText)",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: textColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
