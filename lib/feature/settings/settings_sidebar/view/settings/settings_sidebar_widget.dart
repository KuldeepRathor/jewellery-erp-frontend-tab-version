// feature/settings/global_settings/view/widgets/global_settings_sidebar_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:svg_flutter/svg_flutter.dart';

class SettingsSidebarWidget extends StatelessWidget {
  final SettingsSidebarController controller;

  const SettingsSidebarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MouseRegion(
        onEnter: (_) => controller.toggleSidebarOnHover(),
        onExit: (_) => controller.toggleSidebarOnHover(),
        child: InkWell(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            width: controller.isExpanded.value ? 200 : 74,
            height: double.infinity, // Force full height
            color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 62,
                    width: double.infinity,
                    color: secondaryColor,
                  ),
                ),

                // The rest of the menu in a scrollable container
                Expanded(
                  // This makes sure the menu items take all available space
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: Get.height * 0.01),
                        // Generate menu items
                        ...controller.menuItems.map((menuItem) {
                          return GlobalSettingsMenuItemWidget(
                            menuItem: menuItem,
                            controller: controller,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class GlobalSettingsMenuItemWidget extends StatelessWidget {
  final SidebarMenuItem menuItem;
  final SettingsSidebarController controller;

  const GlobalSettingsMenuItemWidget({
    super.key,
    required this.menuItem,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedMenuId.value == menuItem.id;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => controller.selectMenuItem(menuItem.id),
            child: Ink(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? secondaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: menuItem.iconPadding ?? 0,
                      ),
                      child: SizedBox(
                        width: menuItem.iconWidth ?? 38,
                        height: menuItem.iconHeight ?? 38,
                        child: SvgPicture.asset(
                          isSelected
                              ? menuItem.selectedIconPath
                              : menuItem.iconPath,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    if (controller.isExpanded.value) ...[
                      Flexible(
                        child: Text(
                          menuItem.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
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
        ),
      );
    });
  }
}
