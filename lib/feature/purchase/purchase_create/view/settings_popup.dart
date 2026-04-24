import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/user_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/settings/settings_sidebar.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/system_settings/system_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class SettingsPopup extends StatelessWidget {
  SettingsPopup({super.key});

  final SidebarController sidebarController = Get.find();
  final TokenController tokenController = Get.find();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: primaryColor.withBlue(190),
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: PopupMenuButton<void>(
        position: PopupMenuPosition.under,
        offset: const Offset(0, 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(width: 1, color: Color(0xFFE6E8FF)),
        ),
        color: Colors.white,
        elevation: 4,
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 400),
        itemBuilder: (context) {
          return [
            PopupMenuItem<void>(
              enabled: false,
              padding: EdgeInsets.zero,
              child: Container(
                width: 600,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final user =
                      userController.userData.value; // Use UserController
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xff28328b),
                            backgroundImage: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  "Store: ",
                                  user?.organizationName ?? "N/A",
                                ),
                                const SizedBox(height: 4),
                                _buildInfoRow(
                                  "Branch/User Id: ",
                                  userController.userDisplayString,
                                ),
                                const SizedBox(height: 4),
                                _buildInfoRow("System: ", "Sip"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE6E8FF)),
                      const SizedBox(height: 8),
                      _buildMenuItem(
                        icon: Icons.settings,
                        text: "System Settings",
                        onTap: () {
                          Get.to(() => const SystemSettings());
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildMenuItem(
                        icon: Icons.settings,
                        text: "Settings",
                        onTap: () {
                          Get.to(() => const SettingsSidebar());
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildMenuItem(
                        icon: Icons.logout,
                        text: "Logout",
                        onTap: () {
                          Get.back();
                          tokenController.logout();
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ),
            ),
          ];
        },
        child: const GoldRateDisplay(),
      ),
    );
  }

  // Helper method to build info rows
  Widget _buildInfoRow(String label, String value) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: CustomText(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minWidth: 200),
              child: CustomText(
                text: value,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: CustomText(
                  text: text,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoldRateDisplay extends StatelessWidget {
  const GoldRateDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
            ),
          ),
          const SizedBox(width: 16),
          Transform(
            transform: Matrix4.identity()..rotateZ(1.57),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
