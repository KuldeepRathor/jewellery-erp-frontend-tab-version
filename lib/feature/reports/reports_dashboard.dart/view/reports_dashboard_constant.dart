import 'package:flutter/material.dart';

class ReportsDashboardConstants {
  // Header constants
  static const String headerTitle = 'Reports';
  static const String headerSubtitle = 'Stay updated with your business';
  static const double headerHeight = 160.0;

  // Grid constants
  static const int gridCrossAxisCount = 5;
  static const double gridChildAspectRatio = 2.8;
  static const double gridCrossAxisSpacing = 8.0;
  static const double gridMainAxisSpacing = 8.0;

  // Colors
  static const Color cardColor = Color(0xFF5C6BC0);
  static const Color headerGradientStart = Color(0xFF3949AB);
  static const Color headerGradientEnd = Color(0xFF1E88E5);
  static const Color illustrationBackground = Color(0xFFE8EAF6);

  // Section titles
  static const String dailyReportsTitle = 'Daily Reports';
  static const String taggingReportsTitle = 'Tagging Reports';
  static const String itemReportsTitle = 'Item Reports';
  static const String stockReportsTitle = 'Stock Reports';
  static const String accountingReportsTitle = 'Accounting Reports';
  static const String othersTitle = 'Others';

  // Card types
  static const String dailyCardType = 'daily';
  static const String taggingCardType = 'tagging';
  static const String itemCardType = 'item';
  static const String stockCardType = 'stock';
  static const String accountingCardType = 'accounting';
  static const String othersCardType = 'others';

  // Toast messages
  static String getReportNavigationMessage(String title) =>
      'Opening $title report';

  static String getGenericReportMessage(String title) =>
      'Generating $title report';

  // Daily Reports
  static final List<Map<String, dynamic>> dailyReports = [
    {
      'title': 'Daily Report',
      'icon': Icons.calendar_today,
      'menuId': 'reports',
      'subMenuId': 'reports_daily',
      'cardType': dailyCardType,
      'pageCode': 11050,
    },
    {
      'title': 'Item Difference',
      'icon': Icons.difference,
      'menuId': 'reports',
      'subMenuId': 'reports_item_difference',
      'cardType': dailyCardType,
      'pageCode': 11100,
    },
    {
      'title': 'Daily Stock Report',
      'icon': Icons.inventory,
      'menuId': 'reports',
      'subMenuId': 'reports_daily_stock',
      'cardType': dailyCardType,
      'pageCode': 11150,
    },
    {
      'title': 'Daily Admin Stock Report',
      'icon': Icons.admin_panel_settings,
      'menuId': 'reports',
      'subMenuId': 'reports_daily_admin_stock',
      'cardType': dailyCardType,
      'pageCode': 11200,
    },
  ];

  // Tagging Reports
  static final List<Map<String, dynamic>> taggingReports = [
    {
      'title': 'Tagged Report',
      'icon': Icons.label,
      'menuId': 'reports',
      'subMenuId': 'reports_tagged_record',
      'cardType': taggingCardType,
      'pageCode': 11250,
    },
    {
      'title': 'Tagged Item Report',
      'icon': Icons.label_important,
      'menuId': 'reports',
      'subMenuId': 'reports_tagged_item',
      'cardType': taggingCardType,
      'pageCode': 11300,
    },
  ];

