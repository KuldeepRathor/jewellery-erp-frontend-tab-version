import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_dashboard/model/customer_dashboard_detail_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_dashboard/view_model/customer_dashboard_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';
import 'package:svg_flutter/svg.dart';

class CustomerDashboardView extends StatefulWidget {
  const CustomerDashboardView({super.key, this.customerId});
  final String? customerId;

  @override
  State<CustomerDashboardView> createState() => _CustomerDashboardViewState();
}

class _CustomerDashboardViewState extends State<CustomerDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  SidebarController sidebarController = Get.find();
  final CustomerDashboardViewmodel customerDashboardViewmodel = Get.put(
    CustomerDashboardViewmodel(),
  );

  final List<TabItem> _tabItems = [
    TabItem(
      'Overview',
      'Alt + L',
      'assets/svgs/vendor/dashboard.svg',
      'assets/svgs/vendor/dashboard_selected.svg',
    ),
    TabItem(
      'Receipt',
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
      'Sales',
      'Alt + H',
      'assets/svgs/vendor/purchase.svg',
      'assets/svgs/vendor/purchase_selected.svg',
    ),
    TabItem(
      'Sales Return',
      'Alt + R',
      'assets/svgs/vendor/purchase_return.svg',
      'assets/svgs/vendor/purchase_return_selected.svg',
    ),
  ];

  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabItems.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.customerId != null) {
        customerDashboardViewmodel.getCustomerDashboardDetails(
          id: widget.customerId!,
        );
      }
    });
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
            body: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      header: 'Customer Dashboard',
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
        _buildTabContent('Receipt'),
        _buildTabContent('Ledger'),
        _buildTabContent('Sales'),
        _buildTabContent('Sales Return'),
      ],
    );
  }

  Widget _buildTabContent(String tabName) {
    return Center(child: CustomText(text: '$tabName Content'));
  }

  Widget _buildOverviewTab() {
    return Obx(() {
      final apiResponse =
          customerDashboardViewmodel.getCustomerDashboardDetailsResponse.value;

      if (apiResponse.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (apiResponse.status == Status.ERROR) {
        return Center(
          child: CustomText(text: 'Error loading data: ${apiResponse.message}'),
        );
      } else if (apiResponse.status == Status.COMPLETED &&
          apiResponse.data != null) {
        final data = apiResponse.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewChart(data),
                const SizedBox(height: 12),
                // Wrap Row in IntrinsicHeight or give it a specific height
                SizedBox(
                  height: Get.height * 0.6, // Specific height for the row
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildLeftColumn(data)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightColumn(data)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Center(child: CustomText(text: 'No data available'));
      }
    });
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Widget _buildOverviewChart(CustomerDashboardDetailsResponse data) {
    final customerDetails = data.customerDetails;

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
                      CustomText(
                        text: customerDetails?.name ?? "-",
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
                        title: "Phone",
                        data:
                            customerDetails?.phoneCountryCode != null
                                ? "${customerDetails?.phoneCountryCode} ${customerDetails?.phoneNumber ?? "-"}"
                                : customerDetails?.phoneNumber ?? "-",
                      ),
                      DataDisplayWidget(
                        title: "DOB",
                        data: _formatDate(customerDetails?.dateOfBirth),
                      ),
                      DataDisplayWidget(
                        title: "Gender",
                        data: customerDetails?.gender ?? "-",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DataDisplayWidget(
                          title: "Email",
                          data: customerDetails?.email ?? "-",
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DataDisplayWidget(
                          title: "Address",
                          data: _getFullAddress(customerDetails?.address),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const DataDisplayWidget(
                        title: "Customer Since",
                        data: "-",
                      ),
                      // ignore: prefer_const_constructors
                      DataDisplayWidget(
                        title: "Bank Acc",
                        data: "-", // You can add this field when available
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "KYC Status",
                            color: primaryColor,
                            fontSize: 12,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w700,
                          ),
                          KYCStatusWidget(customerDetails: customerDetails),
                        ],
                      ),
                    ],
                  ),
                  CustomDashedLineWidget(width: Get.width),
                  Row(
                    children: [
                      DataDisplayWidget(
                        title: "Customer Outstanding Credit",
                        data: "₹ ${data.customerBalanceAmount ?? '0'}",
                        fontWeight: FontWeight.w700,
                        datafontsize: 24,
                      ),
                      SizedBox(width: Get.width * 0.04),
                      DataDisplayWidget(
                        title: "Delivery Pending",
                        data: "₹ ${data.salesDetails?.totalSalesAmount ?? '0'}",
                        fontWeight: FontWeight.w700,
                        datafontsize: 24,
                      ),
                      SizedBox(width: Get.width * 0.04),
                      DataDisplayWidget(
                        title: "Approval Pending",
                        data:
                            "₹ ${data.customerEstimationDetails?.totalEstimationAmount ?? '0'}",
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
          ),
        ],
      ),
    );
  }

  // Helper method to format address
  String _getFullAddress(List<Address>? addresses) {
    if (addresses == null || addresses.isEmpty) return "-";

    final address = addresses.first;
    List<String> parts = [];

    if (address.addressLine1 != null && address.addressLine1!.isNotEmpty) {
      parts.add(address.addressLine1!);
    }
    if (address.city != null && address.city!.isNotEmpty) {
      parts.add(address.city!);
    }
    if (address.state != null && address.state!.isNotEmpty) {
      parts.add(address.state!);
    }
    if (address.pincode != null && address.pincode!.isNotEmpty) {
      parts.add(address.pincode!);
    }

    return parts.isEmpty ? "-" : parts.join(", ");
  }

  Widget _buildLeftColumn(CustomerDashboardDetailsResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _buildHorizontalCards(data),
        // const SizedBox(height: 14),
        _buildPurchaseCards(data),
        // const SizedBox(height: 14),
        // _buildAveragePaymentDuration(),
      ],
    );
  }

  Widget _buildPurchaseCards(CustomerDashboardDetailsResponse data) {
    // Create purchase cards data from API response
    final purchaseCardsData = [
      PurchaseCardData(
        "Total Purchase",
        "Weight",
        "${data.customerPurchaseDetail?.totalPurchaseWeight ?? '0'} gm",
        "Count",
        "${data.customerPurchaseDetail?.count ?? '0'}",
        "Amount",
        "₹ ${data.customerPurchaseDetail?.totalPurchaseAmount ?? '0'}",
      ),
      PurchaseCardData(
        "Web Store Purchase",
        "", // Empty for single value card
        "", // Empty for single value card
        "", // Empty for single value card
        "", // Empty for single value card
        "", // Empty for single value card
        "₹ 0.0", // Main value displayed
      ),
      // You can add more cards as needed
    ];

    return SizedBox(
      height: Get.height * 0.18, // Adjusted height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: purchaseCardsData.length,
        itemBuilder: (context, index) {
          // For the second card type (Web Store Purchase)
          if (index == 1) {
            return _buildSingleValueCard(purchaseCardsData[index]);
          }
          // For the first card type (Total Purchase)
          return _buildDetailedPurchaseCard(purchaseCardsData[index]);
        },
      ),
    );
  }

  // New card type for detailed metrics (Weight, Count, Amount)
  Widget _buildDetailedPurchaseCard(PurchaseCardData data) {
    return Container(
      width: Get.width * 0.3,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: secondaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with metrics
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.weightTitle,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: data.weightValue,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.countTitle,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: data.countValue,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.amountTitle,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                        text: data.amountValue,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Dashed line separator
            const SizedBox(height: 8),
            CustomDashedLineWidget(width: Get.width),
            const Spacer(),

            // Bottom section with title
            CustomText(
              text: data.title,
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  // New card type for single value display (Web Store Purchase)
  Widget _buildSingleValueCard(PurchaseCardData data) {
    return Container(
      width: Get.width * 0.15,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: secondaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Large value display
            CustomText(
              text: data.amountValue,
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),

            // Dashed line separator
            CustomDashedLineWidget(width: Get.width),

            // Card title at bottom
            CustomText(
              text: data.title,
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightColumn(CustomerDashboardDetailsResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KYC Details Card
        _buildKYCDetailsCard(data.customerDetails),
        const SizedBox(height: 12),
        // Existing grid - now will work because parent has bounded height
        Expanded(child: _buildFinancialGrid(data)),
      ],
    );
  }

  Widget _buildKYCDetailsCard(CustomerDetails? customerDetails) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "KYC Details",
            fontSize: 18,
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          CustomDashedLineWidget(width: Get.width),
          const SizedBox(height: 12),
          // PAN Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "PAN Number",
                fontSize: 14,
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
              Row(
                children: [
                  CustomText(
                    text: customerDetails?.panNumber ?? "Not Provided",
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 8),
                  VerificationIconWidget(
                    isOnlineVerified: customerDetails?.isPanOnlineVerified,
                    isOfflineVerified: customerDetails?.isPanVerified,
                  ),
                  const SizedBox(width: 12),
                  // Forced KYC PAN Toggle
                  Tooltip(
                    message:
                        customerDetails?.isForcedKycPan == true
                            ? "PAN verification forced enabled"
                            : "PAN verification forced disabled",
                    child: Obx(() {
                      return customerDashboardViewmodel
                              .isUpdatingForcedKyc
                              .value
                          ? const SizedBox(
                            width: 32,
                            height: 15,
                            child: Center(
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                          : CustomToggleSwitch(
                            value: customerDetails?.isForcedKycPan ?? false,
                            onChanged: (value) {
                              if (customerDetails?.id != null) {
                                customerDashboardViewmodel.toggleForcedKycPan(
                                  customerDetails!.id!,
                                  value,
                                );
                              }
                            },
                          );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Aadhaar Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Aadhaar Number",
                fontSize: 14,
                color: primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
              Row(
                children: [
                  CustomText(
                    text: customerDetails?.aadhaarNumber ?? "Not Provided",
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 8),
                  VerificationIconWidget(
                    isOnlineVerified: customerDetails?.isAadhaarOnlineVerified,
                    isOfflineVerified: customerDetails?.isAadhaarVerified,
                  ),
                  const SizedBox(width: 12),
                  Tooltip(
                    message:
                        customerDetails?.isForcedKycAadhaar == true
                            ? "Aadhaar verification forced enabled"
                            : "Aadhaar verification forced disabled",
                    child: Obx(() {
                      return customerDashboardViewmodel
                              .isUpdatingForcedKyc
                              .value
                          ? const SizedBox(
                            width: 32,
                            height: 15,
                            child: Center(
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                          : CustomToggleSwitch(
                            value: customerDetails?.isForcedKycAadhaar ?? false,
                            onChanged: (value) {
                              if (customerDetails?.id != null) {
                                customerDashboardViewmodel
                                    .toggleForcedKycAadhaar(
                                      customerDetails!.id!,
                                      value,
                                    );
                              }
                            },
                          );
                    }),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          // GST Details
        ],
      ),
    );
  }

  Widget _buildFinancialGrid(CustomerDashboardDetailsResponse data) {
    // Define the items to display in the grid
    final gridItems = [
      GridItem(
        "OG",
        "₹ ${data.customerOldGoldDetails?.totalOldGoldAmount ?? '0'}",
      ),
      GridItem(
        "Order",
        "₹ ${data.customerOrderDetail?.totalOrderAmount ?? '0'}",
      ),
      GridItem(
        "Returns",
        "₹ ${data.salesReturnDetails?.totalSalesReturnAmount ?? '0'}",
      ),
      GridItem(
        "Advance Booking",
        "₹ ${data.customerAdvanceBookingDetails?.totalAdvanceAmount ?? '0'}",
      ),
      GridItem(
        "Digital Coins",
        "₹ ${data.customerDigitalCoinDetails?.totalDigitalCoinAmount ?? '0'}",
      ),
      GridItem(
        "Repairs",
        "₹ ${data.customerRepairDetail?.totalRepairAmount ?? '0'}",
      ),
      GridItem(
        "Jewelry Plans",
        "₹ ${data.customerJewelleryPlanDetails?.totalJewelleryPlanAmount ?? '0'}",
      ),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 7.25,
      ),
      itemCount: gridItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildGridItemCard(gridItems[index]);
      },
    );
  }

  Widget _buildGridItemCard(GridItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Title
          CustomText(
            text: item.title,
            fontSize: 16,
            color: primaryTextColor,
            fontWeight: FontWeight.w500,
          ),

          // Right side - Value
          CustomText(
            text: item.value,
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

// Model class for grid items
class GridItem {
  final String title;
  final String value;

  GridItem(this.title, this.value);
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
        Tooltip(
          message: data,
          child: CustomText(
            text: data,
            color: primaryTextColor,
            fontSize: datafontsize ?? 16,
            fontFamily: 'Satoshi',
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
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
  final String amountTitle;
  final String amountValue;

  PurchaseCardData(
    this.title,
    this.weightTitle,
    this.weightValue,
    this.countTitle,
    this.countValue,
    this.amountTitle,
    this.amountValue,
  );
}

class VerificationIconWidget extends StatelessWidget {
  final bool? isOnlineVerified;
  final bool? isOfflineVerified;
  final double size;

  const VerificationIconWidget({
    super.key,
    this.isOnlineVerified,
    this.isOfflineVerified,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnlineVerified == true) {
      return Icon(
        Icons.done_all, // Double check
        color: Colors.green,
        size: size,
      );
    }
    if (isOfflineVerified == true) {
      return Icon(
        Icons.check, // Single check
        color: Colors.green,
        size: size,
      );
    }
    return Icon(Icons.cancel, color: Colors.red, size: size);
  }
}

class KYCStatusWidget extends StatelessWidget {
  final CustomerDetails? customerDetails;

  const KYCStatusWidget({super.key, this.customerDetails});

  String getKYCStatus() {
    if (customerDetails == null) return "Not Verified";

    final panOnline = customerDetails!.isPanOnlineVerified == true;
    final panOffline = customerDetails!.isPanVerified == true;
    final aadhaarOnline = customerDetails!.isAadhaarOnlineVerified == true;
    final aadhaarOffline = customerDetails!.isAadhaarVerified == true;

    if (panOnline && aadhaarOnline) {
      return "Fully Verified";
    } else if ((panOffline || panOnline) && (aadhaarOffline || aadhaarOnline)) {
      return "Partially Verified";
    } else if (panOffline || panOnline || aadhaarOffline || aadhaarOnline) {
      return "Partially Verified";
    }
    return "Not Verified";
  }

  Color getKYCStatusColor() {
    final status = getKYCStatus();
    switch (status) {
      case "Fully Verified":
        return Colors.green;
      case "Partially Verified":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.verified_user, color: getKYCStatusColor(), size: 16),
        const SizedBox(width: 4),
        CustomText(
          text: getKYCStatus(),
          color: getKYCStatusColor(),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
