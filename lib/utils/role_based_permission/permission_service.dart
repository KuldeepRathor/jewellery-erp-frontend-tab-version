import 'dart:developer';

class PermissionsMappingService {
  // Mapping for module codes - UPDATED TO MATCH BACKEND
  static final Map<int, String> _moduleMap = {
    1000: "sales",
    2000: "estimate",
    3000: "sales_return",
    4000: "tagging",
    5000: "items",
    6000: "purchase",
    7000: "material_in_out",
    8000: "approval",
    9000: "accounts",
    10000: "settings",
    11000: "reports",
    15000: "rate",
    16000: "webstore",
  };

  // Mapping for page codes - UPDATED TO MATCH BACKEND
  static final Map<int, (String, String)> _pageMap = {
    // sales module (1000)
    1050: ("sales", "listing"),
    1100: ("sales", "invoice"),

    // estimate module (2000)
    2050: ("estimate", "listing"),
    2100: ("estimate", "estimate"),

    // sales_return module (3000)
    3050: ("sales_return", "listing"),
    3100: ("sales_return", "sales_return_invoice"),

    // tagging module (4000)
    4050: ("tagging", "lot"),
    4100: ("tagging", "new_tagging"),
    4150: ("tagging", "re_tag"),
    4200: ("tagging", "stock_head"),
    4250: ("tagging", "designs"),
    4300: ("tagging", "stone"),
    4350: ("tagging", "ornament"),

    // items module (5000)
    5050: ("items", "item_list"),
    5100: ("items", "item_verification"),
    5150: ("items", "item_issue"),
    5200: ("items", "counter_transfer"),
    5250: ("items", "branch_transfer"),
    5300: ("items", "re_order_level"),
    5350: ("items", "wanted_list"),

    // purchase module (6000)
    6050: ("purchase", "customer_purchase"),
    6100: ("purchase", "vendor_purchase"),
    6150: ("purchase", "service_purchase"),

    // material_in_out module (7000)
    7050: ("material_in_out", "material_in_out"),

    // approval module (8000)
    8050: ("approval", "approval_issue_receipt"),

    // accounts module (9000)
    9050: ("accounts", "payments"),
    9100: ("accounts", "receipts"),
    9150: ("accounts", "journal"),

    // settings module (10000)
    10050: ("settings", "settings"),

    // reports module (11000)
    11050: ("reports", "daily_report"),
    11100: ("reports", "item_difference"),
    11150: ("reports", "daily_stock_report"),
    11200: ("reports", "daily_admin_stock_report"),
    11250: ("reports", "tagged_report"),
    11300: ("reports", "tagged_item_report"),
    11350: ("reports", "item_statement"),
    11400: ("reports", "stone_statement"),
    11450: ("reports", "outward_report"),
    11500: ("reports", "inward_report"),
    11550: ("reports", "approval_statement"),
    11600: ("reports", "stock_and_value_statement_report"),
    11650: ("reports", "material_inout_outstanding"),
    11700: ("reports", "customer_balance"),
    11750: ("reports", "settlement_reports"),
    11800: ("reports", "branch_report"),
    11850: ("reports", "cancelled_invoices"),
    11900: ("reports", "sales_transaction_wise"),
    11950: ("reports", "sales_date_wise"),
    12000: ("reports", "sales_month_wise"),
    12050: ("reports", "purchase_transaction_wise"),
    12100: ("reports", "purchase_date_wise"),
    12150: ("reports", "purchase_month_wise"),

    // rate module (15000)
    15050: ("rate", "rate"),

    // webstore module (16000)
    16050: ("webstore", "settings"),
  };

