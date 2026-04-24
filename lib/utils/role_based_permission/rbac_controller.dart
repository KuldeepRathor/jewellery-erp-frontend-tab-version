// controllers/rbac_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/token_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/view_model/global_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';

import 'permission_service.dart';

class RBACController extends GetxController {
  final TokenController _tokenController = Get.find<TokenController>();

  // Store permission data from token
  final RxList<int> _userActions = <int>[].obs;
  final RxList<int> _userPages = <int>[].obs;
  final RxList<int> _userModules = <int>[].obs;

  // User information from token
  final Rx<String?> _roleName = Rx<String?>(null);
  final Rx<String?> _roleType = Rx<String?>(null);
  final Rx<String?> _branchId = Rx<String?>(null);
  final Rx<String?> _organizationName = Rx<String?>(null);
  final Rx<String?> _branchAddressLine1 = Rx<String?>(null);
  final Rx<String?> _branchAddressLine2 = Rx<String?>(null);
  final Rx<String?> _branchCity = Rx<String?>(null);
  final Rx<String?> _branchState = Rx<String?>(null);
  final Rx<String?> _branchPincode = Rx<String?>(null);
  final Rx<String?> _branchCountry = Rx<String?>(null);

  final Map<String, List<int>> menuPermissionMap = {
    // Dashboard - always accessible
    'dashboard': [],

    // Sales Module (1000)
    'sales': [1000], // Module code for sales
    'sales:sales_invoice': [1050], // sales listing page
    'sales:sales_estimate': [2050], // estimate listing page (estimate module)
    'sales:sales_return': [
      3050,
    ], // sales_return listing page (sales_return module)
    // Tagging Module (4000) - UPDATED
    'tagging': [4000], // Module code for tagging
    'tagging:tagging_lot_creation': [4050], // lot page
    'tagging:tagging_new': [4100], // new_tagging page
    'tagging:tagging_retag': [4150], // retag page
    'tagging:tagging_stock_heads': [4200], // stock_head page
    'tagging:tagging_designs': [4250], // design page
    'tagging:tagging_stone': [4300], // stone page
    'tagging:tagging_ornament': [4350], // ornament page
    // Items Module (5000) - UPDATED
    'items': [5000], // Module code for items
    'items:items_list': [5050], // item_list page
    'items:items_verification': [5100], // item_verification page
    'items:items_issue': [5150], // item_issue page
    'items:items_counter_transfer': [5200], // counter_transfer page
    'items:items_branch_transfer': [5250], // branch_transfer page
    'items:items_reorder_level': [5300], // reorder_level page
    'items:items_wanted_list': [5350], // wanted_list page
    // Stock Module (6000) - UPDATED (was 5000, now using Purchase module)
    'stock': [6000], // Module code for purchase
    'stock:stock_purchase': [6050], // customer_purchase page
    'stock:stock_purchase_return': [
      6050,
    ], // reusing customer_purchase (or create dedicated page)
    'stock:stock_material_in': [
      7050,
    ], // material_in_out page (material_in_out module)
    'stock:stock_material_out': [
      7050,
    ], // material_in_out page (material_in_out module)
    'stock:stock_approval_issue': [
      8050,
    ], // approval_issue_receipt page (approval module)
    'stock:stock_approval_receipt': [
      8050,
    ], // approval_issue_receipt page (approval module)
    // Accounts Module (9000) - UPDATED (was 6000)
    'accounts': [9000], // Module code for accounts
    'accounts:accounts_payments': [9050], // payments page
    'accounts:accounts_receipts': [9100], // receipts page
    'accounts:accounts_payments_receipts_cancel': [
      9055,
      9105,
    ], // cancel actions
    'accounts:accounts_journal_entry': [9150], // journal page
    'accounts:accounts_customer_balance': [
      11700,
    ], // customer_balance report page
    // Orders and Repairs Module (10000) - NOTE: No backend mapping found, using settings as placeholder
    'orders_repairs': [10000], // Using settings module as placeholder
    'orders_repairs:orders_repairs_order': [10000],
    'orders_repairs:orders_repairs_repair': [10000],
    'orders_repairs:orders_repairs_booking': [10000],

    // Jewellery Plans Module (11000) - NOTE: No backend mapping found, using reports as placeholder
    'jewellery_plans': [11000], // Using reports module as placeholder
    // Digital Coin Module (12000) - NOTE: No backend mapping found
    'digital_coin': [12000], // No backend mapping
    // Reports Module (11000) - UPDATED (was 14000)
    'reports': [11000], // Reports module
    'reports:reports_stock_value_statement': [
      11600,
    ], // stock_and_value_statement_report
    'reports:reports_branch': [11800], // branch_report page
    'reports:reports_item_statement': [11350], // item_statement page
    'reports:reports_daily_stock': [11150], // daily_stock_report page
    'reports:reports_outward': [11450], // outward_report page
    'reports:reports_inward': [11500], // inward_report page
    'reports:reports_daily_admin_stock': [
      11200,
    ], // daily_admin_stock_report page
    'reports:reports_daily': [11050], // daily_report page
    'reports:reports_tagged_item': [11300], // tagged_item_report page
    'reports:reports_tagged_record': [11250], // tagged_report page
    'reports:reports_approval_statement': [11550], // approval_statement page
    'reports:reports_material_outstanding': [
      11650,
    ], // material_inout_outstanding page
    'reports:reports_customer_balance': [11700], // customer_balance page
    'reports:reports_item_difference': [11100], // item_difference page
    // Web Store Module (16000) - UPDATED (was 13000)
    'web_store': [16000], // webstore module
    'web_store:web_store_catalogue': [16050], // settings page (webstore module)
    'web_store:web_store_collection': [
      16050,
    ], // settings page (webstore module)
    'web_store:web_store_homepage': [16050], // settings page (webstore module)
    'web_store:web_store_orders': [16050], // settings page (webstore module)
    'web_store:web_store_settlements': [
      16050,
    ], // settings page (webstore module)
    'web_store:web_store_online_design': [
      16050,
    ], // settings page (webstore module)
    // Daily Rates Module (15000) - UPDATED (was 9000)
    'daily_rates': [15000, 15050], // Module + rate page
    // Settings Module (10000) - UPDATED (was 7000)
    'settings': [10000], // settings module
    'settings:settings_roles_permissions': [10050], // settings page
    'settings:settings_masters': [10050], // settings page
    'settings:settings_banks_payments': [10050], // settings page
    'settings:settings_print': [10050], // settings page
    'settings:settings_estimation': [10050], // settings page
    'settings:settings_voucher': [10050], // settings page
    'settings:settings_branch_counters': [10050], // settings page
    'settings:settings_employees': [10050], // settings page
    'settings:settings_customers': [10050], // settings page
    'settings:settings_vendors': [10050], // settings page
  };

