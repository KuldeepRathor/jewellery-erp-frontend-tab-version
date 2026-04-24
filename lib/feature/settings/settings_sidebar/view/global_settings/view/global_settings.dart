// feature/settings/print_settings/view/print_settings.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/view_model/global_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class GlobalSettingsPage extends StatefulWidget {
  const GlobalSettingsPage({super.key});

  @override
  State<GlobalSettingsPage> createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
  late final GlobalSettingsController controller;

  @override
  void initState() {
    super.initState();
    // controller = Get.put(GlobalSettingsController(), tag: 'printSettings');
    controller = Get.put(GlobalSettingsController(), permanent: true);
  }

  @override
  void dispose() {
    Get.delete<GlobalSettingsController>(tag: 'printSettings');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar with drag handle
                _buildDraggableSidebar(controller),

                // Main content
                Expanded(
                  child: Container(
                    color: Colors.white,
                    // margin: const EdgeInsets.all(16),
                    child: Obx(() => controller.getCurrentPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableSidebar(GlobalSettingsController controller) {
    return Obx(() {
      return Stack(
        children: [
          // The actual sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: controller.sidebarWidth.value,
            height: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Obx(
                      () =>
                          controller.isSidebarExpanded.value
                              ? Row(
                                children: [
                                  const Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Back to Dashboard',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : const Text(""),
                    ),
                  ),
                  ...controller.sidebarItems.map(
                    (item) => _buildSidebarItem(controller, item),
                  ),
                ],
              ),
            ),
          ),

          // Drag handle on the right edge of sidebar
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                controller.updateSidebarWidth(
                  controller.sidebarWidth.value + details.delta.dx,
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Container(width: 8, color: Colors.transparent),
              ),
            ),
          ),

          // Toggle button in the middle right
          Positioned(
            top: 0,
            bottom: 0,
            right: -1, // Slightly overlap for better visuals
            child: Center(
              child: GestureDetector(
                onTap: controller.toggleSidebar,
                child: Container(
                  width: 18,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      controller.isSidebarExpanded.value
                          ? Icons.chevron_left
                          : Icons.chevron_right,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSidebarItem(
    GlobalSettingsController controller,
    GlobalSidebarItem item,
  ) {
    return Obx(() {
      final isSelected = controller.selectedSection.value == item.title;
      final isExpanded = controller.isSidebarExpanded.value;

      return Container(
        margin: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: isExpanded ? 8 : 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? grey1 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.changeSection(item.title),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 16 : 8,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment:
                    isExpanded
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: primaryColor, size: 20),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
