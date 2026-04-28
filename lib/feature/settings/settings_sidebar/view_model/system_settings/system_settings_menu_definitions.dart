// feature/settings/settings_sidebar/view_model/system_settings_menu_definitions.dart
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/print_settings/view/print_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';

class SystemSettingsMenuDefinitions {
  static List<SidebarMenuItem> getMenuItems() {
    // Return all menu items without any filtering - no permission restrictions
    return _getAllMenuItems();
  }

  // This contains the full menu structure for system settings
  static List<SidebarMenuItem> _getAllMenuItems() {
    return [
      // General Settings - accessible to all roles
      SidebarMenuItem(
        id: 'print_configuration',
        title: 'Print Configuration',
        iconPath: 'assets/svgs/settings.svg',
        selectedIconPath: 'assets/svgs/settings_selected.svg',
        defaultPage: PrintSettingsConfigurationPage(),
      ),
    ];
  }

  // Helper method to build placeholder pages
  // ignore: unused_element
  static Widget _buildPlaceholderPage(
    String title,
    IconData icon,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.blue),
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
}