  // Also update globalSettingsPermissionMap:
  final Map<String, List<int>> globalSettingsPermissionMap = {
    // General Settings - Basic settings access
    'general_settings': [10000], // Requires settings module permission
    // User Account Settings - User management
    'user_settings': [10000, 10050], // Requires settings
    // Notification Settings - Admin level
    'notification_settings': [10000, 10050], // Requires settings
    // Appearance Settings - Basic settings
    'appearance_settings': [10000], // Requires settings module
    // Advanced Settings/Logger - Admin only
    'advanced_settings': [10050], // Requires settings page
    // Global Settings Preferences - Basic settings
    'preferences': [10000], // Requires settings module
    // Print Settings - Print permissions
    'print_settings': [10050], // Requires settings page
    // Print Configuration - Print permissions
    'print_configuration': [10050], // Requires settings page
    // Bank and Payment Accounts - Financial settings
    'bank_payment_accounts': [10050], // Requires settings page
    // Voucher Settings - Voucher management
    'voucher_settings': [10050], // Requires settings page
    // Accounting Masters - Master data management
    'accounting_masters': [10050], // Requires settings page
    // Purity Settings - Master data
    'purity_settings': [10050], // Requires settings page
    // Roles and Permissions - Admin only
    'roles_permissions': [10050], // Requires settings page
    // Branch and Counters - Branch management
    'branch_counters': [10050], // Requires settings page
    // Employees - Employee management
    'employees': [10050], // Requires settings page
    // Customers - Customer management
    'customers': [10050], // Requires settings page
    // Vendors - Vendor management
    'vendors': [10050], // Requires settings page
  };
  // Getters for user permissions
  List<int> get userActions => _userActions;
  List<int> get userPages => _userPages;
  List<int> get userModules => _userModules;

