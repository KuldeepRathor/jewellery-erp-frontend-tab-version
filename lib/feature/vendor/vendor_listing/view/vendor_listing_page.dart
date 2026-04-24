import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_dashboard/view/vendor_dashboard_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/vendor_listing/view_model/vendor_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_checkbox_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_icons_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

import 'package:svg_flutter/svg_flutter.dart';

class VendorListingPage extends StatefulWidget {
  const VendorListingPage({super.key});

  @override
  State<VendorListingPage> createState() => _VendorListingPageState();
}

class _VendorListingPageState extends State<VendorListingPage> {
  final controller = Get.put<VendorListingViewmodel>(VendorListingViewmodel());
  final SidebarController sidebarController = Get.find<SidebarController>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getVendorListingDetails(resetList: true);
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
    //     Get.create<VendorListingViewmodel>(() => VendorListingViewmodel());
    // final controller = Get.find<VendorListingViewmodel>();

    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        onNewButtonTap: () {
          Get.dialog(const AddVendorDialog());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'Vendors'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    _buildVendorTable(controller),
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
          buttonName: 'Download',
        ),
        const Spacer(),
        CustomButton2(
          onTap: () {
            Get.dialog(const AddVendorDialog());
          },
          image: 'assets/svgs/add.svg',
          buttonName: 'Add New Vendor',
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
        onChanged: controller.setSeachQuery,
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

  Widget _buildVendorTable(VendorListingViewmodel controller) {
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
                "Vendor Listing",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final apiStatus =
                      controller.getVendorListingDetailsResponse.value.status;

                  if (apiStatus == Status.COMPLETED) {
                    final data =
                        controller.getVendorListingDetailsResponse.value.data;
                    if (data?.values?.isEmpty ?? true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: LineWiseCustomTable(
                              headers: controller.headers.toList(),
                              columnWidths: controller.columnWidths.toList(),
                              itemCount: 0,
                              buildRow:
                                  (context, index, totalWidth) =>
                                      const SizedBox(),
                              isLoadingMore: false,
                              addBottomSpace: false,
                            ),
                          ),
                          Expanded(
                            flex: 15,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svgs/error/no_records_found.svg',
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return LineWiseCustomTable(
                      headers: controller.headers.toList(),
                      columnWidths: controller.columnWidths.toList(),
                      itemCount: data?.values?.length ?? 0,
                      controller: _scrollController,
                      isLoadingMore: controller.isLoadingMore.value,
                      buildRow: (context, index, totalWidth) {
                        final headerValue = data?.values?.elementAt(index);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            focusColor: greyTextColor,
                            onTap: () {
                              Get.to(
                                () => VendorDashboardView(
                                  vendorId: headerValue?.id,
                                  vendorDetails: headerValue,
                                ),
                              );
                              // sidebarController.navigateToWidget(
                              //     newChild: VendorDashboardView(
                              //   vendorId: headerValue?.id,
                              //   vendorDetails: headerValue,
                              // ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  controller.headers.length,
                                  (cellIndex) {
                                    String cellContent = "-";
                                    switch (cellIndex) {
                                      case 0:
                                        cellContent = "${index + 1}";
                                        break;
                                      case 1:
                                        cellContent = headerValue?.name ?? "-";
                                        break;
                                      case 2:
                                        cellContent = headerValue?.code ?? "-";
                                        break;
                                      case 3:
                                        cellContent =
                                            headerValue?.address?.isNotEmpty ==
                                                    true
                                                ? (headerValue
                                                        ?.address
                                                        ?.first
                                                        .state ??
                                                    "-")
                                                : "-";
                                        break;
                                      case 4:
                                        cellContent =
                                            headerValue?.gstNumber ?? "-";
                                        break;
                                      case 5:
                                        cellContent = "-"; // Credit
                                        break;
                                      case 6:
                                        cellContent = "-"; // Debit
                                        break;
                                      case 7:
                                        cellContent = "-"; // Material In
                                        break;
                                      case 8:
                                        cellContent = "-"; // Material Out
                                        break;
                                      case 9:
                                        return _buildActionMenu(headerValue);
                                      default:
                                        cellContent = "-";
                                    }

                                    return SizedBox(
                                      width: getColumnWidthForSingleTableCell(
                                        totalWidth: totalWidth,
                                        columnWidth:
                                            controller.columnWidths[cellIndex],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Tooltip(
                                          message: cellContent,
                                          child: CustomText(
                                            text: cellContent,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (apiStatus == Status.LOADING) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow:
                                (context, index, totalWidth) =>
                                    const SizedBox(),
                            addBottomSpace: false,
                          ),
                        ),
                        const Expanded(
                          flex: 14,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    );
                  } else if (apiStatus == Status.ERROR) {
                    return Column(
                      children: [
                        Expanded(
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow:
                                (context, index, totalWidth) =>
                                    const SizedBox(),
                            addBottomSpace: false,
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Center(
                            child: Text(
                              controller
                                      .getVendorListingDetailsResponse
                                      .value
                                      .message ??
                                  "Something went wrong",
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionMenu(dynamic headerValue) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: CustomPopupMenuButtonWidget<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder:
            (BuildContext context) =>
                controller.popUpValues.map((element) {
                  return PopupMenuItem<String>(
                    value: element,
                    height: 0,
                    child: SizedBox(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            element,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (element != "Delete")
                            CustomDashedLineWidget(width: Get.width),
                        ],
                      ),
                    ),
                  );
                }).toList(),
        onSelected: (String value) {
          switch (value) {
            case 'Payment':
              if (headerValue?.ledger != null) {
                controller.onPaymentTapped(headerValue.ledger);
              }
              break;
            case 'Return':
              if (headerValue?.ledger != null) {
                controller.onReturnTapped(headerValue.ledger);
              }
              break;
            case 'Edit':
              controller.editVendor(headerValue?.id ?? "");
              break;
            case 'Delete':
              // Handle delete action
              break;
          }
        },
      ),
    );
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
                      'Metal/Services Type',
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
