import 'package:flutter/material.dart';

class DashboardConstants {
  // Carousel constants
  static const int carouselItemCount = 3;
  static const Duration autoPlayInterval = Duration(seconds: 5);
  static const Duration autoPlayAnimationDuration = Duration(milliseconds: 800);
  static const double carouselHeight = 220.0;
  static const double viewportFraction = 0.95;

  // Grid constants
  static const int gridCrossAxisCount = 7;
  static const double gridChildAspectRatio = 1.5;
  static const double gridCrossAxisSpacing = 8.0;
  static const double gridMainAxisSpacing = 8.0;

  // Section titles
  static const String dailySectionTitle = 'Zivoro Daily';
  static const String servicesSectionTitle = 'Services';
  static const String onlineSectionTitle = 'Zivoro Online';

  // Card types
  static const String dailyCardType = 'daily';
  static const String servicesCardType = 'services';
  static const String onlineCardType = 'online';

  // Daily Management Grid Items (Updated based on the new UI)
  static final List<Map<String, dynamic>> dailyActions = [
    {
      'icon': Icons.sell,
      'title': 'Sales',
      'options': [
        'Gold Invoice',
        'Silver Invoice',
        'Platinum Invoice',
        'Sales Return Invoice'
      ]
    },
    {
      'icon': Icons.calculate,
      'title': 'Estimate',
      'options': [
        'Gold Estimate',
        'Silver Estimate',
        'Platinum Estimate',
        'Old Estimate'
      ]
    },
    {
      'icon': Icons.shopping_cart,
      'title': 'Purchase',
      'options': [
        'Vendor Purchase',
        'Customer Purchase',
        'Purchase Return',
        'Material In',
        'Material Out',
        'Approval Issue',
        'Approval Receipt'
      ]
    },
    {
      'icon': Icons.label,
      'title': 'Tagging',
      'options': [
        'New Tagging',
        'Re-Tag',
        'New Design',
        'New Stone',
        'New Stock Head'
      ]
    },
    {
      'icon': Icons.format_list_bulleted,
      'title': 'Wanted List',
      'options': ['Wanted List', 'Re-Order level']
    },
    {
      'icon': Icons.inventory,
      'title': 'Items',
      'options': [
        'Item List',
        'Item Verification',
        'Issue',
        'Counter Transfer',
        'Branch Transfer'
      ]
    },
    {
      'icon': Icons.account_balance,
      'title': 'Accounts',
      'options': ['Payment', 'Receipts', 'Journal Entry']
    },
    {
      'icon': Icons.assessment,
      'title': 'Reports',
      'options': ["..."]
    },
    {
      'icon': Icons.more_horiz,
      'title': 'More',
      'options': ['Add Customer', 'Add vendors']
    },
  ];

  // Services Grid Items (Updated based on the new UI)
  static final List<Map<String, dynamic>> servicesActions = [
    {
      'icon': Icons.shopping_bag,
      'title': 'Orders',
      'options': [
        'New Order-Gold',
        'New Order-Silver',
        'New Order-Platinum',
        'View orders'
      ]
    },
    {
      'icon': Icons.build,
      'title': 'Repairs',
      'options': ['New Repair', 'View Repairs', 'View All']
    },
    {
      'icon': Icons.diamond,
      'title': 'Jewellery Plans',
      'options': ['New Plan', 'Add Installment', 'View All']
    },
    {
      'icon': Icons.monetization_on,
      'title': 'Digital Coin',
      'options': ['New Buy', 'New Delivery']
    },
    {
      'icon': Icons.calendar_today,
      'title': 'Advance Booking',
      'options': ['New Booking', 'Add advance payment', 'View Bookings']
    },
  ];

  // Online Grid Items (Updated based on the new UI)
  static final List<Map<String, dynamic>> onlineActions = [
    {
      'icon': Icons.storefront,
      'title': 'Live Webstore',
      'options': ['....']
    },
    {
      'icon': Icons.shopping_basket,
      'title': 'Order to make webstore',
      'options': ['....']
    },
    {
      'icon': Icons.notifications,
      'title': 'Send Notifications',
      'options': ['Create Notification', 'View Sent Notifications']
    },
    {
      'icon': Icons.image,
      'title': 'Banners',
      'options': ['Upload Banner', 'View Banners']
    },
  ];

  // Dialog constants
  static const String cancelPurchaseTitle = 'Cancel Purchase';
  static const String cancelPurchaseContent =
      'Are you sure you want to cancel this purchase?';
  static const String cancelNo = 'No';
  static const String cancelYes = 'Yes';
  static const String purchaseCancelSuccess = 'Purchase cancelled successfully';

  // Toast messages
  static String getSalesNavigationMessage() => 'Navigating to Sales main view';
  static String getPurchaseNavigationMessage() =>
      'Navigating to Purchase main view';
  static String getGenericNavigationMessage(String title) =>
      'Navigating to $title main view';

  static String getViewSalesMessage() => 'Viewing sales records';
  static String getCreateSaleMessage() => 'Creating new sale';
  static String getSalesReportMessage() => 'Generating sales report';

  static String getViewPurchaseMessage() => 'Viewing purchase records';
  static String getCreatePurchaseMessage() => 'Creating new purchase';
  static String getPrintPurchaseMessage() => 'Printing purchase details';

  static String getGenericActionMessage(String option, String cardTitle) =>
      'Processing $option for $cardTitle';

  static String getViewOrdersMessage() => 'Viewing all orders';
  static String getCreateOrderMessage() => 'Creating new order';
  static String getTrackOrdersMessage() => 'Tracking order status';

  static String getOpenStoreMessage() => 'Opening live webstore';
  static String getEditStoreMessage() => 'Editing webstore settings';
  static String getAnalyticsMessage() => 'Viewing webstore analytics';

  // Floating Action Button
  static const String helpSupportButtonText = 'Help & Support';
}