  // Item Reports
  static final List<Map<String, dynamic>> itemReports = [
    {
      'title': 'Item Statement',
      'icon': Icons.inventory_2,
      'menuId': 'reports',
      'subMenuId': 'reports_item_statement',
      'cardType': itemCardType,
      'pageCode': 11350,
    },
    {
      'title': 'Stone Statement',
      'icon': Icons.diamond,
      'menuId': 'reports',
      'subMenuId': 'reports_stone_statement',
      'cardType': itemCardType,
      'pageCode': 11400,
    },
    {
      'title': 'Outward Report',
      'icon': Icons.output,
      'menuId': 'reports',
      'subMenuId': 'reports_outward',
      'cardType': itemCardType,
      'pageCode': 11450,
    },
    {
      'title': 'Inward Report',
      'icon': Icons.input,
      'menuId': 'reports',
      'subMenuId': 'reports_inward',
      'cardType': itemCardType,
      'pageCode': 11500,
    },
    {
      'title': 'Approval Statement',
      'icon': Icons.approval,
      'menuId': 'reports',
      'subMenuId': 'reports_approval_statement',
      'cardType': itemCardType,
      'pageCode': 11550,
    },
  ];

  // Stock Reports
  static final List<Map<String, dynamic>> stockReports = [
    {
      'title': 'Stock and Value Statement Report',
      'icon': Icons.assessment,
      'menuId': 'reports',
      'subMenuId': 'reports_stock_value_statement',
      'cardType': stockCardType,
      'pageCode': 11600,
    },
    {
      'title': 'Material In/Out Outstanding',
      'icon': Icons.sync_alt,
      'menuId': 'reports',
      'subMenuId': 'reports_material_outstanding',
      'cardType': stockCardType,
      'pageCode': 11650,
    },
  ];

  // Accounting Reports
  static final List<Map<String, dynamic>> accountingReports = [
    {
      'title': 'Customer Balance',
      'icon': Icons.person,
      'menuId': 'reports',
      'subMenuId': 'reports_customer_balance',
      'cardType': accountingCardType,
      'pageCode': 11700,
    },
    {
      'title': 'Settlement Reports',
      'icon': Icons.receipt_long,
      'menuId': 'web_store',
      'subMenuId': 'web_store_settlements',
      'cardType': accountingCardType,
      'pageCode': 11750,
    },
  ];

  // Other Reports
  static final List<Map<String, dynamic>> otherReports = [
    {
      'title': 'Branch Report',
      'icon': Icons.store,
      'menuId': 'reports',
      'subMenuId': 'reports_branch',
      'cardType': othersCardType,
      'pageCode': 11800,
    },
    {
      'title': 'Cancelled Invoices',
      'icon': Icons.cancel,
      'menuId': 'reports',
      'subMenuId': 'reports_cancelled_invoice',
      'cardType': othersCardType,
      'pageCode': 11850,
    },
    {
      'title': 'Sales - Transaction Wise',
      'icon': Icons.point_of_sale,
      'menuId': 'reports',
      'subMenuId': 'reports_sales_report_transaction_wise',
      'cardType': othersCardType,
      'pageCode': 11900,
    },
    {
      'title': 'Sales - Date Wise',
      'icon': Icons.date_range,
      'menuId': 'reports',
      'subMenuId': 'reports_sales_report_date_wise',
      'cardType': othersCardType,
      'pageCode': 11950,
    },
    {
      'title': 'Sales - Month Wise',
      'icon': Icons.calendar_month,
      'menuId': 'reports',
      'subMenuId': 'reports_sales_report_month_wise',
      'cardType': othersCardType,
      'pageCode': 12000,
    },
    {
      'title': 'Purchase - Transaction Wise',
      'icon': Icons.point_of_sale,
      'menuId': 'reports',
      'subMenuId': 'reports_purchase_report_transaction_wise',
      'cardType': othersCardType,
      'pageCode': 12050,
    },
    {
      'title': 'Purchase - Date Wise',
      'icon': Icons.date_range,
      'menuId': 'reports',
      'subMenuId': 'reports_purchase_report_date_wise',
      'cardType': othersCardType,
      'pageCode': 12100,
    },
    {
      'title': 'Purchase - Month Wise',
      'icon': Icons.calendar_month,
      'menuId': 'reports',
      'subMenuId': 'reports_purchase_report_month_wise',
      'cardType': othersCardType,
      'pageCode': 12150,
    },
  ];
}
