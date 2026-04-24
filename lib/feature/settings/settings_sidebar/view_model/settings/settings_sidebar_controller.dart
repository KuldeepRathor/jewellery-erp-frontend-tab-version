// feature/settings/global_settings/view_model/global_settings_sidebar_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';

class SettingsSidebarController extends GetxController {
  RxBool isExpanded = false.obs; // Start collapsed by default
  RxString selectedMenuId = "".obs;
  RxMap<String, bool> expandedMenus = <String, bool>{}.obs;
  final selectedWidget = RxList<Widget>([]);

  final List<SidebarMenuItem> menuItems;

  SettingsSidebarController({required this.menuItems}) {
    // Set initial view to the first menu item's default page
    if (menuItems.isNotEmpty) {
      final firstItem = menuItems.first;
      selectedMenuId.value = firstItem.id;

      if (firstItem.defaultPage != null) {
        selectedWidget.assignAll([firstItem.defaultPage!]);
      }
    }
  }

  void toggleSidebar() {
    isExpanded.value = !isExpanded.value;
  }

  // Add this method for hover functionality
  void toggleSidebarOnHover() {
    isExpanded.value = !isExpanded.value;
  }

  void selectMenuItem(String menuId) {
    // Find the menu item
    final menuItem = menuItems.firstWhereOrNull((item) => item.id == menuId);
    if (menuItem == null) return;

    // Update selected menu
    selectedMenuId.value = menuId;

    // Update the widget
    if (menuItem.defaultPage != null) {
      selectedWidget.assignAll([menuItem.defaultPage!]);
    }
  }

  // Add method to navigate to a new page (like create voucher)
  void navigateToPage(Widget page) {
    selectedWidget.add(page);
  }

  // Add method to go back to previous page
  void popBack() {
    if (selectedWidget.length > 1) {
      selectedWidget.removeLast();
    }
  }

  // Specific method to go back to voucher settings
  void popBackToVoucherSettings() {
    // Remove all pages except the first one (which should be voucher settings)
    if (selectedWidget.length > 1) {
      selectedWidget.removeRange(1, selectedWidget.length);
    }
  }

  // Method to check if we can go back
  bool canGoBack() {
    return selectedWidget.length > 1;
  }
}
