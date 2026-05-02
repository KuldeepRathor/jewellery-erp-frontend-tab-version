// utils/menu_definitions.dart
import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/accounts/customer_balance/view/customer_listing/customer_balance_listing.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/view/journal_entry_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/payments_listing/view/payments_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/receipt_listing/view/receipt_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/booking_listing/view/booking_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view/approval_issue_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue_listing/view/approval_issue_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view/approval_receipt_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt_listing/view/approval_receipt_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/dashboard/view/dashboard.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/view/digital_coin_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/estimate_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/estimation_listing/view/estimation_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/ornament_type/view/ornament_type_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_listing/view/design_listing_view.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/stock_head_listing/view/stock_head_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view/stone_rates_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/view/customer_ledger_listing.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/lot_creation/view/lot_creation_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_listing/view/material_in_listing.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_listing/view/material_out_listing.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/reorder_level/reorder_level_listing/view/reorder_level_list_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/stock_issue/issues_stock_listing/view/stock_issue_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/miscellaneous/wanted_list/view/wanted_list_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/orders/orders_listing/view/order_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/customer_purchase/view/customer_purchase_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/purchase_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view/invoice_listing.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_listing/view/purchase_return_listing_screen.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view/repair_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_in_listing/view/branch_in_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/view/branch_out_listing_page.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_in_listing/view_model/branch_in_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/view_model/branch_out_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/view_model/daily_stock_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view_model/item_statement_report_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_dashboard.dart/view/reports_dashboard.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view_model/stock_and_value_statement_report_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view/stock_verification_report_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/create_sales_invoice_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view/sales_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return_listing/view/sales_return_listing_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/tagging/counter_transfer_listing/view/counter_transfer_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/re_tag/view/re_tag_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagged_items/items_list/view/item_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/tagging_entry_view.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/webstore_sidebar/view/banners_webstore.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/online_only_design_listing/view/web_only_products_listing.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/webstore_orders_page.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_settlements/view/webstore_settlements_page.dart';
import 'package:jewellery_erp_frontend_tab_version/model/sidebar_models/sidebar_menu_item.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';

import '../../web_store/catalogue/catalogue_listing/view/order_to_make_page.dart';
// import '../../web_store/collection/collection_listing/view/collection_listing_page.dart';

class MenuDefinitions {
  static List<SidebarMenuItem> getMenuItems() {
    // Get the full menu configuration
    final List<SidebarMenuItem> allMenuItems = _getAllMenuItems();

    // Filter based on user permissions if RBAC controller is available
    if (Get.isRegistered<RBACController>()) {
      final rbacController = Get.find<RBACController>();
      return rbacController.filterMenuItems(allMenuItems);
    }

    // Return all menu items if RBAC is not initialized yet
    return allMenuItems;
  }

