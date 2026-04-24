// feature/settings/settings_sidebar/view/webstore_settings/view_model/webstore_settings_controller.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/view/print_settings_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view/design_wise_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view/general_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view/head_wise_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/design_wise_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/general_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/submenu/general/view_model/head_wise_listing_controller.dart';

class WebstoreSidebarItem {
  final String title;
  final IconData icon;
  final String pageId;

  WebstoreSidebarItem({
    required this.title,
    this.icon = Icons.chevron_right,
    required this.pageId,
  });
}

class WebstoreSettingsController extends GetxController {
  // Observable variables
  final RxString selectedSection = 'General'.obs;
  final RxList<WebstoreSidebarItem> sidebarItems = <WebstoreSidebarItem>[].obs;

  // Sidebar state variables
  final RxBool isSidebarExpanded = true.obs;
  final RxDouble sidebarWidth = 250.0.obs;
  final double minSidebarWidth = 80.0;
  final double maxSidebarWidth = 350.0;
  final double collapsedWidth = 80.0;
  final double expandedWidth = 250.0;

  @override
  void onInit() {
    super.onInit();
    _initializeSidebarItems();
  }

  void _initializeSidebarItems() {
    // Get all sidebar items (no filtering needed)
    final allItems = _getAllSidebarItems();
    sidebarItems.assignAll(allItems);

    // Set initial selection to first item
    if (allItems.isNotEmpty) {
      selectedSection.value = allItems.first.title;
    }
  }

  // Only 3 sidebar items - no permissions needed
  List<WebstoreSidebarItem> _getAllSidebarItems() {
    return [
      WebstoreSidebarItem(
        title: 'General',
        pageId: 'webstore_general',
        icon: Icons.chevron_right,
      ),
      WebstoreSidebarItem(
        title: 'Pages',
        pageId: 'webstore_pages',
        icon: Icons.chevron_right,
      ),
      WebstoreSidebarItem(
        title: 'Invoice',
        pageId: 'webstore_invoice',
        icon: Icons.chevron_right,
      ),
    ];
  }

  void toggleSidebar() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
    sidebarWidth.value =
        isSidebarExpanded.value ? expandedWidth : collapsedWidth;
  }

  void updateSidebarWidth(double width) {
    final newWidth = width.clamp(minSidebarWidth, maxSidebarWidth);
    sidebarWidth.value = newWidth;
    isSidebarExpanded.value = newWidth > collapsedWidth + 30;
  }

  void changeSection(String sectionTitle) {
    final item = sidebarItems.firstWhereOrNull(
      (item) => item.title == sectionTitle,
    );

    if (item != null) {
      selectedSection.value = sectionTitle;
    }
  }

  // NEW: Method to navigate to detail pages (not in sidebar)
  void navigateToPage(String pageId) {
    selectedSection.value = pageId;
  }

  // NEW: Method to go back to General settings
  void goBackToGeneral() {
    selectedSection.value = 'General';
  }

  // // NEW: Method to navigate to detail pages (not in sidebar)
  // void navigateToPage(String pageId) {
  //   selectedSection.value = pageId;
  // }

  // // NEW: Method to go back to General settings
  // void goBackToGeneral() {
  //   selectedSection.value = 'General';
  // }

  Widget getCurrentPage() {
    // Check if it's a sidebar item first
    // Check if it's a sidebar item first
    final item = sidebarItems.firstWhereOrNull(
      (item) => item.title == selectedSection.value,
    );

    if (item != null) {
      // Return the appropriate widget based on selected pageId
      switch (item.pageId) {
        case 'webstore_general':
          return const GeneralSettingsPage();
        case 'webstore_pages':
          return const PrintSettingsPage();
        case 'webstore_invoice':
          return const PrintSettingsPage();
        default:
          return const Center(child: Text('Page not found'));
      }
    }

    // Handle detail pages (not in sidebar)
    switch (selectedSection.value) {
      case 'head_wise_listing':
        return const HeadWiseListingPage();
      case 'design_wise_listing':
        return const DesignWiseListingPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  // In your WebstoreSettingsController or parent controller
  @override
  void onClose() {
    // Clean up all settings controllers when leaving webstore settings entirely
    try {
      Get.delete<GeneralSettingsController>(tag: 'generalSettings');
    } catch (e) {
      log('GeneralSettingsController already disposed');
    }

    try {
      Get.delete<HeadWiseListingController>(tag: 'headWiseListing');
    } catch (e) {
      log('HeadWiseListingController already disposed');
    }

    try {
      Get.delete<DesignWiseListingController>(tag: 'designWiseListing');
    } catch (e) {
      log('DesignWiseListingController already disposed');
    }

    super.onClose();
  }
}