  // Getters for user information
  String? get roleName => _roleName.value;
  String? get roleType => _roleType.value;
  String? get branchId => _branchId.value;
  String? get organizationName => _organizationName.value;

  @override
  void onInit() {
    super.onInit();
    extractPermissionsFromToken();
  }

  // Extract user permissions from the JWT token
  Future<void> extractPermissionsFromToken() async {
    try {
      final String? token = await _tokenController.getAccessToken();

      if (token == null || token.isEmpty) {
        log('No token available');
        return;
      }

      // Split the token to get the payload
      final parts = token.split('.');
      if (parts.length != 3) {
        log('Invalid token format');
        return;
      }

      // Decode the payload
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> data = json.decode(decodedPayload);

      // Extract user information
      _roleName.value = data['role_name'];
      _roleType.value = data['role_type'];
      _branchId.value = data['branch_readable_id'];
      _organizationName.value = data['organization_name'];

      // Extract permissions from token payload
      _userActions.clear();
      if (data.containsKey('actions')) {
        final actions = data['actions'];
        if (actions is List) {
          _userActions.addAll(actions.cast<int>());
          // _userActions.remove(1053);
        }
      }

      _userPages.clear();
      if (data.containsKey('pages')) {
        final pages = data['pages'];
        if (pages is List) {
          _userPages.addAll(pages.cast<int>());
          // _userPages.remove(1100);
        }
      }

      _userModules.clear();
      if (data.containsKey('modules')) {
        final modules = data['modules'];
        if (modules is List) {
          _userModules.addAll(modules.cast<int>());
        }
      }

      log('User information loaded:');
      log('Role: ${_roleName.value}, Type: ${_roleType.value}');
      log(
        'Branch: ${_branchId.value}, Organization: ${_organizationName.value}',
      );
      log('Branch Address Line 1: ${_branchAddressLine1.value}');
      log('Branch Address Line 2: ${_branchAddressLine2.value}');
      log('Branch City: ${_branchCity.value}');
      log('Branch State: ${_branchState.value}');
      log('Branch Pincode: ${_branchPincode.value}');
      log('Branch Country: ${_branchCountry.value}');

      log('Permissions loaded:');
      log('Modules: ${_userModules.join(", ")}');
      log('Pages: ${_userPages.join(", ")}');
      log('Actions: ${_userActions.join(", ")}');

      // debugMenuPermissions();
    } catch (e) {
      log('Error extracting permissions from token: $e');
    }
  }

  // void debugMenuPermissions() {
  //   log('=== DEBUGGING MENU PERMISSIONS ===');

  //   // Check webstore specifically
  //   const webstoreMenuId = 'web_store';
  //   log('Checking menu: $webstoreMenuId');
  //   log('Can access menu: ${canAccessMenu(webstoreMenuId)}');

  //   // Check each webstore submenu
  //   final webstoreSubmenus = [
  //     'web_store_catalogue',
  //     'web_store_collection',
  //     'web_store_homepage',
  //     'web_store_orders',
  //     'web_store_settlements'
  //   ];

  //   for (final submenu in webstoreSubmenus) {
  //     final key = '$webstoreMenuId:$submenu';
  //     final requiredPermissions = menuPermissionMap[key];
  //     final canAccess = canAccessSubMenu(webstoreMenuId, submenu);

