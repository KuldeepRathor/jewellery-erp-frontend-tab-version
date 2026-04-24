import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/view_model/digital_coin_buy_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/digital_coin_booking_listing/view_model/digital_coin_delivery_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_delivery/view/new_delivery_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/new_digital_gold/view/digital_gold_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/digital_coin/setup_digital_coin/view/setup_digital_coin_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

import 'package:svg_flutter/svg_flutter.dart';

class DigitalCoinListingPage extends StatefulWidget {
  const DigitalCoinListingPage({super.key});

  @override
  State<DigitalCoinListingPage> createState() => _DigitalCoinListingPageState();
}

class _DigitalCoinListingPageState extends State<DigitalCoinListingPage>
    with SingleTickerProviderStateMixin {
  final customerController = Get.put(DigitalCoinDeliveryListingViewModel());
  final vendorController = Get.put(DigitalCoinBuyListingViewModel());

  final SidebarController sidebarController = Get.find<SidebarController>();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _headerText = 'Digital Coin Listing';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    vendorController.setInitialConditions(isSearch: false);
    customerController.setInitialConditions(isSearch: false);
    _tabController.addListener(_handleTabSelection);
    // controller.getCustomerInvoice(resetList: true);

    vendorController.getDigitalCoinBuyListing(resetList: true, isSearch: false);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _headerText =
            _tabController.index == 0
                ? 'Digital Coin Listing'
                : 'Digital Coin Listing';
      });
    }
    if (_tabController.index == 0) {
      vendorController.getDigitalCoinBuyListing(
        resetList: true,
        isSearch: false,
      );
    } else {
      customerController.getDigitalCoinDeliveryListing(
        resetList: true,
        isSearch: false,
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_tabController.index == 0) {
        vendorController.vendorLoadMoreItems();
      } else {
        customerController.customerLoadMoreItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap:
            () => sidebarController.navigateToWidget(
              newChild: const SetupDigitalCoinPage(),
            ),
        // Additional shortcuts for Buy Coin and Delivery
        additionalShortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB):
              const BuyCoinIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DeliveryIntent(),
        },
        // Additional actions for Buy Coin and Delivery
        additionalActions: {
          BuyCoinIntent: CallbackAction<BuyCoinIntent>(
            onInvoke: (intent) {
              sidebarController.navigateToWidget(
                newChild: const DigitalGoldPage(),
              );
              return null;
            },
          ),
          DeliveryIntent: CallbackAction<DeliveryIntent>(
            onInvoke: (intent) {
              sidebarController.navigateToWidget(
                newChild: const NewDeliveryPage(),
              );
              return null;
            },
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: _headerText),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    _buildTabBar(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildVendorTable(context),
                          _buildCustomerTable(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [Tab(text: 'Buy'), Tab(text: 'Delivery')],
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabAlignment: TabAlignment.start,
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        Material(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context).copyWith(
              focusColor: primaryColor.withBlue(190),
              tooltipTheme: const TooltipThemeData(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            child: PopupMenuButton(
              offset: const Offset(0, 45), // SET THE (X,Y) POSITION
              // iconSize: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              color: Colors.transparent,
              elevation: 4,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    enabled: false, // DISABLED THIS ITEM
                    height: 0,
                    padding: const EdgeInsets.all(0),
                    child: AvailableFilterWidget(
                      onSelectionChanged: (selectedTypes) {},
                    ),
                  ),
                ];
              },
              child: const CustomPopUpIcon(
                buttonName: 'Filter',
                image: 'assets/svgs/filter.svg',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
        const Spacer(),
        CustomButton2(
          onTap: () {
            sidebarController.navigateToWidget(
              newChild: const SetupDigitalCoinPage(),
            );
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Setup Digital Coin',
        ),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {
            sidebarController.navigateToWidget(
              newChild: const DigitalGoldPage(),
            );
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Buy Coin (Ctrl+B)',
        ),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {
            sidebarController.navigateToWidget(
              newChild: const NewDeliveryPage(),
            );
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Delivery (Ctrl+D)',
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        onChanged: (value) {
          if (_tabController.index == 0) {
            vendorController.setSearchQuery(value);
          } else {
            customerController.setSearchQuery(value);
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  Widget _buildCustomerTable(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<DigitalCoinDeliveryListingViewModel>(
          builder:
              (controller) => Obx(() => _buildCustomerTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildVendorTable(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<DigitalCoinBuyListingViewModel>(
          builder:
              (controller) => Obx(() => _buildVendorTableStates(controller)),
        ),
      ),
    );
  }

  Widget _buildCustomerTableStates(
    DigitalCoinDeliveryListingViewModel controller,
  ) {
    final apiStatus = controller.getDigitalCoinListingResponse.value.status;
    if (apiStatus == Status.COMPLETED) {
      final data = controller.getDigitalCoinListingResponse.value.data;
      log("Printing data: $data");
      if (data?.results?.isEmpty ?? true) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildCustomerInvoiceTableHeaders()],
              columnWidths: controller.delivery_column_widths,
              rows: const [],
              isLoadingMore: false,
              addSizedBox: false,
            ),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/error/no_records_found.svg',
                ),
              ),
            ),
          ],
        );
      }
      return CustomTableWidget(
        headers: [controller.buildCustomerInvoiceTableHeaders()],
        columnWidths: controller.delivery_column_widths,
        rows: controller.build_customer_invoice_rows(Get.context!),
        controller: _scrollController,
        isLoadingMore: controller.isLoadingMore.value,
      );
    } else if (apiStatus == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (apiStatus == Status.ERROR) {
      return Center(
        child: Text(
          controller.getDigitalCoinListingResponse.value.message ??
              "Something went wrong",
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildVendorTableStates(DigitalCoinBuyListingViewModel controller) {
    final apiStatus = controller.getDigitalCoinListingResponse.value.status;
    if (apiStatus == Status.COMPLETED) {
      final data = controller.getDigitalCoinListingResponse.value.data;
      log("Printing data: $data");
      if (data?.results?.isEmpty ?? true) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildVendorInvoiceTableHeaders()],
              columnWidths: controller.buy_column_widths,
              rows: const [],
              isLoadingMore: false,
              addSizedBox: false,
            ),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/error/no_records_found.svg',
                ),
              ),
            ),
          ],
        );
      } else {
        return CustomTableWidget(
          headers: [controller.buildVendorInvoiceTableHeaders()],
          columnWidths: controller.buy_column_widths,
          rows: controller.build_vendor_invoice_rows(Get.context!),
          controller: _scrollController,
          isLoadingMore: controller.isLoadingMore.value,
        );
      }
    } else if (apiStatus == Status.LOADING) {
      return const Center(child: CircularProgressIndicator());
    } else if (apiStatus == Status.ERROR) {
      return Center(
        child: Text(
          controller.getDigitalCoinListingResponse.value.message ??
              "Something went wrong",
        ),
      );
    } else {
      return Container();
    }
  }
}

class AvailableFilterWidget extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const AvailableFilterWidget({super.key, required this.onSelectionChanged});

  @override
  AvailableFilterWidgetState createState() => AvailableFilterWidgetState();
}

class AvailableFilterWidgetState extends State<AvailableFilterWidget> {
  final List<String> _metalTypes = [
    'Ring',
    'Chain',
    'Bangle',
    'Earring',
    'New Ornament',
  ];
  final List<String> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1428328B),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Colors.grey.shade300,
                onTap: () {
                  Get.back();
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/filter.svg',
                        // ignore: deprecated_member_use
                        color: redTextColor,
                      ),
                      const SizedBox(width: 8),
                      const CustomText(
                        text: "Close",
                        color: redTextColor,
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metal Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(_metalTypes.length, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCheckBoxWidget(
                          value: _selectedTypes.contains(_metalTypes[index]),
                          onChanged: (value) {
                            setState(() {
                              if (_selectedTypes.contains(_metalTypes[index])) {
                                _selectedTypes.remove(_metalTypes[index]);
                              } else {
                                _selectedTypes.add(_metalTypes[index]);
                              }
                              widget.onSelectionChanged(_selectedTypes);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _metalTypes[index],
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 16),
                CustomButton1(
                  buttonName: "Submit",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
