// feature/home/view/components/sidebar_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/menu_definitions.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../utils/textstyle.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SidebarController(menuItems: MenuDefinitions.getMenuItems()),
    );

    return Obx(() {
      return MouseRegion(
        onEnter: (_) => controller.toggleSidebarOnHover(),
        onExit: (_) => controller.toggleSidebarOnHover(),
        child: InkWell(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            width: controller.isExpanded.value ? 200 : 74,
            color: primaryColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 62,
                    width: double.infinity,
                    color: secondaryColor,
                    child: const Center(
                      child: CustomText(text: "", color: Colors.white),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),

                  // Generate sidebar menu items
                  ...controller.menuItems.map((menuItem) {
                    return SidebarMenuItemWidget(
                      menuItem: menuItem,
                      controller: controller,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class SidebarMenuItemWidget extends StatelessWidget {
  final SidebarMenuItem menuItem;
  final SidebarController controller;

  const SidebarMenuItemWidget({
    super.key,
    required this.menuItem,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedMenuId.value == menuItem.id;
      final isExpanded = controller.expandedMenus[menuItem.id] ?? false;

      return Column(
        children: [
          // Main menu item
          Padding(
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
          ),

          // Submenu items (if any)
          if (menuItem.subItems.isNotEmpty && isSelected)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    menuItem.subItems.map((subItem) {
                      final isSubItemSelected =
                          controller.selectedSubMenuId.value == subItem.id;

                      return Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: InkWell(
                            onTap:
                                () => controller.selectSubMenuItem(
                                  menuItem.id,
                                  subItem.id,
                                ),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: controller.isExpanded.value ? null : 74,
                              padding: EdgeInsets.only(
                                left: controller.isExpanded.value ? 20 : 8,
                                right: 8,
                                top: 10,
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSubItemSelected
                                        ? secondaryColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                    size: controller.isExpanded.value ? 16 : 16,
                                  ),
                                  if (controller.isExpanded.value) ...[
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        subItem.title,
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
                      );
                    }).toList(),
              ),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
        ],
      );
    });
  }
}
