import 'package:flutter/material.dart';

class CustomPopupMenuButtonWidget<T> extends StatelessWidget {
  const CustomPopupMenuButtonWidget(
      {super.key, this.onSelected, this.icon, required this.itemBuilder});
  final void Function(T)? onSelected;
  final Widget? icon;
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: icon,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: itemBuilder,
      onSelected: onSelected,
    );
  }
}