  // Mapping for action codes - UPDATED TO MATCH BACKEND
  static final Map<int, (String, String, String)> _actionMap = {
    // sales > listing
    1051: ("sales", "listing", "view_listing"),
    1052: ("sales", "listing", "view_invoice_details"),
    1053: ("sales", "listing", "cancel_invoice"),
    1054: ("sales", "listing", "download"),

    // sales > invoice
    1101: ("sales", "invoice", "create_invoice"),
    1102: ("sales", "invoice", "alter_rate"),
    1103: ("sales", "invoice", "correction_mode"),
    1104: ("sales", "invoice", "manual_tag_entry"),
    1105: ("sales", "invoice", "change_payment_date"),

    // estimate > listing
    2051: ("estimate", "listing", "view_listing"),
    2052: ("estimate", "listing", "download"),

    // estimate > estimate
    2101: ("estimate", "estimate", "create_estimate"),
    2102: ("estimate", "estimate", "alter_rate"),
    2103: ("estimate", "estimate", "correction_mode"),
    2104: ("estimate", "estimate", "manual_tag_entry"),
    2105: ("estimate", "estimate", "change_payment_date"),

    // sales_return > listing
    3051: ("sales_return", "listing", "view_listing"),
    3052: ("sales_return", "listing", "view_invoice"),

    // sales_return > sales_return_invoice
    3101: ("sales_return", "sales_return_invoice", "create_invoice"),
    3102: ("sales_return", "sales_return_invoice", "edit_wt_rate_va_mc"),

    // tagging > lot
    4051: ("tagging", "lot", "create_lot"),
    4052: ("tagging", "lot", "edit_lot"),
    4053: ("tagging", "lot", "complete_lot"),
    4054: ("tagging", "lot", "cancel_lot"),

    // tagging > new_tagging
    4101: ("tagging", "new_tagging", "create"),

    // tagging > re_tag
    4151: ("tagging", "re_tag", "re_tag"),

    // tagging > stock_head
    4201: ("tagging", "stock_head", "view_stock_head"),
    4202: ("tagging", "stock_head", "create_new"),
    4203: ("tagging", "stock_head", "edit"),
    4204: ("tagging", "stock_head", "delete"),
    4205: ("tagging", "stock_head", "download"),

    // tagging > designs
    4251: ("tagging", "designs", "view_designs"),
    4252: ("tagging", "designs", "create_new"),
    4253: ("tagging", "designs", "edit"),
    4254: ("tagging", "designs", "delete"),
    4255: ("tagging", "designs", "download"),

    // tagging > stone
    4301: ("tagging", "stone", "view_stones"),
    4302: ("tagging", "stone", "create_new"),
    4303: ("tagging", "stone", "edit"),
    4304: ("tagging", "stone", "delete"),
    4305: ("tagging", "stone", "download"),

    // tagging > ornament
    4351: ("tagging", "ornament", "view_ornaments"),
    4352: ("tagging", "ornament", "create_new"),
    4353: ("tagging", "ornament", "edit"),
    4354: ("tagging", "ornament", "delete"),
    4355: ("tagging", "ornament", "download"),

    // items > item_list
    5051: ("items", "item_list", "view_item_list"),
    5052: ("items", "item_list", "edit"),
    5053: ("items", "item_list", "enable_disable_webstore"),
    5054: ("items", "item_list", "download"),

    // items > item_verification
    5101: ("items", "item_verification", "view"),
    5102: ("items", "item_verification", "manual_tag_entry"),

    // items > item_issue
    5151: ("items", "item_issue", "view_issue"),
    5152: ("items", "item_issue", "create_new"),

    // items > counter_transfer
    5201: ("items", "counter_transfer", "view_counter_transfers"),
    5202: ("items", "counter_transfer", "create_new"),

    // items > branch_transfer
    5251: ("items", "branch_transfer", "view_branch_transfers"),
    5252: ("items", "branch_transfer", "create_new"),

    // items > re_order_level
    5301: ("items", "re_order_level", "view"),
    5302: ("items", "re_order_level", "create"),
    5303: ("items", "re_order_level", "edit"),
    5304: ("items", "re_order_level", "download"),

    // items > wanted_list
    5351: ("items", "wanted_list", "view"),
    5352: ("items", "wanted_list", "download"),

    // purchase > customer_purchase
    6051: ("purchase", "customer_purchase", "view_listings"),
    6052: ("purchase", "customer_purchase", "view_invoice"),
    6053: ("purchase", "customer_purchase", "create"),
    6054: ("purchase", "customer_purchase", "cancel"),
    6055: ("purchase", "customer_purchase", "download"),

    // purchase > vendor_purchase
    6101: ("purchase", "vendor_purchase", "view_listings"),
    6102: ("purchase", "vendor_purchase", "view_invoice"),
    6103: ("purchase", "vendor_purchase", "view_attachment"),
    6104: ("purchase", "vendor_purchase", "create"),
    6105: ("purchase", "vendor_purchase", "cancel"),
    6106: ("purchase", "vendor_purchase", "download"),

    // purchase > service_purchase
    6151: ("purchase", "service_purchase", "view_listings"),
    6152: ("purchase", "service_purchase", "view_invoice"),
    6153: ("purchase", "service_purchase", "view_attachment"),
    6154: ("purchase", "service_purchase", "create"),
    6155: ("purchase", "service_purchase", "cancel"),
    6156: ("purchase", "service_purchase", "download"),

    // material_in_out > material_in_out
    7051: ("material_in_out", "material_in_out", "view_listings"),
    7052: ("material_in_out", "material_in_out", "view_invoice"),
    7053: ("material_in_out", "material_in_out", "create"),
    7054: ("material_in_out", "material_in_out", "cancel"),
    7055: ("material_in_out", "material_in_out", "download"),

    // approval > approval_issue_receipt
    8051: ("approval", "approval_issue_receipt", "view_listings"),
    8052: ("approval", "approval_issue_receipt", "create_new"),
    8053: ("approval", "approval_issue_receipt", "cancel"),
    8054: ("approval", "approval_issue_receipt", "download"),

    // accounts > payments
    9051: ("accounts", "payments", "view_listings"),
    9052: ("accounts", "payments", "create_new"),
    9053: ("accounts", "payments", "change_entry_date"),
    9054: ("accounts", "payments", "change_payment_date"),
    9055: ("accounts", "payments", "cancel"),
    9056: ("accounts", "payments", "download"),

    // accounts > receipts
    9101: ("accounts", "receipts", "view_listings"),
    9102: ("accounts", "receipts", "create_new"),
    9103: ("accounts", "receipts", "change_entry_date"),
    9104: ("accounts", "receipts", "change_payment_date"),
    9105: ("accounts", "receipts", "cancel"),
    9106: ("accounts", "receipts", "download"),

    // accounts > journal
    9151: ("accounts", "journal", "view_listings"),
    9152: ("accounts", "journal", "create_new"),
    9153: ("accounts", "journal", "change_entry_date"),
    9154: ("accounts", "journal", "change_payment_date"),
    9155: ("accounts", "journal", "cancel"),
    9156: ("accounts", "journal", "download"),

    // settings
    10051: ("settings", "settings", "settings_access"),

    // reports (each report gets: view, show_total, download)
    11051: ("reports", "daily_report", "view"),
    11052: ("reports", "daily_report", "show_total"),
    11053: ("reports", "daily_report", "download"),
    11101: ("reports", "item_difference", "view"),
    11102: ("reports", "item_difference", "show_total"),
    11103: ("reports", "item_difference", "download"),
    11151: ("reports", "daily_stock_report", "view"),
    11152: ("reports", "daily_stock_report", "show_total"),
    11153: ("reports", "daily_stock_report", "download"),
    11201: ("reports", "daily_admin_stock_report", "view"),
    11202: ("reports", "daily_admin_stock_report", "show_total"),
    11203: ("reports", "daily_admin_stock_report", "download"),
    11251: ("reports", "tagged_report", "view"),
    11252: ("reports", "tagged_report", "show_total"),
    11253: ("reports", "tagged_report", "download"),
    11301: ("reports", "tagged_item_report", "view"),
    11302: ("reports", "tagged_item_report", "show_total"),
    11303: ("reports", "tagged_item_report", "download"),
    11351: ("reports", "item_statement", "view"),
    11352: ("reports", "item_statement", "show_total"),
    11353: ("reports", "item_statement", "download"),
    11401: ("reports", "stone_statement", "view"),
    11402: ("reports", "stone_statement", "show_total"),
    11403: ("reports", "stone_statement", "download"),
    11451: ("reports", "outward_report", "view"),
    11452: ("reports", "outward_report", "show_total"),
    11453: ("reports", "outward_report", "download"),
    11501: ("reports", "inward_report", "view"),
    11502: ("reports", "inward_report", "show_total"),
    11503: ("reports", "inward_report", "download"),
    11551: ("reports", "approval_statement", "view"),
    11552: ("reports", "approval_statement", "show_total"),
    11553: ("reports", "approval_statement", "download"),
    11601: ("reports", "stock_and_value_statement_report", "view"),
    11602: ("reports", "stock_and_value_statement_report", "show_total"),
    11603: ("reports", "stock_and_value_statement_report", "download"),
    11651: ("reports", "material_inout_outstanding", "view"),
    11652: ("reports", "material_inout_outstanding", "show_total"),
    11653: ("reports", "material_inout_outstanding", "download"),
    11701: ("reports", "customer_balance", "view"),
    11702: ("reports", "customer_balance", "show_total"),
    11703: ("reports", "customer_balance", "download"),
    11751: ("reports", "settlement_reports", "view"),
    11752: ("reports", "settlement_reports", "show_total"),
    11753: ("reports", "settlement_reports", "download"),
    11801: ("reports", "branch_report", "view"),
    11802: ("reports", "branch_report", "show_total"),
    11803: ("reports", "branch_report", "download"),
    11851: ("reports", "cancelled_invoices", "view"),
    11852: ("reports", "cancelled_invoices", "show_total"),
    11853: ("reports", "cancelled_invoices", "download"),
    11901: ("reports", "sales_transaction_wise", "view"),
    11902: ("reports", "sales_transaction_wise", "show_total"),
    11903: ("reports", "sales_transaction_wise", "download"),
    11951: ("reports", "sales_date_wise", "view"),
    11952: ("reports", "sales_date_wise", "show_total"),
    11953: ("reports", "sales_date_wise", "download"),
    12001: ("reports", "sales_month_wise", "view"),
    12002: ("reports", "sales_month_wise", "show_total"),
    12003: ("reports", "sales_month_wise", "download"),
    12051: ("reports", "purchase_transaction_wise", "view"),
    12052: ("reports", "purchase_transaction_wise", "show_total"),
    12053: ("reports", "purchase_transaction_wise", "download"),
    12101: ("reports", "purchase_date_wise", "view"),
    12102: ("reports", "purchase_date_wise", "show_total"),
    12103: ("reports", "purchase_date_wise", "download"),
    12151: ("reports", "purchase_month_wise", "view"),
    12152: ("reports", "purchase_month_wise", "show_total"),
    12153: ("reports", "purchase_month_wise", "download"),

    // rate
    15051: ("rate", "rate", "view_rate_page"),
    15052: ("rate", "rate", "update_rates"),

    // webstore
    16051: ("webstore", "settings", "settings_access"),
  };

