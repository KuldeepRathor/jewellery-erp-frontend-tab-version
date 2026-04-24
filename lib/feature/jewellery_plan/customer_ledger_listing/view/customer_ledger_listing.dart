import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/view_model/customer_ledger_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view/start_new_plan.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/setup_plan_listing_page.dart';
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

class CustomerLedgerListing extends StatefulWidget {
  const CustomerLedgerListing({super.key});

  @override
  State<CustomerLedgerListing> createState() => _CustomerLedgerListingState();
}

class _CustomerLedgerListingState extends State<CustomerLedgerListing> {
  // final controller =
  //     Get.put<CustomerListingViewmodel>(CustomerListingViewmodel());
  final CustomerLedgerListingViewModel controller = Get.put(
    CustomerLedgerListingViewModel(),
  );
  SidebarController sidebarController = Get.find();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getJewelleryPlanDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    //     Get.create<CustomerListingViewmodel>(() => CustomerListingViewmodel());
    // final controller = Get.find<CustomerListingViewmodel>();

    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap:
            () => sidebarController.navigateToWidget(
              newChild: const SetupPlanListingPage(),
            ),
        additionalShortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const StartNewPlanIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DownloadIntent(),
        },
        additionalActions: {
          StartNewPlanIntent: CallbackAction<StartNewPlanIntent>(
            onInvoke: (intent) {
              sidebarController.navigateToWidget(
                newChild: const StartNewPlan(),
              );
              return null;
            },
          ),
          DownloadIntent: CallbackAction<DownloadIntent>(
            onInvoke: (intent) {
              // Add your download logic here
              return null;
            },
          ),
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'Jewellery Plan'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    _buildCustomerTable(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        Theme(
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/download.svg',
          buttonName: 'Download (Ctrl+D)',
        ),
        const Spacer(),
        CustomButton2(
          onTap: () {
            sidebarController.navigateToWidget(
              newChild: const SetupPlanListingPage(),
            );
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Setup New Plan',
        ),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {
            SidebarController sidebarController = Get.find();
            sidebarController.navigateToWidget(newChild: const StartNewPlan());
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Start New Plan (Ctrl+S)',
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
        onChanged: controller.setSearchQuery,
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

  Widget _buildCustomerTable(CustomerLedgerListingViewModel controller) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Customer Ledger",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildTableStates(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableStates() {
    return Obx(() {
      final apiStatus = controller.jewelleryPlanResponse.value.status;
      log("API Status: $apiStatus");
      if (apiStatus == Status.COMPLETED) {
        return CustomTableWidget(
          headers: [controller.buildTableHeaders()],
          columnWidths: controller.columnWidths,
          rows: controller.buildRows(context),
          controller: _scrollController,
          isLoadingMore: controller.isLoadingMore.value,
          addSizedBox: true,
        );
      } else if (apiStatus == Status.LOADING) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              headers: [controller.buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: const [],
              addSizedBox: false,
            ),
            const Expanded(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        );
      } else if (apiStatus == Status.ERROR) {
        return Column(
          children: [
            CustomTableWidget(
              headers: [controller.buildTableHeaders()],
              columnWidths: controller.columnWidths,
              rows: const [],
              addSizedBox: false,
            ),
            Expanded(
              child: Center(
                child: Text(
                  controller.jewelleryPlanResponse.value.message ??
                      "Something went wrong",
                ),
              ),
            ),
          ],
        );
      } else {
        return Container(height: 10, width: 10, color: Colors.red);
      }
    });
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
