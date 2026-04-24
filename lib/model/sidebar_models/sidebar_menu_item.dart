// models/sidebar_menu_item.dart
import 'package:flutter/material.dart';

class SidebarMenuItem {
  final String id;
  final String title;
  final String iconPath;
  final String selectedIconPath;
  final Widget? defaultPage;
  final List<SidebarSubMenuItem> subItems;
  final bool requiresConfirmation;
  final double? iconWidth;
  final double? iconHeight;
  final double? iconPadding;

  SidebarMenuItem({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.selectedIconPath,
    this.defaultPage,
    this.subItems = const [],
    this.requiresConfirmation = false,
    this.iconWidth,
    this.iconHeight,
    this.iconPadding,
  });
}

class SidebarSubMenuItem {
  final String id;
  final String title;
  final Widget page;
  final bool requiresConfirmation;

  SidebarSubMenuItem({
    required this.id,
    required this.title,
    required this.page,
    this.requiresConfirmation = false,
  });
}
