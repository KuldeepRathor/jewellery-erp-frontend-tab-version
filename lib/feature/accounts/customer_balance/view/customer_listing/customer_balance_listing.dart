import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/customer_balance/view_model/customer_balance_listing_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:svg_flutter/svg_flutter.dart';

class CustomerBalanceListing extends StatefulWidget {
  const CustomerBalanceListing({super.key});

  @override
  State<CustomerBalanceListing> createState() => _CustomerBalanceListingState();
}

class _CustomerBalanceListingState extends State<CustomerBalanceListing> {
  final CustomerBalanceListingViewmodel controller = Get.put(
    CustomerBalanceListingViewmodel(),
  );
  final ScrollController _scrollController = ScrollController();
  final FocusNode _tableFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getCustomerListingDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _tableFocusNode.dispose();
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

  void _scrollToSelectedItem() {
    final selectedIndex = controller.selectedRowIndex.value;
    if (selectedIndex >= 0 && _scrollController.hasClients) {
      const itemHeight = 54.0;
      final scrollPosition = selectedIndex * itemHeight;

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: KeyboardListener(
        focusNode: _tableFocusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              controller.selectPreviousRow();
              _scrollToSelectedItem();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              controller.selectNextRow();
              _scrollToSelectedItem();
            }
          }
        },
        child: ActionScopeWidget(
          onNewButtonTap: () => Get.dialog(const AddCustomerDialog()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                header: 'Customer Balance',
                wantBackButton: true,
                onBackButtonTap: () {
                  Get.back();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildActionBar(),
                      const SizedBox(height: 16),
                      _buildCustomerTable(controller),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Obx(
                () => buildAddressStatusWidget(
                  address: controller.selectedAddress.value,
                  paymentStatus: controller.selectedStatus.value,
                  itemsOnHold: controller.selectedItemsonHold.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Obx(
        () => DropdownButton<String>(
          value: controller.selectedStatusFilter.value,
          icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
          elevation: 16,
          style: const TextStyle(color: primaryColor),
          underline: Container(height: 0, color: Colors.transparent),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.applyStatusFilter(newValue);
            }
          },
          items:
              controller.statusFilterOptions.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget buildAddressStatusWidget({
    required String address,
    required String paymentStatus,
    required String itemsOnHold,
  }) {
    Widget buildInfoColumn(String title, String content) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title, fontWeight: FontWeight.w700),
          const SizedBox(height: 4),
          CustomText(
            text: content,
            fontWeight: FontWeight.w500,
            color: secondaryColor,
          ),
        ],
      );
    }

    bool isValidString(String? value) {
      return value != null &&
          value.trim().isNotEmpty &&
          value != 'No items on hold';
    }

    List<Widget> infoColumns = [];
    infoColumns.add(buildInfoColumn('Address', address));
    if (isValidString(itemsOnHold)) {
      infoColumns.add(const SizedBox(width: 16));
      infoColumns.add(buildInfoColumn('Items on Hold', itemsOnHold));
    }
    if (isValidString(paymentStatus)) {
      infoColumns.add(const SizedBox(width: 16));
      infoColumns.add(buildInfoColumn('Payment Status', paymentStatus));
    }

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Container(height: 50, color: primaryColor),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: infoColumns),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        _buildStatusDropdown(),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
        const Spacer(),
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

  Widget _buildCustomerTable(CustomerBalanceListingViewmodel controller) {
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
                "Customer Balance",
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
                      controller.customerListingResponse.value.status;

                  if (apiStatus == Status.COMPLETED) {
                    // Use the filtered values instead of direct data values
                    final filteredData = controller.filteredValues;
                    if (filteredData.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
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
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svgs/error/no_records_found.svg',
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    // Return a Column with the table and total row
                    return Column(
                      children: [
                        Expanded(
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: filteredData.length,
                            controller: _scrollController,
                            isLoadingMore: controller.isLoadingMore.value,
                            buildRow: (context, index, totalWidth) {
                              final customerDetail = filteredData[index];

                              return SizedBox(
                                height: 54,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    canRequestFocus: false,
                                    onTap: () {
                                      controller.updateSelectedRow(
                                        index,
                                        customerDetail,
                                      );
                                    },
                                    child: Obx(
                                      () => Container(
                                        color:
                                            controller.selectedRowIndex.value ==
                                                    index
                                                ? greyTextColor
                                                : Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16.0,
                                            horizontal: 16.0,
                                          ),
                                          child: Row(
                                            children: List.generate(
                                              controller.headers.length,
                                              (cellIndex) {
                                                String cellContent = "-";
                                                Color textColor = Colors.black;

                                                switch (cellIndex) {
                                                  case 0:
                                                    cellContent =
                                                        "${index + 1}";
                                                    break;
                                                  case 1:
                                                    cellContent =
                                                        customerDetail.code ??
                                                        "-";
                                                    break;
                                                  case 2:
                                                    cellContent =
                                                        customerDetail.name ??
                                                        "-";
                                                    break;
                                                  case 3:
                                                    cellContent =
                                                        customerDetail
                                                            .phoneNumber ??
                                                        "-";
                                                    break;
                                                  case 4:
                                                    cellContent =
                                                        customerDetail
                                                            .invoiceNumber ??
                                                        "-";
                                                    break;
                                                  case 5:
                                                    cellContent =
                                                        convertDateTimeToString(
                                                          customerDetail.date,
                                                        );
                                                    break;
                                                  case 6:
                                                    cellContent =
                                                        customerDetail
                                                            .balanceAmount ??
                                                        "-";
                                                    break;
                                                  case 7:
                                                    cellContent =
                                                        convertDateTimeToString(
                                                          customerDetail
                                                              .dueDate,
                                                        );
                                                    break;
                                                  case 8:
                                                    cellContent =
                                                        customerDetail.status ??
                                                        "-";
                                                  case 9:
                                                    cellContent =
                                                        customerDetail
                                                            .paymentStatus ??
                                                        "-";
                                                    break;
                                                  default:
                                                    cellContent = "-";
                                                    break;
                                                }

                                                return SizedBox(
                                                  width: getColumnWidthForSingleTableCell(
                                                    totalWidth: totalWidth,
                                                    columnWidth:
                                                        controller
                                                            .columnWidths[cellIndex],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 4.0,
                                                        ),
                                                    child: Tooltip(
                                                      message: cellContent,
                                                      child: CustomText(
                                                        text: cellContent,
                                                        fontSize: 16,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        fontFamily: 'Satoshi',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Total row outside the scrollable area
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return _buildTotalRow(constraints.maxWidth);
                          },
                        ),
                      ],
                    );
                  } else if (apiStatus == Status.LOADING) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
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
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    );
                  } else if (apiStatus == Status.ERROR) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
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
                          child: Center(
                            child: Text(
                              controller
                                      .customerListingResponse
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
}

Widget _buildTotalRow(double totalWidth) {
  final CustomerBalanceListingViewmodel controller = Get.put(
    CustomerBalanceListingViewmodel(),
  );
  return Container(
    height: 54,
    margin: const EdgeInsets.only(top: 4),
    decoration: BoxDecoration(
      color: greenColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(controller.headers.length, (cellIndex) {
          String cellContent = "";

          // Display "Total" in the Customer ID column (index 1)
          if (cellIndex == 1) {
            cellContent = "Total";
          }
          // Display the total balance amount in the Balance Amount column
          else if (cellIndex == 6) {
            cellContent = controller.totalBalanceAmount.value;
          }

          return SizedBox(
            width: getColumnWidthForSingleTableCell(
              totalWidth: totalWidth,
              columnWidth: controller.columnWidths[cellIndex],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          );
        }),
      ),
    ),
  );
}
