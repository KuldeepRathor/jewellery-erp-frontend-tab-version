import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view/approval_issue_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view/approval_receipt_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/dashboard/view/dashboard_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/estimate_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/view/design_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/add_stock_head/view/add_new_stock_head.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view/add_stone_rates_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_create/view/material_in_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view/material_out_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/purchase_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/view/purchase_return_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view/create_sales_invoice_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/sales_return/view/sales_return_page.dart';

class DashboardNavigation {
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

  // Handle daily actions navigation
  static void handleDailyAction(String cardTitle, String option) {
    switch (cardTitle) {
      case 'Sales':
        if (option == 'Gold Invoice' ||
            option == 'Silver Invoice' ||
            option == 'Platinum Invoice') {
          navigateToMenuItem('sales', subMenuId: 'sales_invoice');

          int metalType = MetalTypeUtils.gold;
          if (option == 'Silver Invoice') {
            metalType = MetalTypeUtils.silver;
          } else if (option == 'Platinum Invoice') {
            metalType = MetalTypeUtils.platinum;
          }

          getSidebarController().navigateToWidget(
            newChild: CreateSalesInvoicePage(initialTabIndex: metalType),
          );
        } else if (option == 'Sales Return Invoice') {
          navigateToMenuItem('sales', subMenuId: 'sales_return');
          getSidebarController().navigateToWidget(
            newChild: const SalesReturnPage(),
          );
        }
        break;

      case 'Estimate':
        if (option == 'Gold Estimate' ||
            option == 'Silver Estimate' ||
            option == 'Platinum Estimate') {
          navigateToMenuItem('sales', subMenuId: 'sales_estimate');

          int metalType = MetalTypeUtils.gold;
          if (option == 'Silver Estimate') {
            metalType = MetalTypeUtils.silver;
          } else if (option == 'Platinum Estimate') {
            metalType = MetalTypeUtils.platinum;
          }

          getSidebarController().navigateToWidget(
            newChild: EstimationPage(initialTabIndex: metalType),
          );
        } else if (option == 'Old Estimate') {
          navigateToMenuItem('sales', subMenuId: 'sales_estimate');
          getSidebarController().navigateToWidget(
            newChild: const EstimationPage(),
          );
        }
        break;

      // case 'Estimate':
      //   navigateToMenuItem('sales', subMenuId: 'sales_estimate');
      //   getSidebarController()
      //       .navigateToWidget(newChild: const EstimationPage());
      //   break;

      case 'Purchase':
        if (option == 'Vendor Purchase' || option == 'Customer Purchase') {
          navigateToMenuItem('stock', subMenuId: 'stock_purchase');
          getSidebarController().navigateToWidget(
            newChild: const PurchasePage(),
          );
        } else if (option == 'Purchase Return') {
          navigateToMenuItem('stock', subMenuId: 'stock_purchase_return');

          getSidebarController().navigateToWidget(
            newChild: const PurchaseReturnPage(),
          );
        } else if (option == 'Material In') {
          navigateToMenuItem('stock', subMenuId: 'stock_material_in');

          getSidebarController().navigateToWidget(
            newChild: const MaterialInPage(),
          );
        } else if (option == 'Material Out') {
          navigateToMenuItem('stock', subMenuId: 'stock_material_out');

          getSidebarController().navigateToWidget(
            newChild: const MaterialOutPage(),
          );
        } else if (option == 'Approval Issue') {
          navigateToMenuItem('stock', subMenuId: 'stock_approval_issue');

          getSidebarController().navigateToWidget(
            newChild: const ApprovalIssuePage(),
          );
        } else if (option == 'Approval Receipt') {
          navigateToMenuItem('stock', subMenuId: 'stock_approval_receipt');

          getSidebarController().navigateToWidget(
            newChild: const ApprovalReceiptPage(),
          );
        }
        break;

      case 'Tagging':
        if (option == 'New Tagging') {
          navigateToMenuItem('tagging', subMenuId: 'tagging_new');
        } else if (option == 'Re-Tag') {
          navigateToMenuItem('tagging', subMenuId: 'tagging_retag');
        } else if (option == 'New Design') {
          navigateToMenuItem('tagging', subMenuId: 'tagging_designs');
          getSidebarController().navigateToWidget(newChild: const DesignView());
        } else if (option == 'New Stone') {
          navigateToMenuItem('tagging', subMenuId: 'tagging_stone');
          Get.dialog(const AddStoneRatesDialog());
        } else if (option == 'New Stock Head') {
          navigateToMenuItem('tagging', subMenuId: 'tagging_stock_heads');

          getSidebarController().navigateToWidget(
            newChild: const AddNewStockHead(tabIndex: 0),
          );
        }
        break;

      case 'Wanted List':
        if (option == 'Wanted List') {
          navigateToMenuItem('items', subMenuId: 'items_wanted_list');
        } else if (option == 'Re-Order level') {
          navigateToMenuItem('items', subMenuId: 'items_reorder_level');
        }
        break;

      case 'Items':
        if (option == 'Item List') {
          navigateToMenuItem('items', subMenuId: 'items_list');
        } else if (option == 'Item Verification') {
          navigateToMenuItem('items', subMenuId: 'items_verification');
        } else if (option == 'Issue') {
          navigateToMenuItem('items', subMenuId: 'items_issue');
        } else if (option == 'Counter Transfer') {
          navigateToMenuItem('items', subMenuId: 'items_counter_transfer');
        } else if (option == 'Branch Transfer') {
          navigateToMenuItem('items', subMenuId: 'items_branch_transfer');
        }
        break;

      case 'Accounts':
        if (option == 'Payment') {
          navigateToMenuItem('accounts', subMenuId: 'accounts_payments');
        } else if (option == 'Receipts') {
          navigateToMenuItem('accounts', subMenuId: 'accounts_receipts');
        } else if (option == 'Journal Entry') {
          navigateToMenuItem('accounts', subMenuId: 'accounts_journal_entry');
        }
        break;

      case 'Reports':
        if (option == '...') {
          navigateToMenuItem('reports', subMenuId: 'reports_dashboard');
        }
        break;

      case 'More':
        if (option == 'Add Customer') {
          navigateToMenuItem('settings', subMenuId: 'settings_customers');
        } else if (option == 'Add vendors') {
          navigateToMenuItem('settings', subMenuId: 'settings_vendors');
        }
        break;

      default:
        navigateToMenuItem('dashboard');
    }
  }

