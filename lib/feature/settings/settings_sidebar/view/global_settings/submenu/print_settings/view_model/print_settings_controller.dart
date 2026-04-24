// Controller class for managing PrintSettingsPage state
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrintSettingsPageController extends GetxController {
  // Tab controller
  late TabController tabController;

  // Initialize tab controller
  void initTabController(TickerProvider vsync) {
    tabController = TabController(length: 3, vsync: vsync);
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }
}
