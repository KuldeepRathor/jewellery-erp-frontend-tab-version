// feature/settings/settings_sidebar/view/global_settings/view_model/global_settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_listing/view/customer_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/employee/employee_listing/view/employee_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/add_roles/roles_listing/view/roles_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/master_settings/view/master_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/print_settings/view/print_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/kyc_settings/view/kyc_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/payment_accounts/view/payment_accounts_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/preferences/view/preferences_settings.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/print_settings/view/print_settings_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/view/voucher_settings_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter/view/counter_list_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_listing/view/vendor_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';

class GlobalSidebarItem {
  final String title;
  final IconData icon;
  final String pageId;

  GlobalSidebarItem({
    required this.title,
    this.icon = Icons.chevron_right,
    required this.pageId,
  });
}

class GlobalSettingsController extends GetxController {
  // Observable variables
  final RxString selectedSection = 'Preferences'.obs;
  final RxList<GlobalSidebarItem> sidebarItems = <GlobalSidebarItem>[].obs;

  // Sidebar state variables
  final RxBool isSidebarExpanded = true.obs;
  final RxDouble sidebarWidth = 250.0.obs;
  final double minSidebarWidth = 80.0;
  final double maxSidebarWidth = 350.0;
  final double collapsedWidth = 80.0;
  final double expandedWidth = 250.0;

  @override
  void onInit() {
    super.onInit();
    _initializeSidebarItems();
  }

  void _initializeSidebarItems() {
    // Get all possible sidebar items
    final allItems = _getAllSidebarItems();

    // Filter based on user permissions if RBAC controller is available
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      final filteredItems = rbacController.filterGlobalSettingsItems(allItems);
      sidebarItems.assignAll(filteredItems);

      // Set initial selection to first available item
      if (filteredItems.isNotEmpty) {
        selectedSection.value = filteredItems.first.title;
      }
    } else {
      // If RBAC is not available, show all items
      sidebarItems.assignAll(allItems);
    }
  }

  // This contains all possible sidebar items (unfiltered)
  List<GlobalSidebarItem> _getAllSidebarItems() {
    return [
      GlobalSidebarItem(title: 'Preferences', pageId: 'preferences'),
      GlobalSidebarItem(title: 'Print settings', pageId: 'print_settings'),
      GlobalSidebarItem(
        title: 'Print configuration',
        pageId: 'print_configuration',
      ),
      GlobalSidebarItem(
        title: 'Bank and Payment Accounts',
        pageId: 'bank_payment_accounts',
      ),
      GlobalSidebarItem(
        title: "Voucher settings",
        pageId: "voucher_settings_copy",
      ),
      GlobalSidebarItem(
        title: 'Accounting Masters',
        pageId: 'accounting_masters',
      ),
      GlobalSidebarItem(title: 'Purity settings', pageId: 'purity_settings'),
      GlobalSidebarItem(
        title: 'Roles and Permissions',
        pageId: 'roles_permissions',
      ),
      GlobalSidebarItem(
        title: 'Branch and Counters',
        pageId: 'branch_counters',
      ),
      GlobalSidebarItem(title: 'Employees', pageId: 'employees'),
      GlobalSidebarItem(title: 'Customers', pageId: 'customers'),
      GlobalSidebarItem(title: 'Vendors', pageId: 'vendors'),
      GlobalSidebarItem(title: "KYC Settings", pageId: "kyc_settings"),
    ];
  }

  void toggleSidebar() {
    isSidebarExpanded.value = !isSidebarExpanded.value;
    sidebarWidth.value =
        isSidebarExpanded.value ? expandedWidth : collapsedWidth;
  }

  void updateSidebarWidth(double width) {
    final newWidth = width.clamp(minSidebarWidth, maxSidebarWidth);
    sidebarWidth.value = newWidth;
    isSidebarExpanded.value = newWidth > collapsedWidth + 30;
  }

  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'You dont have access to this page! Kindly contact to the Admin',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthorizedPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.block, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Access Denied',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have permission to access $title',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Please contact your administrator for access.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void changeSection(String sectionTitle) {
    // Check if user has permission to access this section
    final item = sidebarItems.firstWhereOrNull(
      (item) => item.title == sectionTitle,
    );

    if (item != null) {
      // Additional permission check
      if (Get.isRegistered<RBACController>()) {
        final rbacController = Get.find<RBACController>();
        if (!rbacController.canAccessGlobalSettingsItem(item.pageId)) {
          // Show error or don't change section
          Get.snackbar(
            'Access Denied',
            'You don\'t have permission to access this section',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }
      selectedSection.value = sectionTitle;
    }
  }

  Widget getCurrentPage() {
    final item = sidebarItems.firstWhereOrNull(
      (item) => item.title == selectedSection.value,
    );

    if (item == null) {
      return _buildUnauthorizedPage('this section');
    }

    // Double-check permission before showing page
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      if (!rbacController.canAccessGlobalSettingsItem(item.pageId)) {
        return _buildUnauthorizedPage(item.title);
      }
    }

    // Return the appropriate widget based on selected pageId
    switch (item.pageId) {
      case 'preferences':
        return const PreferencesSettingsPage();
      case 'print_settings':
        return const PrintSettingsPage();
      // case 'print_configuration':
      //   return PrintSettingsConfigurationPage();
      case 'bank_payment_accounts':
        return const PaymentAccountsSettingsPage();
      // case 'voucher_settings':
      //   return const VoucherSettingsPage();
      case 'accounting_masters':
        return _buildPlaceholderPage('Accounting Masters');
      case 'purity_settings':
        return const MasterSettingsPage();
      case 'roles_permissions':
        return const RoleslistingPage();
      case 'branch_counters':
        return const CounterPage();
      case 'employees':
        return const EmployeeListingPage();
      case 'customers':
        return const CustomerListing();
      case 'vendors':
        return const VendorListingPage();
      case "kyc_settings":
        return const KycSettingsPage();
      case "voucher_settings_copy":
        return const VoucherSettingsPage();
      default:
        return _buildUnauthorizedPage('this section');
    }
  }

  // Method to refresh permissions (call this when permissions change)
  void refreshPermissions() {
    _initializeSidebarItems();

    // If current selection is no longer available, select first available item
    final currentItem = sidebarItems.firstWhereOrNull(
      (item) => item.title == selectedSection.value,
    );

    if (currentItem == null && sidebarItems.isNotEmpty) {
      selectedSection.value = sidebarItems.first.title;
    }
  }

  // Method to check if user has access to a specific section
  bool canAccessSection(String sectionTitle) {
    if (!Get.isRegistered<RBACController>()) return true;

    final item = sidebarItems.firstWhereOrNull(
      (item) => item.title == sectionTitle,
    );
    if (item == null) return false;

    final rbacController = Get.find<RBACController>();
    return rbacController.canAccessGlobalSettingsItem(item.pageId);
  }
}