  // This contains the full menu structure (same as your original getMenuItems)
  static List<SidebarMenuItem> _getAllMenuItems() {
    return [
      // Dashboard
      SidebarMenuItem(
        id: 'dashboard',
        title: 'Dashboard',
        iconPath: 'assets/svgs/dashboard.svg',
        selectedIconPath: 'assets/svgs/dashboard_selected.svg',
        defaultPage: const DashboardView(),
      ),

      SidebarMenuItem(
        id: 'sales_estimate',
        title: 'Estimate',
        iconPath: 'assets/svgs/sales.svg',
        selectedIconPath: 'assets/svgs/sales_selected.svg',
        defaultPage:  const EstimationListingPage(),
      ),

      SidebarMenuItem(
        id: 'items_list',
        title: 'Item List',
        iconPath: 'assets/svgs/inventory.svg',
        selectedIconPath: 'assets/svgs/inventory_selected.svg',
        defaultPage: const ItemListingPage(),
      ),

      // Sales
      // SidebarMenuItem(
      //   id: 'sales',
      //   title: 'Sales',
      //   iconPath: 'assets/svgs/sales.svg',
      //   selectedIconPath: 'assets/svgs/sales_selected.svg',
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'sales_invoice',
      //       title: 'Invoice',
      //       page: const SalesListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'sales_estimate',
      //       title: 'Estimate',
      //       page: const EstimationListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'sales_return',
      //       title: 'Sales Return',
      //       page: const SalesReturnListingPage(),
      //     ),
      //   ],
      // ),

      // // Tagging
      // SidebarMenuItem(
      //   id: 'tagging',
      //   title: 'Tagging',
      //   iconPath: 'assets/svgs/tagging.svg',
      //   selectedIconPath: 'assets/svgs/tagging_selected.svg',
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'tagging_lot_creation',
      //       title: 'Lot Creation',
      //       page: const LotCreationPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'tagging_new',
      //       title: 'New Tagging',
      //       page: const TaggingNewEntryPage(),
      //       requiresConfirmation: true,
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'tagging_retag',
      //       title: 'Retag',
      //       page: const ReTagView(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'tagging_stock_heads',
      //       title: 'Stock Heads',
      //       page: const StockHeadListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'tagging_designs',
      //       title: 'Designs',
      //       page: const DesignListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'tagging_stone',
      //       title: 'Stone',
      //       page: const StoneRatesPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'tagging_ornament',
      //       title: 'Ornament',
      //       page: const OrnamentType(),
      //     ),
      //   ],
      // ),

      // // Items
      // SidebarMenuItem(
      //   id: 'items',
      //   title: 'Items',
      //   iconPath: 'assets/svgs/inventory.svg',
      //   selectedIconPath: 'assets/svgs/inventory_selected.svg',
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'items_list',
      //       title: 'Item List',
      //       page: const ItemListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_verification',
      //       title: 'Item Verification',
      //       page: const StockVerificationReportsPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_issue',
      //       title: 'Item Issue(Tag)',
      //       page: const StockIssueListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_counter_transfer',
      //       title: 'Counter Transfer',
      //       page: const CounterTransferListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_branch_in_transfer',
      //       title: 'Branch In Transfer',
      //       page: const BranchInListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_branch_out_transfer',
      //       title: 'Branch Out Transfer',
      //       page: const BranchOutListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_reorder_level',
      //       title: 'Re-Order Level',
      //       page: const ReorderLevelListPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'items_wanted_list',
      //       title: 'Wanted List',
      //       page: const WantedListPage(),
      //     ),
      //   ],
      // ),

      // // Stock
      // SidebarMenuItem(
      //   id: 'stock',
      //   title: 'Stock',
      //   iconPath: 'assets/svgs/purchase.svg',
      //   selectedIconPath: 'assets/svgs/purchase_selected.svg',
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'stock_purchase',
      //       title: 'Vendor Purchase',
      //       page: const InvoiceListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'customer_purchase',
      //       title: 'Customer Purchase',
      //       page: const CustomerPurchasePage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'stock_purchase_return',
      //       title: 'Purchase Return',
      //       page: const PurchaseReturnInvoiceListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'stock_material_in',
      //       title: 'Material In',
      //       page: const MaterialInListing(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'stock_material_out',
      //       title: 'Material Out',
      //       page: const MaterialOutListing(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'stock_approval_issue',
      //       title: 'Approval Issue',
      //       page: const ApprovalIssueListingPage(),
      //       // const ApprovalIssuePage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'stock_approval_receipt',
      //       title: 'Approval Receipt',
      //       page: const ApprovalReceiptListingPage(),
      //     ),
      //   ],
      // ),

      // // Accounts
      // SidebarMenuItem(
      //   id: 'accounts',
      //   title: 'Accounts',
      //   iconPath: 'assets/svgs/customers.svg',
      //   selectedIconPath: 'assets/svgs/customers_selected.svg',
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'accounts_payments',
      //       title: 'Payments',
      //       page: const PaymentsListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'accounts_receipts',
      //       title: 'Receipts',
      //       page: const ReceiptListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'accounts_journal_entry',
      //       title: 'Journal Entry',
      //       page: const JournalEntryPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'accounts_customer_balance',
      //       title: 'Customer Balance',
      //       page: const CustomerBalanceListing(),
      //     ),
      //   ],
      // ),

      // Orders and Repairs
      // SidebarMenuItem(
      //   id: 'orders_repairs',
      //   title: 'Orders and Repairs',
      //   iconPath: 'assets/svgs/sidebar/orders.svg',
      //   selectedIconPath: 'assets/svgs/sidebar/orders.svg',
      //   iconWidth: 38,
      //   iconHeight: 20,
      //   iconPadding: 8,
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'orders_repairs_order',
      //       title: 'Order',
      //       page: const OrdersListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'orders_repairs_repair',
      //       title: 'Repair',
      //       page: const RepairListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'orders_repairs_booking',
      //       title: 'Advance Booking',
      //       page: const BookingListPage(),
      //     ),
      //   ],
      // ),

      // // Jewellery Plans
      // SidebarMenuItem(
      //   id: 'jewellery_plans',
      //   title: 'Jewellery Plans',
      //   iconPath: 'assets/svgs/estimate.svg',
      //   selectedIconPath: 'assets/svgs/estimate_selected.svg',
      //   defaultPage: const CustomerLedgerListing(),
      // ),

      // // Digital Coin
      // SidebarMenuItem(
      //   id: 'digital_coin',
      //   title: 'Digital Coin',
      //   iconPath: 'assets/svgs/sidebar/digital_coin.svg',
      //   selectedIconPath: 'assets/svgs/sidebar/digital_coin.svg',
      //   defaultPage: const DigitalCoinListingPage(),
      //   iconWidth: 38,
      //   iconHeight: 20,
      //   iconPadding: 8,
      // ),

      // // Reports
      // SidebarMenuItem(
      //   id: 'reports',
      //   title: 'Reports',
      //   iconPath: 'assets/svgs/tagging.svg',
      //   selectedIconPath: 'assets/svgs/tagging_selected.svg',
      //   defaultPage: const ReportsDashboard(),
      //   //   subItems: [
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_dashboard',
      //   //       title: 'Reports Dashboard',
      //   //       page: const ReportsDashboard(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_stock_value_statement',
      //   //       title: 'Stock and Value Statement Report',
      //   //       page: const StockAndValueStatementReport(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_branch',
      //   //       title: 'Branch Report',
      //   //       page: const BranchReportListtingPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_item_statement',
      //   //       title: 'Item Statement Report',
      //   //       page: const ItemStatementReport(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_daily_stock',
      //   //       title: 'Daily Stock Report',
      //   //       page: const DailyStockReports(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_outward',
      //   //       title: 'Outward Report',
      //   //       page: const OutwardReportPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_inward',
      //   //       title: 'Inward Report',
      //   //       page: const InwardReportPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_daily_admin_stock',
      //   //       title: 'Daily Admin Stock Report',
      //   //       page: const DailyStockAdminReportPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_daily',
      //   //       title: 'Daily Report',
      //   //       page: const DailyReportPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_tagged_item',
      //   //       title: 'Tagged Item Report',
      //   //       page: const TaggedItemReport(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_tagged_record',
      //   //       title: 'Tagged Record',
      //   //       page: const TaggedItemsListingPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_approval_statement',
      //   //       title: 'Approval Statement',
      //   //       page: const ApprovalStatementsPage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_material_outstanding',
      //   //       title: 'Material Outstanding',
      //   //       page: const MaterialOutstandingListing(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_customer_balance',
      //   //       title: 'Customer Balance',
      //   //       page: const CustomerBalanceListing(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_item_difference',
      //   //       title: 'Item Difference',
      //   //       page: const ItemDifferenceListing(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_cancelled_invoice',
      //   //       title: 'Cancelled Invoice',
      //   //       page: const CancelledInvoicePage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_stone_statement',
      //   //       title: 'Stone Statement Report',
      //   //       page: const StoneStatementReport(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_sales_report_transaction_wise',
      //   //       title: 'Sales - Transaction Wise',
      //   //       page: const SalesReportTransactionWisePage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_sales_report_date_wise',
      //   //       title: 'Sales - Date Wise',
      //   //       page: const SalesReportDateWisePage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_sales_report_month_wise',
      //   //       title: 'Sales - Month Wise',
      //   //       page: const SalesReportMonthWisePage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_purchase_report_transaction_wise',
      //   //       title: 'Purchase - Transaction Wise',
      //   //       page: const PurchaseReportTransactionWisePage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_purchase_report_date_wise',
      //   //       title: 'Purchase - Date Wise',
      //   //       page: const PurchaseReportDateWisePage(),
      //   //     ),
      //   //     SidebarSubMenuItem(
      //   //       id: 'reports_purchase_report_month_wise',
      //   //       title: 'Purchase - Month Wise',
      //   //       page: const PurchaseReportMonthWisePage(),
      //   //     ),22
      //   //   ],
      //   // ),
      // ),
      // // Web Store
      // SidebarMenuItem(
      //   id: 'web_store',
      //   title: 'Web Store',
      //   iconPath: 'assets/svgs/webstore.svg',
      //   selectedIconPath: 'assets/svgs/webstore_selected.svg',
      //   iconWidth: 38,
      //   iconHeight: 20,
      //   iconPadding: 8,
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'web_store_homepage',
      //       title: 'Banners',
      //       page: const BannersWebstore(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'web_store_catalogue',
      //       title: 'Order to Make',
      //       page: const OrderToMakeListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'web_store_collection',
      //       title: 'Collection',
      //       page: const CollectionListingPage(),
      //     ),
      //     // SidebarSubMenuItem(
      //     //   id: 'web_store_homepage',
      //     //   title: 'Banners',
      //     //   page: const HomePageWebstore(),
      //     // ),
      //     SidebarSubMenuItem(
      //       id: 'web_store_orders',
      //       title: 'Orders',
      //       page: const WebStoreOrdersPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'web_store_settlements',
      //       title: 'Settlements',
      //       page: const WebStoreSettlementsPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'web_store_online_design',
      //       title: 'Web only Products',
      //       page: const WebOnlyProductsListingPage(),
      //     ),
      //   ],
      // ),

      // Daily Rates
      // SidebarMenuItem(
      //   id: 'daily_rates',
      //   title: 'Daily Rates',
      //   iconPath: 'assets/svgs/settings.svg',
      //   selectedIconPath: 'assets/svgs/settings_selected.svg',
      //   defaultPage: const DailyRatesListingView(),
      // ),

      // Settings - Only visible to users with settings permission
      // SidebarMenuItem(
      //   id: 'settings',
      //   title: 'Settings',
      //   iconPath: 'assets/svgs/settings.svg',
      //   selectedIconPath: 'assets/svgs/settings_selected.svg',
      //   subItems: [
      //     SidebarSubMenuItem(
      //       id: 'settings_roles_permissions',
      //       title: 'Roles and Permissions',
      //       // page: const AddRolesPage(),
      //       page: const RoleslistingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_masters',
      //       title: 'Masters',
      //       page: const MasterSettingsPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_banks_payments',
      //       title: 'Banks & Payment Methods',
      //       page: const SettingsPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_print',
      //       title: 'Print',
      //       page: PrintSettingsConfigurationPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_estimation',
      //       title: 'Estimation',
      //       page:
      //           PrintSettingsConfigurationPage(), // Using PrintSettingsPage as placeholder
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_voucher',
      //       title: 'Voucher',
      //       page:
      //           PrintSettingsConfigurationPage(), // Using PrintSettingsPage as placeholder
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_branch_counters',
      //       title: 'Branch & Counters',
      //       page:
      //           PrintSettingsConfigurationPage(), // Using PrintSettingsPage as placeholder
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_employees',
      //       title: 'Employees',
      //       page: const EmployeeListingPage(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_customers',
      //       title: 'Customers',
      //       page: const CustomerListing(),
      //     ),
      //     SidebarSubMenuItem(
      //       id: 'settings_vendors',
      //       title: 'Vendors',
      //       page: const VendorListingPage(),
      //     ),
      //   ],
      // ),
    ];
  }

