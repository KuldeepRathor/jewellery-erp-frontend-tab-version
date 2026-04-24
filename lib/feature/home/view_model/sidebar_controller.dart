// view_model/sidebar_controller.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/generic_attention_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/menu_definitions.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/tagging_entry_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';

class SidebarController extends GetxController {
  RxBool isExpanded = false.obs;
  RxString selectedMenuId = "".obs;
  final selectedSubMenuId = Rx<String?>(null);
  RxMap<String, bool> expandedMenus = <String, bool>{}.obs;

  final selectedWidget = RxList<Widget>([]);

  final List<SidebarMenuItem> menuItems;
  final List<Type> pagesRequiringConfirmation;

  SidebarController({required this.menuItems})
    : pagesRequiringConfirmation =
          MenuDefinitions.getPagesRequiringConfirmation() {
    // Set initial view to the first menu item's default page or its first submenu
    if (menuItems.isNotEmpty) {
      final firstItem = menuItems.first;
      selectedMenuId.value = firstItem.id;

      if (firstItem.subItems.isNotEmpty) {
        selectedSubMenuId.value = firstItem.subItems.first.id;
        selectedWidget.assignAll([firstItem.subItems.first.page]);
      } else if (firstItem.defaultPage != null) {
        selectedWidget.assignAll([firstItem.defaultPage!]);
      }
    }
  }

  void toggleSidebar() {
    isExpanded.value = !isExpanded.value;
  }

  void toggleSidebarOnHover() {
    isExpanded.value = !isExpanded.value;
  }

  // Helper to find selected menu item
  SidebarMenuItem? getSelectedMenuItem() {
    return menuItems.firstWhereOrNull(
      (item) => item.id == selectedMenuId.value,
    );
  }

  // Helper to find selected submenu item
  SidebarSubMenuItem? getSelectedSubMenuItem() {
    final menuItem = getSelectedMenuItem();
    if (menuItem == null || selectedSubMenuId.value == null) return null;

    return menuItem.subItems.firstWhereOrNull(
      (item) => item.id == selectedSubMenuId.value,
    );
  }

  // Check if current page requires confirmation to leave
  bool _requiresConfirmationToLeave() {
    if (selectedWidget.isEmpty) return false;

    final currentWidget = selectedWidget.last;

    // Check if current widget's type is in the list of pages requiring confirmation
    return pagesRequiringConfirmation.any(
      (type) => currentWidget.runtimeType == type,
    );
  }

  void selectMenuItem(String menuId) {
    if (_requiresConfirmationToLeave()) {
      _showConfirmationDialog(() {
        _performMenuItemSelection(menuId);
      });
    } else {
      _performMenuItemSelection(menuId);
    }
  }

  void _performMenuItemSelection(String menuId) {
    // Find the menu item
    final menuItem = menuItems.firstWhereOrNull((item) => item.id == menuId);
    if (menuItem == null) return;

    // If we're selecting a different menu than the currently selected one,
    // we want to expand it regardless of its previous state
    final bool isChangingMenu = selectedMenuId.value != menuId;

    // Update selected menu
    selectedMenuId.value = menuId;

    // If we're selecting a new menu item, always expand it
    // If we're clicking the same menu item again, toggle its state
    if (isChangingMenu) {
      // Always expand when changing to a different menu
      expandedMenus[menuId] = true;
    } else {
      // Toggle when clicking the same menu again
      final isCurrentlyExpanded = expandedMenus[menuId] ?? false;
      expandedMenus[menuId] = !isCurrentlyExpanded;
    }

    // Get the updated expansion state
    final isExpanded = expandedMenus[menuId] ?? false;

    // If menu has subitems and is expanded
    if (menuItem.subItems.isNotEmpty && isExpanded) {
      // Check if we're changing to a new menu OR if there's no currently selected submenu for this menu
      if (isChangingMenu ||
          selectedSubMenuId.value == null ||
          !menuItem.subItems.any(
            (item) => item.id == selectedSubMenuId.value,
          )) {
        // Select the first submenu only if changing menus or no valid submenu is selected
        selectedSubMenuId.value = menuItem.subItems.first.id;

        // Initialize any needed ViewModels
        MenuDefinitions.initializeViewModels(
          menuId,
          menuItem.subItems.first.id,
        );

        selectedWidget.assignAll([menuItem.subItems.first.page]);
      } else {
        // Keep the current submenu selected
        // Find the submenu item
        final subMenuItem = menuItem.subItems.firstWhereOrNull(
          (item) => item.id == selectedSubMenuId.value,
        );

        if (subMenuItem != null) {
          // Initialize any needed ViewModels
          MenuDefinitions.initializeViewModels(
            menuId,
            selectedSubMenuId.value!,
          );

          selectedWidget.assignAll([subMenuItem.page]);
        }
      }
    }
    // If menu has no subitems but has a default page, show that
    else if (menuItem.subItems.isEmpty && menuItem.defaultPage != null) {
      selectedSubMenuId.value = null;
      selectedWidget.assignAll([menuItem.defaultPage!]);
    }

    log('Selected menu: $menuId, isExpanded: $isExpanded');
  }