  //     log('Submenu: $submenu');
  //     log('  Key: $key');
  //     log('  Required permissions: $requiredPermissions');
  //     log('  Can access: $canAccess');

  //     if (requiredPermissions != null) {
  //       for (final permission in requiredPermissions) {
  //         log('    Permission $permission: ${_checkPermission(permission)}');
  //       }
  //     }
  //   }

  //   // ADD THIS: Debug Sales permissions
  //   log('=== DEBUGGING SALES PERMISSIONS ===');

  //   const salesMenuId = 'sales';
  //   log('Checking menu: $salesMenuId');
  //   log('Can access menu: ${canAccessMenu(salesMenuId)}');

  //   final salesSubmenus = ['sales_invoice', 'sales_estimate', 'sales_return'];

  //   for (final submenu in salesSubmenus) {
  //     final key = '$salesMenuId:$submenu';
  //     final requiredPermissions = menuPermissionMap[key];
  //     final canAccess = canAccessSubMenu(salesMenuId, submenu);

  //     log('Sales Submenu: $submenu');
  //     log('  Key: $key');
  //     log('  Required permissions: $requiredPermissions');
  //     log('  Can access: $canAccess');

  //     if (requiredPermissions != null) {
  //       for (final permission in requiredPermissions) {
  //         log('    Permission $permission: ${_checkPermission(permission)}');
  //       }
  //     }
  //   }

  //   log('User Pages: ${_userPages.join(", ")}');
  //   log('User Modules: ${_userModules.join(", ")}');
  // }

  // bool _checkPermission(int code) {
  //   if (PermissionsMappingService.isModuleCode(code)) {
  //     return hasModule(code);
  //   } else if (PermissionsMappingService.isPageCode(code)) {
  //     return hasPage(code);
  //   } else {
  //     return hasAction(code);
  //   }
  // }

  bool hasAction(int actionCode) {
    return _userActions.contains(actionCode);
  }

  // Check if the user has access to any of the specified actions
  bool hasAnyAction(List<int> actionCodes) {
    return actionCodes.any((code) => _userActions.contains(code));
  }

  // Check if the user has access to all specified actions
  bool hasAllActions(List<int> actionCodes) {
    return actionCodes.every((code) => _userActions.contains(code));
  }

  // Check if the user has access to a specific page
  bool hasPage(int pageCode) {
    return _userPages.contains(pageCode);
  }

  // Check if the user has access to a specific module
  bool hasModule(int moduleCode) {
    return _userModules.contains(moduleCode);
  }

  // Check if the user can access a menu item
  bool canAccessMenu(String menuId) {
    final requiredPermissions = menuPermissionMap[menuId];
    if (requiredPermissions == null || requiredPermissions.isEmpty) {
      return true; // No specific permissions required
    }

    // Check if user has any of the required permissions
    return requiredPermissions.any((code) {
      if (PermissionsMappingService.isModuleCode(code)) {
        return hasModule(code);
      } else if (PermissionsMappingService.isPageCode(code)) {
        return hasPage(code);
      } else {
        return hasAction(code);
      }
    });
  }

  bool canAccessSubMenu(String menuId, String subMenuId) {
    final key = '$menuId:$subMenuId';
    final requiredPermissions = menuPermissionMap[key];

    if (requiredPermissions == null || requiredPermissions.isEmpty) {
      // If no specific permissions for submenu, check parent menu permissions
      return canAccessMenu(menuId);
    }

    // Check if user has any of the required permissions
    bool hasPermission = requiredPermissions.any((code) {
      if (PermissionsMappingService.isModuleCode(code)) {
        return hasModule(code);
      } else if (PermissionsMappingService.isPageCode(code)) {
        return hasPage(code);
      } else {
        return hasAction(code);
      }
    });
    return hasPermission;
  }

  // Get the string representation of an action
  String? getActionName(int actionCode) {
    return PermissionsMappingService.getActionName(actionCode);
  }

