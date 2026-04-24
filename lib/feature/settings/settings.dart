import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/ui/custom_talker_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/auth/view/login_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/devtools_launcher.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _handleLogout() async {
    try {
      final tokenController = Get.find<TokenController>();
      await tokenController.clearToken();
      showSuccessToast(message: "Logged out successfully");
      Get.offAll(() => const LoginScreen()); // Navigate to login screen
    } catch (e) {
      showErrorToast(message: "Logout failed: $e");
    }
  }

  Future<void> _handleTokenRefresh() async {
    try {
      final tokenController = Get.find<TokenController>();
      await tokenController.loadSavedToken();
      if (tokenController.token == null) {
        showErrorToast(message: "No valid token found. Please login again.");
        Get.offAll(() => const LoginScreen());
      } else {
        showSuccessToast(message: "Token refreshed");
      }
    } catch (e) {
      showErrorToast(message: "Token refresh failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/svgs/auth/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Talker Button (for debugging)
                SizedBox(
                  width: Get.width * 0.2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // final talkerController = Get.find<TalkerController>();
                      Get.to(() => const CustomTalkerScreen());
                    },
                    icon: const Icon(Icons.bug_report),
                    label: const Text("Debug ERP Logs"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: Get.width * 0.2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Get.find<TalkerController>();
                      Get.find<TalkerController>().openDebugInBrowser();
                    },
                    icon: const Icon(Icons.bug_report),
                    label: const Text("Debug Browser Logs"),
                  ),
                ),
                const SizedBox(height: 20),
                // Token Status
                GetX<TokenController>(
                  builder:
                      (controller) => Text(
                        'Token Status: ${controller.token != null ? 'Active' : 'No Token'}',
                        style: TextStyle(
                          color:
                              controller.token != null
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                ),
                const SizedBox(height: 20),

                // Refresh Token Button
                SizedBox(
                  width: Get.width * 0.2,
                  child: ElevatedButton.icon(
                    onPressed: _handleTokenRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh Token"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: Get.width * 0.2,
                  child: ElevatedButton.icon(
                    onPressed: () => DevToolsLauncher.openDevTools(context),
                    icon: const Icon(Icons.network_check_outlined),
                    label: const Text("Network Tab"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Logout Button
                SizedBox(
                  width: Get.width * 0.2,
                  child: ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
