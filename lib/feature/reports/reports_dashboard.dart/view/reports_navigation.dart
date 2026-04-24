import 'dart:developer';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/customer_balance/view/customer_listing/customer_balance_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/view/approval_statements_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_outstanding/view/material_outstanding_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view/daily_reports_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_admin_report/view/daily_admin_stock_report_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/view/daily_stock_report.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/view_model/daily_stock_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/inward_reports/view/inward_report_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_difference/view/item_difference_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view/item_statement_report.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view_model/item_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/outward_reports/view/outward_report_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_date_wise/view/purchase_report_date_wise_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_month_wise/view/purchase_report_month_wise_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/purchase_report/purchase_report_transaction_wise/view/purchase_report_transaction_wise_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_dashboard.dart/view/reports_dashboard_constant.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_date_wise/view/sales_report_date_wise_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_month_wise/view/sales_report_month_wise_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/sales_report/sales_report_transaction_wise/view/sales_report_transaction_wise_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view/stock_and_value_statement_report.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view_model/stock_and_value_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stone_statement_report/view/stone_statement_report.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/tagged_item_report/view/tagged_item_report.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/cancelled_incvoice/view/cancelled_invoice_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/tagged_items/view/tagged_items_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/view/webstore_settlements_page.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';

class ReportsDashboardNavigation {
  // Get the sidebar controller
  static SidebarController getSidebarController() {
    return Get.find<SidebarController>();
  }

  // Navigate to a specific menu and submenu
  static void navigateToMenuItem(String menuId, {String? subMenuId}) {
    final controller = getSidebarController();

    if (subMenuId != null) {
      controller.selectSubMenuItem(menuId, subMenuId);
    } else {
      controller.selectMenuItem(menuId);
    }

    log('Navigated to menu: $menuId, submenu: $subMenuId');
  }

  static void handleDailyReport(String title) {
    switch (title) {
      case 'Daily Report':
        PermissionGuardUtil.withPagePermission(11050, () {
          Get.to(() => const DailyReportPage());
        });
        break;
      case 'Item Difference':
        PermissionGuardUtil.withPagePermission(11100, () {
          Get.to(() => const ItemDifferenceListing());
        });
        break;
      case 'Daily Stock Report':
        PermissionGuardUtil.withPagePermission(11150, () {
          Get.delete<DailyStockReportViewModel>();
          Get.put(DailyStockReportViewModel());
          Get.to(() => const DailyStockReports());
        });
        break;
      case 'Daily Admin Stock Report':
        PermissionGuardUtil.withPagePermission(11200, () {
          Get.to(() => const DailyStockAdminReportPage());
        });
        break;
      default:
        navigateToMenuItem('reports');
    }
  }

  static void handleTaggingReport(String title) {
    switch (title) {
      case 'Tagged Report':
        PermissionGuardUtil.withPagePermission(11250, () {
          Get.to(() => const TaggedItemsListingPage());
        });
        break;
      case 'Tagged Item Report':
        PermissionGuardUtil.withPagePermission(11300, () {
          Get.to(() => const TaggedItemReport());
        });
        break;
      default:
        navigateToMenuItem('reports');
    }
  }

  static void handleItemReport(String title) {
    switch (title) {
      case 'Item Statement':
        PermissionGuardUtil.withPagePermission(11350, () {
          Get.delete<ItemStatementReportViewModel>();
          Get.put(ItemStatementReportViewModel());
          Get.to(() => const ItemStatementReport());
        });
        break;
      case 'Stone Statement':
        PermissionGuardUtil.withPagePermission(11400, () {
          Get.to(() => const StoneStatementReport());
        });
        break;
      case 'Outward Report':
        PermissionGuardUtil.withPagePermission(11450, () {
          Get.to(() => const OutwardReportPage());
        });
        break;
      case 'Inward Report':
        PermissionGuardUtil.withPagePermission(11500, () {
          Get.to(() => const InwardReportPage());
        });
        break;
      case 'Approval Statement':
        PermissionGuardUtil.withPagePermission(11550, () {
          Get.to(() => const ApprovalStatementsPage());
        });
        break;
      default:
        navigateToMenuItem('reports');
    }
  }

  static void handleStockReport(String title) {
    switch (title) {
      case 'Stock and Value Statement Report':
        PermissionGuardUtil.withPagePermission(11600, () {
          Get.delete<StockAndValueStatementReportViewModel>();
          Get.put(StockAndValueStatementReportViewModel());
          Get.to(() => const StockAndValueStatementReport());
        });
        break;
      case 'Material In/Out Outstanding':
        PermissionGuardUtil.withPagePermission(11650, () {
          Get.to(() => const MaterialOutstandingListing());
        });
        break;
      default:
        navigateToMenuItem('reports');
    }
  }

  static void handleAccountingReport(String title) {
    switch (title) {
      case 'Customer Balance':
        PermissionGuardUtil.withPagePermission(11700, () {
          Get.to(() => const CustomerBalanceListing());
        });
        break;
      case 'Settlement Reports':
        PermissionGuardUtil.withPagePermission(11750, () {
          Get.to(() => const WebStoreSettlementsPage());
        });
        break;
      default:
        navigateToMenuItem('reports');
    }
  }

  static void handleOtherReport(String title) {
    switch (title) {
      case 'Branch Report':
        PermissionGuardUtil.withPagePermission(11800, () {
          // Get.delete<BranchReportViewModel>();
          // Get.put(BranchReportViewModel());
          // Get.to(() => const BranchReportListtingPage());
        });
        break;
      case 'Cancelled Invoices':
        PermissionGuardUtil.withPagePermission(11850, () {
          Get.to(() => const CancelledInvoicePage(wantBackButton: true));
        });
        break;
      case 'Sales - Transaction Wise':
        PermissionGuardUtil.withPagePermission(11900, () {
          Get.to(() => const SalesReportTransactionWisePage());
        });
        break;
      case 'Sales - Date Wise':
        PermissionGuardUtil.withPagePermission(11950, () {
          Get.to(() => const SalesReportDateWisePage());
        });
        break;
      case 'Sales - Month Wise':
        PermissionGuardUtil.withPagePermission(12000, () {
          Get.to(() => const SalesReportMonthWisePage());
        });
        break;
      case 'Purchase - Transaction Wise':
        PermissionGuardUtil.withPagePermission(12050, () {
          Get.to(() => const PurchaseReportTransactionWisePage());
        });
        break;
      case 'Purchase - Date Wise':
        PermissionGuardUtil.withPagePermission(12100, () {
          Get.to(() => const PurchaseReportDateWisePage());
        });
        break;
      case 'Purchase - Month Wise':
        PermissionGuardUtil.withPagePermission(12150, () {
          Get.to(() => const PurchaseReportMonthWisePage());
        });
        break;
      default:
        navigateToMenuItem('reports');
    }
  }

  // Main report tap handler
  static void handleReportTap(String title, String cardType) {
    log('Report tapped: $title in $cardType section');

    // Navigation based on card type and title
    switch (cardType) {
      case ReportsDashboardConstants.dailyCardType:
        handleDailyReport(title);
        break;
      case ReportsDashboardConstants.taggingCardType:
        handleTaggingReport(title);
        break;
      case ReportsDashboardConstants.itemCardType:
        handleItemReport(title);
        break;
      case ReportsDashboardConstants.stockCardType:
        handleStockReport(title);
        break;
      case ReportsDashboardConstants.accountingCardType:
        handleAccountingReport(title);
        break;
      case ReportsDashboardConstants.othersCardType:
        handleOtherReport(title);
        break;
    }
  }
}