  // Get the string representation of a page
  String? getPageName(int pageCode) {
    return PermissionsMappingService.getPageName(pageCode);
  }

  // Get the string representation of a module
  String? getModuleName(int moduleCode) {
    return PermissionsMappingService.getModuleName(moduleCode);
  }

  List<SidebarMenuItem> filterMenuItems(List<SidebarMenuItem> allMenuItems) {
    final filteredMenus = <SidebarMenuItem>[];

    for (final menuItem in allMenuItems) {
      // First check if user has access to the main module
      if (!canAccessMenu(menuItem.id)) {
        log('User cannot access menu: ${menuItem.id}');
        continue;
      }

      // If menu has subitems, filter them
      if (menuItem.subItems.isNotEmpty) {
        final filteredSubItems =
            menuItem.subItems.where((subItem) {
              final canAccess = canAccessSubMenu(menuItem.id, subItem.id);
              if (!canAccess) {
                log('User cannot access submenu: ${menuItem.id}:${subItem.id}');
              }
              return canAccess;
            }).toList();

        // Only include menu if it has at least one accessible submenu
        if (filteredSubItems.isEmpty) {
          log('Hiding menu ${menuItem.id} - no accessible submenus');
          continue;
        }

        // Create a new menu item with filtered subitems
        final filteredMenuItem = SidebarMenuItem(
          id: menuItem.id,
          title: menuItem.title,
          iconPath: menuItem.iconPath,
          selectedIconPath: menuItem.selectedIconPath,
          defaultPage: menuItem.defaultPage,
          iconWidth: menuItem.iconWidth,
          iconHeight: menuItem.iconHeight,
          iconPadding: menuItem.iconPadding,
          subItems: filteredSubItems,
        );

        filteredMenus.add(filteredMenuItem);
        log(
          'Added menu ${menuItem.id} with ${filteredSubItems.length} submenus',
        );
      }
      // For menus without subitems (defaultPage only)
      else if (menuItem.defaultPage != null) {
        filteredMenus.add(menuItem);
        log('Added menu ${menuItem.id} (default page only)');
      }
      // Skip menus that have neither subitems nor defaultPage
      else {
        log('Skipping menu ${menuItem.id} - no subitems or defaultPage');
      }
    }

    log('Final filtered menus: ${filteredMenus.map((m) => m.id).join(", ")}');
    return filteredMenus;
  }

  bool canAccessGlobalSettingsItem(String settingsId) {
    final requiredPermissions = globalSettingsPermissionMap[settingsId];

    if (requiredPermissions == null || requiredPermissions.isEmpty) {
      return true; // No specific permissions required
    }

    // Check if user has any of the required permissions
    return requiredPermissions.any((code) {
      if (PermissionsMappingService.isModuleCode(code)) {
        return hasModule(code);
      } else if (PermissionsMappingService.isPageCode(code)) {
        return hasPage(code);
      } else {
        return hasAction(code);
      }
    });
  }

  List<GlobalSidebarItem> filterGlobalSettingsItems(
    List<GlobalSidebarItem> allItems,
  ) {
    final filteredItems = <GlobalSidebarItem>[];

    for (final item in allItems) {
      if (canAccessGlobalSettingsItem(item.pageId)) {
        filteredItems.add(item);
        log('Added global settings item: ${item.title} (${item.pageId})');
      } else {
        log(
          'User cannot access global settings item: ${item.title} (${item.pageId})',
        );
      }
    }

    log(
      'Filtered global settings items: ${filteredItems.length}/${allItems.length}',
    );
    return filteredItems;
  }
}

// var permissionTree = [
//   {
//     "moduleName": "sales",
//     "id": "asdfds",
//     "pages": [
//       {
//         "pageName": "sales_listing",
//         "id": "dfdfd",
//         "permissions": [
//           {
//             "permissionName": "download",
//             "id": "hik",
//           }
//         ]
//       }
//     ]
// }
// ];