  /// Check if a code is a module code (multiple of 1000)
  static bool isModuleCode(int code) {
    return code >= 1000 && code % 1000 == 0;
  }

  /// Check if a code is a page code (multiple of 50 but not multiple of 1000)
  static bool isPageCode(int code) {
    return code >= 1000 && code % 50 == 0 && code % 1000 != 0;
  }

  /// Check if a code is an action code (not a module or page code)
  static bool isActionCode(int code) {
    return code >= 1000 && !isModuleCode(code) && !isPageCode(code);
  }

  /// Get the human-readable name for a module code
  static String? getModuleName(int moduleCode) {
    return _moduleMap[moduleCode];
  }

  /// Get the human-readable name for a page code
  static String? getPageName(int pageCode) {
    final pageInfo = _pageMap[pageCode];
    if (pageInfo != null) {
      return '${pageInfo.$1}.${pageInfo.$2}';
    }
    return null;
  }

  /// Get the human-readable name for an action code
  static String? getActionName(int actionCode) {
    final actionInfo = _actionMap[actionCode];
    if (actionInfo != null) {
      return '${actionInfo.$1}.${actionInfo.$2}.${actionInfo.$3}';
    }
    return null;
  }

  /// Get the display name for a module code (capitalized)
  static String getModuleDisplayName(int moduleCode) {
    final moduleName = _moduleMap[moduleCode];
    if (moduleName != null) {
      return _capitalizeFirstLetter(moduleName.replaceAll('_', ' '));
    }
    return 'Unknown Module';
  }

