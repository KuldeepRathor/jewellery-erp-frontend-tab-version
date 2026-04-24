// feature/settings/settings_sidebar/view/system_settings.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/system_settings/system_settings_sidebar.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/system_settings/system_settings_menu_definitions.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/system_settings/system_settings_controller.dart';

class SystemSettings extends StatefulWidget {
  const SystemSettings({super.key});

  @override
  State<SystemSettings> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  late final SystemSettingsController sidebarController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with menu items
    // Use different tag to avoid conflicts with SettingsSidebar
    sidebarController = Get.put(
      SystemSettingsController(
        menuItems: SystemSettingsMenuDefinitions.getMenuItems(),
      ),
      tag: 'systemSettings', // Different tag from 'globalSettings'
    );
  }

  @override
  void dispose() {
    // Clean up when leaving this page
    Get.delete<SystemSettingsController>(tag: 'systemSettings');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Content area with sidebar
            Expanded(
              child: Stack(
                children: [
                  // Main content area - fixed left offset
                  Positioned.fill(
                    left: 74, // Fixed offset for collapsed sidebar width
                    child: Obx(() {
                      return sidebarController.selectedWidget.isNotEmpty
                          ? sidebarController.selectedWidget.last
                          : const Center(
                            child: Text('Select a system settings category'),
                          );
                    }),
                  ),

                  // Position the sidebar on top
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: SystemSettingsSidebarWidget(
                      controller: sidebarController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
