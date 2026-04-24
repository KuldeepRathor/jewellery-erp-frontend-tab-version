// feature/settings/global_settings/view/global_settings.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/settings/settings_sidebar_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_menu_definitions.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';

class SettingsSidebar extends StatefulWidget {
  const SettingsSidebar({super.key});

  @override
  State<SettingsSidebar> createState() => _SettingsSidebarState();
}

class _SettingsSidebarState extends State<SettingsSidebar> {
  late final SettingsSidebarController sidebarController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with menu items
    sidebarController = Get.put(
      SettingsSidebarController(
        menuItems: SettingsSidebarMenuDefinitions.getMenuItems(),
      ),
      tag: 'globalSettings', // Tag to avoid conflicts with other controllers
    );
  }

  @override
  void dispose() {
    // Clean up when leaving this page
    Get.delete<SettingsSidebarController>(tag: 'globalSettings');
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
                  // WRAP THIS WITH OBX TO OBSERVE CHANGES
                  Positioned.fill(
                    left: 74, // Fixed offset for collapsed sidebar width
                    child: Obx(() {
                      return sidebarController.selectedWidget.isNotEmpty
                          ? sidebarController.selectedWidget.last
                          : const Center(
                            child: Text('Select a settings category'),
                          );
                    }),
                  ),

                  // Position the sidebar on top
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: SettingsSidebarWidget(controller: sidebarController),
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