  /// Get the display name for a page code (capitalized)
  static String getPageDisplayName(int pageCode) {
    final pageInfo = _pageMap[pageCode];
    if (pageInfo != null) {
      return _capitalizeFirstLetter(pageInfo.$2.replaceAll('_', ' '));
    }
    return 'Unknown Page';
  }

  /// Get the display name for an action code (capitalized)
  static String getActionDisplayName(int actionCode) {
    final actionInfo = _actionMap[actionCode];
    if (actionInfo != null) {
      return _capitalizeFirstLetter(actionInfo.$3.replaceAll('_', ' '));
    }
    return 'Unknown Action';
  }

  /// Get the full action display path for an action code
  static String getFullActionDisplayPath(int actionCode) {
    final actionInfo = _actionMap[actionCode];
    if (actionInfo != null) {
      final module = _capitalizeFirstLetter(actionInfo.$1.replaceAll('_', ' '));
      final page = _capitalizeFirstLetter(actionInfo.$2.replaceAll('_', ' '));
      final action = _capitalizeFirstLetter(actionInfo.$3.replaceAll('_', ' '));
      return '$module > $page > $action';
    }
    return 'Unknown Action';
  }

  /// Get the module code from an action code
  static int? getModuleCodeFromAction(int actionCode) {
    final actionInfo = _actionMap[actionCode];
    if (actionInfo != null) {
      final moduleName = actionInfo.$1;
      for (final entry in _moduleMap.entries) {
        if (entry.value == moduleName) {
          return entry.key;
        }
      }
    }
    return null;
  }

