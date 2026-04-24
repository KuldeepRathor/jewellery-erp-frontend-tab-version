import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/daily_rate/view_model/daily_rates_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_estimate/view/global_quick_estimate_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_estimate/view_model/global_quick_estimate_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/quick_global_old_gold_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/quick_global_old_gold_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/sidebar_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/menu_definitions.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/vendor_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/services/vendor_services.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../utils/role_based_permission/rbac_controller.dart';
import '../view_model/sidebar_controller.dart';

// Create an Intent class for the keyboard shortcut
class PrintGlobalShortcutIntent extends Intent {
  const PrintGlobalShortcutIntent();
}

// Create a new intent for the barcode scanner
class BarcodeScanIntent extends Intent {
  const BarcodeScanIntent();
}

class DebugScreenIntent extends Intent {
  const DebugScreenIntent();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handlePrintShortcut() {
    log('Global shortcut called: Shift + 1 pressed!');
    Get.dialog(const QuickGlobalOldGoldDialog());
  }

  void _handleBarcodeScanShortcut() {
    log('Global shortcut called:  Shift + ~ pressed!');

    Get.dialog(const BarcodeScannerDialog());
  }

  final sidebarController = Get.put(
    SidebarController(menuItems: MenuDefinitions.getMenuItems()),
  );
  final globalSettingsViewModel = Get.put(GlobalSettingsViewModel());

  void setUpAllRequiredController() {
    Get.put(VendorServices());
    Get.put(VendorRepository());
    Get.put(GoldRateController()).fetchGoldRates();
    Get.put(QuickGlobalOldGoldDialogController());
    Get.put(DailyRatesListingViewModel());
    Get.put(RemarksController());

    Get.put(BarcodeScannerDialogController());
    Get.put(GlobalSettingsViewModel()).getGlobalSettings();

    final talker = Talker();
    Get.put(TalkerController(talker));
  }

  void _handleDebugScreenShortcut() {
    log('Global shortcut called: Ctrl + Shift + D pressed!');
    // Get the instance from GetX instead of creating a new one
    Get.find<TalkerController>().navigateToTalkerScreen();
  }

  @override
  void initState() {
    setUpAllRequiredController();
    if (!Get.isRegistered<RBACController>()) {
      Get.put(RBACController());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.digit1):
            const PrintGlobalShortcutIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.backquote):
            const BarcodeScanIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tilde):
            const BarcodeScanIntent(),
        LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.shift,
              LogicalKeyboardKey.keyD,
            ):
            const DebugScreenIntent(),
      },
      child: Actions(
        actions: {
          PrintGlobalShortcutIntent: CallbackAction<PrintGlobalShortcutIntent>(
            onInvoke: (intent) => _handlePrintShortcut(),
          ),
          BarcodeScanIntent: CallbackAction<BarcodeScanIntent>(
            onInvoke: (intent) => _handleBarcodeScanShortcut(),
          ),
          DebugScreenIntent: CallbackAction<DebugScreenIntent>(
            onInvoke: (intent) => _handleDebugScreenShortcut(),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    left: 76,
                    child: Obx(() {
                      return sidebarController.selectedWidget.last;
                    }),
                  ),

                  // Sidebar
                  const Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: SideBarWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
