import 'package:flutter/material.dart';

class CommonFilterWidget extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry> menuItems;
  final Color? popupBackgroundColor;
  final Offset offset;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final Color? focusColor;
  final double iconSize;

  const CommonFilterWidget({
    super.key,
    required this.child,
    required this.menuItems,
    this.popupBackgroundColor = Colors.transparent,
    this.offset = const Offset(0, 45),
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.focusColor,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          focusColor: focusColor ?? Theme.of(context).focusColor,
          tooltipTheme: const TooltipThemeData(
            textStyle: TextStyle(color: Colors.transparent),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
        child: PopupMenuButton(
          offset: offset,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          color: popupBackgroundColor,
          elevation: elevation,
          itemBuilder: (context) => menuItems,
          child: child,
        ),
      ),
    );
  }
}