  /// Get the page code from an action code
  static int? getPageCodeFromAction(int actionCode) {
    final actionInfo = _actionMap[actionCode];
    if (actionInfo != null) {
      final moduleName = actionInfo.$1;
      final pageName = actionInfo.$2;
      for (final entry in _pageMap.entries) {
        if (entry.value.$1 == moduleName && entry.value.$2 == pageName) {
          return entry.key;
        }
      }
    }
    return null;
  }

  /// Helper method to capitalize the first letter of a string
  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Get all action codes for a specific page
  static List<int> getActionsForPage(int pageCode) {
    final pageInfo = _pageMap[pageCode];
    if (pageInfo == null) return [];

    final moduleName = pageInfo.$1;
    final pageName = pageInfo.$2;

    return _actionMap.entries
        .where((entry) =>
            entry.value.$1 == moduleName && entry.value.$2 == pageName)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get all page codes for a specific module
  static List<int> getPagesForModule(int moduleCode) {
    final moduleName = _moduleMap[moduleCode];
    if (moduleName == null) return [];

    return _pageMap.entries
        .where((entry) => entry.value.$1 == moduleName)
        .map((entry) => entry.key)
        .toList();
  }

  /// Check if a permission code is valid
  static bool isValidPermissionCode(int code) {
    if (isModuleCode(code)) {
      return _moduleMap.containsKey(code);
    } else if (isPageCode(code)) {
      return _pageMap.containsKey(code);
    } else {
      return _actionMap.containsKey(code);
    }
  }

  /// Add a new permission mapping or update an existing one
  static void addOrUpdatePermissionMapping(
      int code, String moduleName, String pageName, String? actionName) {
    if (isModuleCode(code)) {
      _moduleMap[code] = moduleName.toLowerCase();
      log('Added/updated module mapping: $code -> $moduleName');
    } else if (isPageCode(code)) {
      _pageMap[code] = (moduleName.toLowerCase(), pageName.toLowerCase());
      log('Added/updated page mapping: $code -> $moduleName.$pageName');
    } else if (actionName != null) {
      _actionMap[code] = (
        moduleName.toLowerCase(),
        pageName.toLowerCase(),
        actionName.toLowerCase()
      );
      log('Added/updated action mapping: $code -> $moduleName.$pageName.$actionName');
    }
  }

  /// Get all module codes
  static List<int> getAllModuleCodes() {
    return _moduleMap.keys.toList();
  }

  /// Get all page codes
  static List<int> getAllPageCodes() {
    return _pageMap.keys.toList();
  }

  /// Get all action codes
  static List<int> getAllActionCodes() {
    return _actionMap.keys.toList();
  }
}
