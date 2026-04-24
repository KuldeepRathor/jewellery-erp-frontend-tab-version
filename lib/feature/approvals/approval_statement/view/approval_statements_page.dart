import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/view/approval_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/view/approval_statement_bottom_sheet_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_statement/view_model/approval_statement_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:svg_flutter/svg.dart';

class ApprovalStatementsPage extends StatefulWidget {
  const ApprovalStatementsPage({super.key});

  @override
  State<ApprovalStatementsPage> createState() => _ApprovalStatementsPageState();
}

class _ApprovalStatementsPageState extends State<ApprovalStatementsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ApprovalStatementsController controller = Get.put(
    ApprovalStatementsController(),
  );
  String? selectedMetalType;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _tableFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.setInitialConditions(isSearch: false);
    controller.getApprovalListingDetails(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      body: Stack(
        children: [
          KeyboardListener(
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
              onNewButtonTap: () {
                // Handle new approval action if needed
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    header: 'Approval Statements',
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
                          _buildActionBar(context),
                          const SizedBox(height: 16),
                          _buildTaggedItemDetailsHeader(),
                          _buildApprovalListTable(controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add the animated bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final shouldShowDetails = controller.selectedRowIndex.value >= 0;
              return AnimatedTaggedDetailsBottomSheet(
                isVisible: shouldShowDetails,
                onClose: () {
                  controller.resetFields();
                },
                taggingDetailsResponse: controller.taggingDetailsResponse,
                selectedItem: controller.selectedApproval.value,
                title: 'Item Details',
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTaggedItemDetailsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          Text(
            'Approval List',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        _buildStatusDropdown(),
        const SizedBox(width: 16),
        const ApprovalFilterWidget(),
        const Spacer(),
      ],
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

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        onChanged: controller.setSearchQuery,
        autofocus: true,
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

  Widget _buildApprovalListTable(ApprovalStatementsController controller) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Obx(() {
          final apiStatus = controller.getApprovalListingResponse.value.status;

          if (apiStatus == Status.COMPLETED) {
            final data = controller.getApprovalListingResponse.value.data;
            if (data?.values?.isEmpty ?? true) {
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
                          (context, index, totalWidth) => const SizedBox(),
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

            return LineWiseCustomTable(
              headers: controller.headers.toList(),
              columnWidths: controller.columnWidths.toList(),
              itemCount: data?.values?.length ?? 0,
              controller: _scrollController,
              isLoadingMore: controller.isLoadingMore.value,
              buildRow: (context, index, totalWidth) {
                final approvalDetail = data?.values?.elementAt(index);

                return SizedBox(
                  height: 54,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      canRequestFocus: false,
                      onTap: () {
                        controller.updateSelectedRow(index, approvalDetail);
                      },
                      child: Obx(
                        () => Container(
                          color:
                              controller.selectedRowIndex.value == index
                                  ? greyTextColor.withOpacity(0.1)
                                  : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: List.generate(controller.headers.length, (
                                cellIndex,
                              ) {
                                String cellContent = "-";

                                switch (cellIndex) {
                                  case 0: // Issue Number
                                    cellContent =
                                        approvalDetail?.approvalIssueNumber ??
                                        "-";
                                    break;
                                  case 1: // Issue Date
                                    cellContent = controller.formatDate(
                                      approvalDetail?.approvalDate,
                                    );
                                    break;
                                  case 2: // Party
                                    cellContent =
                                        approvalDetail?.partyName ?? "-";
                                    break;
                                  case 3:
                                    cellContent =
                                        approvalDetail?.tagBarcode ?? "-";
                                  case 4: // Tag Number
                                    cellContent =
                                        "${approvalDetail?.code}-${approvalDetail?.tag}";
                                    break;
                                  case 5: // Pieces
                                    cellContent =
                                        approvalDetail?.pieces?.toString() ??
                                        "-";
                                    break;
                                  case 6: // Gross Weight
                                    cellContent =
                                        approvalDetail?.grossWeight ?? "-";
                                    break;
                                  case 7: // Net Weight
                                    cellContent =
                                        approvalDetail?.netWeight ?? "-";
                                    break;
                                  case 8: // Receipt Date
                                    cellContent = controller.formatDate(
                                      approvalDetail?.receiptDate,
                                    );
                                    break;
                                  case 9: // Receipt Number
                                    cellContent =
                                        approvalDetail?.receiptNumber ?? "-";
                                    break;
                                  case 10: // Status
                                    cellContent = approvalDetail?.status ?? "-";
                                    break;
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
                              }),
                            ),
                          ),
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
                SizedBox(
                  height: 100,
                  child: LineWiseCustomTable(
                    headers: controller.headers.toList(),
                    columnWidths: controller.columnWidths.toList(),
                    itemCount: 0,
                    buildRow: (context, index, totalWidth) => const SizedBox(),
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
                    buildRow: (context, index, totalWidth) => const SizedBox(),
                    addBottomSpace: false,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      controller.getApprovalListingResponse.value.message ??
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
    );
  }
}