  // Get list of pages that require confirmation before leaving
  static List<Type> getPagesRequiringConfirmation() {
    return [
      TaggingNewEntryPage,
      CreateSalesInvoicePage,
      EstimationPage,
      PurchasePage,
      OrderToMakeListingPage,
      ApprovalIssuePage,
      ApprovalReceiptPage,
      ReTagView,
    ];
  }

  // Method to initialize view models before navigating to certain pages
  static void initializeViewModels(String menuId, String subMenuId) {
    // These are the pages that need special controller setup

    // if (menuId == 'reports') {
    //   if (subMenuId == 'reports_stock_value_statement') {
    //     Get.delete<StockAndValueStatementReportViewModel>();
    //     Get.put(StockAndValueStatementReportViewModel());
    //   } else if (subMenuId == 'reports_branch' ||
    //       subMenuId == 'items_branch_transfer') {
    //     Get.delete<BranchReportViewModel>();
    //     Get.put(BranchReportViewModel());
    //   } else if (subMenuId == 'reports_item_statement') {
    //     Get.delete<ItemStatementReportViewModel>();
    //     Get.put(ItemStatementReportViewModel());
    //   } else if (subMenuId == 'reports_daily_stock') {
    //     Get.delete<DailyStockReportViewModel>();
    //     Get.put(DailyStockReportViewModel());
    //   }
    // }

    if (subMenuId == 'reports_stock_value_statement') {
      Get.delete<StockAndValueStatementReportViewModel>();
      Get.put(StockAndValueStatementReportViewModel());
    } else if (subMenuId == 'items_branch_in_transfer') {
      Get.delete<BranchInReportViewModel>();
      Get.put(BranchInReportViewModel());
    } else if (subMenuId == 'items_branch_out_transfer') {
      Get.delete<BranchOutReportViewModel>();
      Get.put(BranchOutReportViewModel());
    } else if (subMenuId == 'reports_item_statement') {
      Get.delete<ItemStatementReportViewModel>();
      Get.put(ItemStatementReportViewModel());
    } else if (subMenuId == 'reports_daily_stock') {
      Get.delete<DailyStockReportViewModel>();
      Get.put(DailyStockReportViewModel());
    }
  }
}
