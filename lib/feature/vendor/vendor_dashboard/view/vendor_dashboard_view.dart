import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/quick_global_old_gold_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_dashboard/vendor_ledger/view/vendor_ledger_dashboard_page.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:svg_flutter/svg.dart';

class VendorDashboardView extends StatefulWidget {
  const VendorDashboardView({super.key, this.vendorId, this.vendorDetails});
  final String? vendorId;
  final GetVendorByIdResponse? vendorDetails;

  @override
  State<VendorDashboardView> createState() => _VendorDashboardViewState();
}

class _VendorDashboardViewState extends State<VendorDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  SidebarController sidebarController = Get.find();

  final List<TabItem> _tabItems = [
    TabItem(
      'Overview',
      'Alt + L',
      'assets/svgs/vendor/dashboard.svg',
      'assets/svgs/vendor/dashboard_selected.svg',
    ),
    TabItem(
      'Payment',
      'Alt + P',
      'assets/svgs/vendor/payment.svg',
      'assets/svgs/vendor/payment_selected.svg',
    ),
    TabItem(
      'Ledger',
      'Alt + G',
      'assets/svgs/vendor/ledger.svg',
      'assets/svgs/vendor/ledger_selected.svg',
    ),
    TabItem(
      'Purchase',
      'Alt + H',
      'assets/svgs/vendor/purchase.svg',
      'assets/svgs/vendor/purchase_selected.svg',
    ),
    TabItem(
      'Purchase Return',
      'Alt + R',
      'assets/svgs/vendor/purchase_return.svg',
      'assets/svgs/vendor/purchase_return_selected.svg',
    ),
  ];

  final List<HorizontalCardData> _horizontalCardsData = [
    HorizontalCardData("Total Sales", "12,05,45,000"),
    HorizontalCardData("Total Purchase", "8,55,30,000"),
    HorizontalCardData("Total Profit", "3,50,15,000"),
    HorizontalCardData("Pending Payments", "1,20,50,000"),
  ];

  final List<PurchaseCardData> _purchaseCardsData = [
    PurchaseCardData("Total Purchase", "Weight", "120000 gm", "Count", "120"),
    PurchaseCardData(
      "Last Month Purchase",
      "Weight",
      "80000 gm",
      "Count",
      "80",
    ),
  ];
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabItems.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_nameFocus);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyL):
            const SwitchToOverviewTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyP):
            const SwitchToPaymentTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyG):
            const SwitchToLedgerTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyH):
            const SwitchToPurchaseTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyR):
            const SwitchToPurchaseReturnTabIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SwitchToOverviewTabIntent: CallbackAction<SwitchToOverviewTabIntent>(
            onInvoke: (intent) {
              _tabController.animateTo(0);

              return null;
            },
          ),
          SwitchToPaymentTabIntent: CallbackAction<SwitchToPaymentTabIntent>(
            onInvoke: (intent) {
              _tabController.animateTo(1);

              log("Shortcut triggered: Tab X");

              sidebarController.selectSubMenuItem(
                'accounts',
                'accounts_payments',
              );
              return null;
            },
          ),
          SwitchToLedgerTabIntent: CallbackAction<SwitchToLedgerTabIntent>(
            onInvoke: (intent) {
              _tabController.animateTo(2);
              return null;
            },
          ),
          SwitchToPurchaseTabIntent: CallbackAction<SwitchToPurchaseTabIntent>(
            onInvoke: (intent) {
              _tabController.animateTo(3);

              sidebarController.selectSubMenuItem('stock', 'stock_purchase');
              return null;
            },
          ),
          SwitchToPurchaseReturnTabIntent:
              CallbackAction<SwitchToPurchaseReturnTabIntent>(
                onInvoke: (intent) {
                  sidebarController.selectSubMenuItem(
                    'stock',
                    'stock_purchase_return',
                  );
                  _tabController.animateTo(4);
                  return null;
                },
              ),
        },
        child: FocusScope(
          autofocus: true,
          child: Scaffold(
            backgroundColor: grey1,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Vendor Dashboard',
                  wantBackButton: true,
                  onBackButtonTap: () {
                    Get.back();
                    // SidebarController sidebarController =
                    //     Get.find<SidebarController>();

                    // sidebarController.popBackSelectedWidget();
                  },
                ),
                _buildTabBar(),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children:
            _tabItems.asMap().entries.map((entry) {
              return Expanded(
                child: InkWell(
                  onTap: () => _tabController.animateTo(entry.key),
                  child: _buildTab(entry.value, entry.key),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTab(TabItem item, int index) {
    bool isSelected = _tabController.index == index;
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? secondaryColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: item.title,
                  color: isSelected ? Colors.white : primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  text: item.shortcut,
                  fontSize: 12,
                  color:
                      isSelected ? Colors.white.withOpacity(0.8) : Colors.grey,
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            isSelected ? item.selectedIconPath : item.iconPath,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildTabContent('Payment'),
        // _buildTabContent('Ledger'),
        VendorLedgerDashboardPage(
          vendorId: widget.vendorId,
          vendorDetails: widget.vendorDetails,
        ),
        _buildTabContent('Purchase'),
        _buildTabContent('Purchase Return'),
      ],
    );
  }

  Widget _buildTabContent(String tabName) {
    return Center(child: CustomText(text: '$tabName Content'));
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewChart(),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildLeftColumn()),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: _buildRightColumn()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewChart() {
    return Container(
      height: Get.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.dialog(const QuickGlobalOldGoldDialog());
                        },
                        child: CustomText(
                          text: widget.vendorDetails?.code ?? "",
                          fontSize: 24,
                          color: primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      CustomText(
                        text: widget.vendorDetails?.name ?? "",
                        fontSize: 24,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      InkWell(
                        focusNode: _nameFocus,
                        onTap: () {
                          log("edit button is pressed");
                        },
                        child: Container(
                          height: 30,
                          width: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: grey1,
                          ),
                          child: const Center(
                            child: CustomText(
                              text: "Edit",
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomDashedLineWidget(width: Get.width),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DataDisplayWidget(
                        title: "GST",
                        data: widget.vendorDetails?.gstNumber ?? "",
                      ),
                      DataDisplayWidget(
                        title: "Bank Details",
                        data:
                            widget
                                .vendorDetails
                                ?.bankDetails
                                ?.firstOrNull
                                ?.account_number ??
                            "",
                      ),
                      DataDisplayWidget(
                        title: "PAN",
                        data: widget.vendorDetails?.panNumber ?? "",
                      ),
                    ],
                  ),
                  DataDisplayWidget(
                    title: "Address",
                    data: _formatAddress(
                      widget.vendorDetails?.address?.firstWhereOrNull(
                        (element) => element.isDefault ?? false,
                      ),
                    ),
                  ),
                  CustomDashedLineWidget(width: Get.width),
                  Row(
                    children: [
                      const DataDisplayWidget(
                        title: "Opening Balance",
                        data: "₹ 48,00,000",
                        fontWeight: FontWeight.w700,
                        datafontsize: 24,
                      ),
                      SizedBox(width: Get.width * 0.04),
                      const DataDisplayWidget(
                        title: "Opening Balance",
                        data: "₹ 48,00,000",
                        fontWeight: FontWeight.w700,
                        datafontsize: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 2, child: Container()),
          Expanded(
            flex: 4,
            child: Image.asset("assets/pngs/vendor_dashboard_background.png"),
            // SvgPicture.asset(
            //   "assets/pngs/vendor_dashboard_background.svg",
            //   fit: BoxFit.contain,
            // ),
          ),
        ],
      ),
    );
  }

  String _formatAddress(Address? address) {
    if (address == null) return "";

    final List<String?> addressParts = [
      address.addressLine1,
      address.addressLine2,
      address.city,
      address.state,
      address.country,
      address.pincode,
    ];

    // Filter out null/empty values and join with commas
    return addressParts
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(", ");
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHorizontalCards(),
        const SizedBox(height: 14),
        _buildPurchaseCards(),
        const SizedBox(height: 14),
        _buildAveragePaymentDuration(),
      ],
    );
  }

  Widget _buildHorizontalCards() {
    return SizedBox(
      height: Get.height * 0.125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _horizontalCardsData.length,
        itemBuilder:
            (context, index) => _buildInfoCard(
              title: _horizontalCardsData[index].title,
              value: _horizontalCardsData[index].value,
              width: Get.width * 0.145,
            ),
      ),
    );
  }

  Widget _buildPurchaseCards() {
    return SizedBox(
      height: Get.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _purchaseCardsData.length,
        itemBuilder:
            (context, index) =>
                _buildPurchaseInfoCard(_purchaseCardsData[index]),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required double width,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: secondaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomText(
              text: value,
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            CustomDashedLineWidget(width: width),
            CustomText(text: title, fontSize: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseInfoCard(PurchaseCardData data) {
    return Container(
      width: Get.width * 0.3,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _PurchaseInfoItem(
                  title: data.weightTitle,
                  value: data.weightValue,
                ),
                const Spacer(),
                _PurchaseInfoItem(
                  title: data.countTitle,
                  value: data.countValue,
                ),
                const Spacer(),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
            const Spacer(),
            CustomText(
              text: data.title,
              color: primaryTextColor,
              fontSize: 14,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAveragePaymentDuration() {
    return Container(
      height: Get.height * 0.125,
      width: Get.width * 0.612,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "63,05,455",
              color: primaryColor,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            CustomDashedLineWidget(width: Get.width),
            const CustomText(
              text: "Average Payment Duration",
              color: primaryTextColor,
              fontSize: 14,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightColumn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: const Center(
        child: CustomText(
          text: 'Bar Graph space',
          fontSize: 16,
          color: primaryColor,
        ),
      ),
    );
  }
}

class DataDisplayWidget extends StatelessWidget {
  final String title;
  final String data;
  final double? datafontsize;
  final FontWeight? fontWeight;

  const DataDisplayWidget({
    super.key,
    required this.title,
    required this.data,
    this.datafontsize,
    this.fontWeight,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: primaryColor,
          fontSize: 12,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          text: data,
          color: primaryTextColor,
          fontSize: datafontsize ?? 16,
          fontFamily: 'Satoshi',
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ],
    );
  }
}

class TabItem {
  final String title;
  final String shortcut;
  final String iconPath;
  final String selectedIconPath;

  TabItem(this.title, this.shortcut, this.iconPath, this.selectedIconPath);
}

class HorizontalCardData {
  final String title;
  final String value;

  HorizontalCardData(this.title, this.value);
}

class PurchaseCardData {
  final String title;
  final String weightTitle;
  final String weightValue;
  final String countTitle;
  final String countValue;

  PurchaseCardData(
    this.title,
    this.weightTitle,
    this.weightValue,
    this.countTitle,
    this.countValue,
  );
}

class _PurchaseInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _PurchaseInfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          text: value,
          color: primaryColor,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
