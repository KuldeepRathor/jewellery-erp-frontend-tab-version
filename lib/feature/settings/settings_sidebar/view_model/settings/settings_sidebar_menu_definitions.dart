// feature/settings/settings_sidebar/view_model/settings_sidebar_menu_definitions.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/view/global_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/webstore_settings/view/webstore_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';

class SettingsSidebarMenuDefinitions {
  static List<SidebarMenuItem> getMenuItems() {
    // Get the full menu configuration
    final List<SidebarMenuItem> allMenuItems = _getAllMenuItems();

    // Filter based on user permissions if RBAC controller is available
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      return _filterSettingsMenuItems(allMenuItems, rbacController);
    }

    // Return all menu items if RBAC is not initialized yet
    return allMenuItems;
  }

  // This contains the full menu structure
  static List<SidebarMenuItem> _getAllMenuItems() {
    return [
      // General Settings
      SidebarMenuItem(
        id: 'general_settings',
        title: 'General',
        iconPath: 'assets/svgs/settings.svg',
        selectedIconPath: 'assets/svgs/settings_selected.svg',
        defaultPage: const GlobalSettingsPage(),
      ),
      SidebarMenuItem(
        id: 'webstore_settings',
        title: 'Webstore',
        iconPath: 'assets/svgs/settings.svg',
        selectedIconPath: 'assets/svgs/settings_selected.svg',
        defaultPage: const WebstoreSettingsPage(),
      ),

      // User Settings
      SidebarMenuItem(
        id: 'user_settings',
        title: 'User Account',
        iconPath: 'assets/svgs/customers.svg',
        selectedIconPath: 'assets/svgs/customers_selected.svg',
        defaultPage: const UserSettingsPage(),
      ),

      // Notification Settings
      SidebarMenuItem(
        id: 'notification_settings',
        title: 'Notifications',
        iconPath: 'assets/svgs/dashboard.svg',
        selectedIconPath: 'assets/svgs/dashboard_selected.svg',
        defaultPage: const NotificationSettingsPage(),
      ),

      // Appearance Settings
      SidebarMenuItem(
        id: 'appearance_settings',
        title: 'Appearance',
        iconPath: 'assets/svgs/inventory.svg',
        selectedIconPath: 'assets/svgs/inventory_selected.svg',
        defaultPage: const AppearanceSettingsPage(),
      ),

      // Advanced Settings
      SidebarMenuItem(
        id: 'advanced_settings',
        title: 'Logger',
        iconPath: 'assets/svgs/tagging.svg',
        selectedIconPath: 'assets/svgs/tagging_selected.svg',
        defaultPage: const SettingsPage(),
      ),
    ];
  }

  // Custom filter method for settings menu items
  static List<SidebarMenuItem> _filterSettingsMenuItems(
    List<SidebarMenuItem> allMenuItems,
    RBACController rbacController,
  ) {
    final filteredMenus = <SidebarMenuItem>[];

    // Map settings menu IDs to global settings permission IDs
    final Map<String, String> settingsMenuMap = {
      'general_settings': 'general_settings',
      'user_settings': 'user_settings',
      'notification_settings': 'notification_settings',
      'appearance_settings': 'appearance_settings',
      'webstore_settings': 'webstore_settings',
      'advanced_settings': 'advanced_settings',
    };

    for (final menuItem in allMenuItems) {
      final globalSettingsId = settingsMenuMap[menuItem.id];

      if (globalSettingsId != null) {
        // Check if user has access to this global settings item
        if (rbacController.canAccessGlobalSettingsItem(globalSettingsId)) {
          filteredMenus.add(menuItem);
        }
      } else {
        // If not mapped, use default permission check (fallback)
        if (rbacController.canAccessMenu(menuItem.id)) {
          filteredMenus.add(menuItem);
        }
      }
    }

    return filteredMenus;
  }

  // Helper method to build placeholder pages
  static Widget _buildPlaceholderPage(
    String title,
    IconData icon,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper method to build unauthorized access page
  static Widget _buildUnauthorizedPage(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Access Denied',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have permission to access $title',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Please contact your administrator for access.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check permission before showing content
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      if (!rbacController.canAccessGlobalSettingsItem('user_settings')) {
        return SettingsSidebarMenuDefinitions._buildUnauthorizedPage(
          'User Account Settings',
          Icons.lock,
        );
      }
    }

    return SettingsSidebarMenuDefinitions._buildPlaceholderPage(
      'User Account Settings',
      Icons.lock,
      'You dont have access to this page! Kindly contact to the Admin',
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check permission before showing content
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      if (!rbacController.canAccessGlobalSettingsItem(
        'notification_settings',
      )) {
        return SettingsSidebarMenuDefinitions._buildUnauthorizedPage(
          'Notification Settings',
          Icons.lock,
        );
      }
    }

    return SettingsSidebarMenuDefinitions._buildPlaceholderPage(
      'Notification Settings',
      Icons.lock,
      'You dont have access to this page! Kindly contact to the Admin',
    );
  }
}

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check permission before showing content
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      if (!rbacController.canAccessGlobalSettingsItem('appearance_settings')) {
        return SettingsSidebarMenuDefinitions._buildUnauthorizedPage(
          'Appearance Settings',
          Icons.lock,
        );
      }
    }

    return SettingsSidebarMenuDefinitions._buildPlaceholderPage(
      'Appearance Settings',
      Icons.lock,
      'You dont have access to this page! Kindly contact to the Admin',
    );
  }
}

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check permission before showing content
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      if (!rbacController.canAccessGlobalSettingsItem('advanced_settings')) {
        return SettingsSidebarMenuDefinitions._buildUnauthorizedPage(
          'Advanced Settings',
          Icons.settings_outlined,
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add your settings widgets here
        ],
      ),
    );
  }
}