  // Handle services actions navigation
  static void handleServicesAction(String cardTitle, String option) {
    switch (cardTitle) {
      case 'Orders':
        navigateToMenuItem('orders_repairs', subMenuId: 'orders_repairs_order');
        break;

      case 'Repairs':
        navigateToMenuItem(
          'orders_repairs',
          subMenuId: 'orders_repairs_repair',
        );
        break;

      case 'Jewellery Plans':
        navigateToMenuItem('jewellery_plans');
        break;

      case 'Digital Coin':
        navigateToMenuItem('digital_coin');
        break;

      case 'Advance Booking':
        navigateToMenuItem(
          'orders_repairs',
          subMenuId: 'orders_repairs_booking',
        );
        break;

      default:
        navigateToMenuItem('dashboard');
    }
  }

  // Handle online actions navigation
  static void handleOnlineAction(String cardTitle, String option) {
    switch (cardTitle) {
      case 'Live Webstore':
        navigateToMenuItem('web_store', subMenuId: 'web_store_homepage');
        break;

      case 'Order to make webstore':
        navigateToMenuItem('web_store', subMenuId: 'web_store_orders');
        break;

      case 'Send Notifications':
        navigateToMenuItem('web_store');
        break;

      case 'Banners':
        navigateToMenuItem('web_store', subMenuId: 'web_store_homepage');
        break;

      default:
        navigateToMenuItem('dashboard');
    }
  }

  // Main card tap handler
  static void handleCardTap(String cardTitle, String cardType) {
    log('Card tapped: $cardTitle in $cardType section');

    // Navigation based on card type and title
    switch (cardType) {
      case DashboardConstants.dailyCardType:
        _handleDailyCardTap(cardTitle);
        break;
      case DashboardConstants.servicesCardType:
        _handleServicesCardTap(cardTitle);
        break;
      case DashboardConstants.onlineCardType:
        _handleOnlineCardTap(cardTitle);
        break;
    }
  }

  // Handle daily card taps
  static void _handleDailyCardTap(String cardTitle) {
    switch (cardTitle) {
      case 'Sales':
        navigateToMenuItem('sales');
        break;
      case 'Estimate':
        navigateToMenuItem('sales', subMenuId: 'sales_estimate');
        break;
      case 'Purchase':
        navigateToMenuItem('stock');
        break;
      case 'Tagging':
        navigateToMenuItem('tagging');
        break;
      case 'Wanted List':
        navigateToMenuItem('items', subMenuId: 'items_wanted_list');
        break;
      case 'Items':
        navigateToMenuItem('items');
        break;
      case 'Accounts':
        navigateToMenuItem('accounts');
        break;
      case 'Reports':
        navigateToMenuItem('reports');
        break;
      case 'More':
        navigateToMenuItem('settings');
        break;
      default:
        navigateToMenuItem('dashboard');
    }
  }

  // Handle services card taps
  static void _handleServicesCardTap(String cardTitle) {
    switch (cardTitle) {
      case 'Orders':
        navigateToMenuItem('orders_repairs', subMenuId: 'orders_repairs_order');
        break;
      case 'Repairs':
        navigateToMenuItem(
          'orders_repairs',
          subMenuId: 'orders_repairs_repair',
        );
        break;
      case 'Jewellery Plans':
        navigateToMenuItem('jewellery_plans');
        break;
      case 'Digital Coin':
        navigateToMenuItem('digital_coin');
        break;
      case 'Advance Booking':
        navigateToMenuItem(
          'orders_repairs',
          subMenuId: 'orders_repairs_booking',
        );
        break;
      default:
        navigateToMenuItem('dashboard');
    }
  }

  // Handle online card taps
  static void _handleOnlineCardTap(String cardTitle) {
    switch (cardTitle) {
      case 'Live Webstore':
        navigateToMenuItem('web_store', subMenuId: 'web_store_homepage');
        break;
      case 'Order to make webstore':
        navigateToMenuItem('web_store', subMenuId: 'web_store_orders');
        break;
      case 'Send Notifications':
        navigateToMenuItem('web_store');
        break;
      case 'Banners':
        navigateToMenuItem('web_store', subMenuId: 'web_store_homepage');
        break;
      default:
        navigateToMenuItem('dashboard');
    }
  }
}