  void selectSubMenuItem(String menuId, String subMenuId) {
    if (_requiresConfirmationToLeave()) {
      _showConfirmationDialog(() {
        _performSubMenuItemSelection(menuId, subMenuId);
      });
    } else {
      _performSubMenuItemSelection(menuId, subMenuId);
    }
  }

  void _performSubMenuItemSelection(String menuId, String subMenuId) {
    // Find the menu item
    final menuItem = menuItems.firstWhereOrNull((item) => item.id == menuId);
    if (menuItem == null) return;

    // Find the submenu item
    final subMenuItem = menuItem.subItems.firstWhereOrNull(
      (item) => item.id == subMenuId,
    );
    if (subMenuItem == null) return;

    // Update selected menu and submenu
    selectedMenuId.value = menuId;
    selectedSubMenuId.value = subMenuId;
    expandedMenus[menuId] = true;

    // Initialize any needed ViewModels
    MenuDefinitions.initializeViewModels(menuId, subMenuId);

    // Update the widget
    selectedWidget.assignAll([subMenuItem.page]);

    log('Selected submenu: $menuId > $subMenuId');
  }

  void navigateToWidget({required Widget newChild}) {
    if (_requiresConfirmationToLeave()) {
      _showConfirmationDialog(() {
        selectedWidget.add(newChild);
        log("Added widget to stack: ${newChild.runtimeType}");
      });
    } else {
      selectedWidget.add(newChild);
      log("Added widget to stack: ${newChild.runtimeType}");
    }
  }

  void popBackSelectedWidget() {
    if (selectedWidget.length <= 1) return;

    if (_requiresConfirmationToLeave()) {
      _showConfirmationDialog(() {
        _performPopBack();
      });
    } else {
      _performPopBack();
    }
  }

  void _performPopBack() {
    if (selectedWidget.length > 1) {
      log("Popping widget from stack: ${selectedWidget.last.runtimeType}");
      selectedWidget.removeLast();
    }
  }

  void _showConfirmationDialog(VoidCallback onConfirm) {
    Get.dialog(
      barrierDismissible: false,
      GenericAttentionDialog(
        title: 'Leave Page',
        message:
            'Are you sure you want to leave this page? All unsaved changes will be lost.',
        actions: [
          DialogAction(
            text: 'Cancel',
            onPressed: () {
              Get.back(); // Close dialog
            },
            shortcut: 'esc',
          ),
          DialogAction(
            text: 'Leave',
            onPressed: () {
              Get.back(); // Close dialog

              // Handle specific page cleanup if needed
              if (selectedWidget.last is TaggingNewEntryPage) {
                final taggingController = Get.find<TaggingController>();
                taggingController.resetFields();
              }
              // Add other page-specific cleanup here if needed

              // Call the confirmation callback
              onConfirm();
            },
            isDefault: false,
            shortcut: 'Enter',
          ),
        ],
      ),
    );
  }
}
