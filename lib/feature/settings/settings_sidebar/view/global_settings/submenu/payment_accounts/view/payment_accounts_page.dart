import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view/bank_accounts.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view/pos_accounts.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view/settlements_accounts.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view_model/payment_accounts_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class PaymentAccountsSettingsPage extends StatefulWidget {
  const PaymentAccountsSettingsPage({super.key});

  @override
  State<PaymentAccountsSettingsPage> createState() =>
      _PaymentAccountsSettingsPageState();
}

class _PaymentAccountsSettingsPageState
    extends State<PaymentAccountsSettingsPage>
    with SingleTickerProviderStateMixin {
  // Get the controller
  late final PaymentsAccountsController controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller = Get.put(PaymentsAccountsController());
    controller.initTabController(this);
  }

  @override
  void dispose() {
    Get.delete<PaymentsAccountsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Payment Accounts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: TabBar(
              controller: controller.tabController,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey[700],
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Bank Accounts'),
                      SizedBox(width: 8),
                      Text(
                        'Ctrl + F1',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('POS Accounts'),
                      SizedBox(width: 8),
                      Text(
                        'Ctrl + F2',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Settlement Accounts'),
                      SizedBox(width: 8),
                      Text(
                        'Ctrl + F3',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: const [
                BankAccountsPage(),
                PosAccountsPage(),
                SettlementsAccountsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
