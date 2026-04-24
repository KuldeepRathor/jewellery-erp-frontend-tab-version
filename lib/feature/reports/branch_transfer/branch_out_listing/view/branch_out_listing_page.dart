import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view/widget/branch_out/branch_out_transfer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/view_model/branch_out_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/branch_out_transfer_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
import 'package:svg_flutter/svg.dart';

class _BranchTransferIntent extends Intent {
  const _BranchTransferIntent();
}

class _ItemDetailsIntent extends Intent {
  const _ItemDetailsIntent();
}

class BranchOutListingPage extends GetView<BranchOutReportViewModel> {
  const BranchOutListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        // onNewButtonTap: () {
        //   PermissionGuardUtil.withActionPermission(
        //     5252,
        //     () {
        //       Get.dialog(const AddNewBranchDialog());
        //     },
        //   );
        // },
        additionalShortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB):
              const _BranchTransferIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI):
              const _ItemDetailsIntent(),
        },
        additionalActions: {
          _BranchTransferIntent: CallbackAction<_BranchTransferIntent>(
            onInvoke: (intent) {
              Get.delete<BranchOutTransferViewModel>();
              Get.put(BranchOutTransferViewModel());
              SidebarController sidebarController =
                  Get.find<SidebarController>();

              sidebarController.navigateToWidget(
                newChild: const BranchOutTransferPage(),
              );
              return null;
            },
          ),
          _ItemDetailsIntent: CallbackAction<_ItemDetailsIntent>(
            onInvoke: (intent) {
              controller.itemDetailsShow.value =
                  !controller.itemDetailsShow.value;
              controller.update();
              return null;
            },
          ),
        },
        child: GetBuilder<BranchOutReportViewModel>(
          builder: (_) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderWidget(
                        header: 'Branch Out Report',
                        isReport: true,
                        wantBackButton: true,
                        onBackButtonTap: () {
                          Get.back();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildActionBar(context),
                            const SizedBox(height: 16),
                            _buildContent(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.725,
      child: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTableStates(context),
          ),
        );
      }),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        const Spacer(),
        _buildBranchTransferButton(),
        const SizedBox(width: 16),
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

  Widget _buildBranchTransferButton() {
    return CustomButton2(
      onTap: () {
        Get.delete<BranchOutTransferViewModel>();
        Get.put(BranchOutTransferViewModel());
        SidebarController sidebarController = Get.find<SidebarController>();

        sidebarController.navigateToWidget(
          newChild: const BranchOutTransferPage(),
        );
      },
      image: 'assets/svgs/add.svg',
      buttonName: 'Branch Transfer (Ctrl+B)',
    );
  }

  Widget _buildTableStates(BuildContext context) {
    return Obx(() {
      final apiStatus = controller.getBranchOutReportResponse.value.status;
      final branchOutData = controller.getBranchOutReportResponse.value.data;

      if (apiStatus == Status.COMPLETED) {
        if (branchOutData?.values?.isEmpty ?? true) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  controller: controller.scrollController,
                  children: [
                    CustomTableWidget(
                      headers: [_buildTableHeaders()],
                      columnWidths: controller.columnWidths,
                      rows: const [],
                      addSizedBox: true,
                    ),
                  ],
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                controller: controller.scrollController,
                children: [
                  CustomTableWidget(
                    headers: [_buildTableHeaders()],
                    columnWidths: controller.columnWidths,
                    rows: _buildRows(context),
                    addSizedBox: true,
                  ),
                ],
              ),
            ),
            if (controller.itemDetailsShow.value)
              _buildItemDetailsPanel(context),
          ],
        );
      } else if (apiStatus == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (apiStatus == Status.ERROR) {
        return Center(
          child: Text(
            controller.getBranchOutReportResponse.value.message ??
                "Something went wrong",
          ),
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildItemDetailsPanel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(40, 50, 139, 0.08),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Item Details (F2)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomDashedLineWidget(
                width: MediaQuery.of(context).size.width / 1.4,
              ),
              const SizedBox(height: 8),
              GetBuilder<BranchOutReportViewModel>(
                builder: (_) {
                  return const SizedBox(
                    height: 120,
                    // child: BranchOutItemPreviewWidget(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildTableHeaders() {
    List<Widget> cells = [];
    for (var i = 0; i < controller.headers.length; i++) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: CustomText(
                text: controller.headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return TableRow(children: cells);
  }

  List<TableRow> _buildRows(BuildContext context) {
    return List.generate(
      controller.getBranchOutReportResponse.value.data?.values?.length ?? 0,
      (index) => _buildTableRow(index),
    );
  }

  String _formatDate(dynamic dateInput) {
    if (dateInput == null) return "-";

    DateTime? date;
    if (dateInput is DateTime) {
      date = dateInput;
    } else if (dateInput is String) {
      try {
        date = DateTime.parse(dateInput);
      } catch (e) {
        log('Error parsing date string: $e');
        return dateInput;
      }
    }

    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return "-";
    }
  }

  TableRow _buildTableRow(int index) {
    List<Widget> cells = [];
    final branchOut = controller.getBranchOutReportResponse.value.data?.values
        ?.elementAt(index);

    final List<String> popUpValues = ["Edit", "Cancel"];

    for (int i = 0; i < controller.headers.length - 1; i++) {
      String cellContent = "-";
      switch (i) {
        case 0:
          cellContent = "${index + 1}";
          break;
        case 1:
          cellContent = branchOut?.branchTransferNumber ?? "-";
          break;
        case 2:
          cellContent = branchOut?.branchName ?? "-";
          break;
        case 3:
          cellContent = branchOut?.employeeName ?? '-';
          break;
        case 4:
          cellContent = _formatDate(branchOut?.date);
          break;
        case 5:
          cellContent = branchOut?.itemCount.toString() ?? "-";
          break;
      }
      cells.add(
        Column(
          children: [
            InkWell(
              onTap: () {
                controller.itemDetailsShow.value =
                    !controller.itemDetailsShow.value;
                controller.selectedLineItem?.value = branchOut?.lineItems ?? [];
                controller.update();
              },
              child: Row(
                children: [
                  if (i != 0) const SizedBox(width: 4),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: cellContent,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    cells.add(
      Column(
        children: [
          const SizedBox(height: 8),
          Theme(
            data: ThemeData(
              focusColor: greyTextColor,
              tooltipTheme: const TooltipThemeData(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            child: CustomPopupMenuButtonWidget<String>(
              icon: const Icon(Icons.more_vert),
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    ...popUpValues.map((element) {
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
                              if (element != popUpValues.last)
                                CustomDashedLineWidget(width: Get.width),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
              onSelected: (String value) {
                switch (value) {
                  case 'Edit':
                    break;
                  case 'Cancel':
                    log("Cancel Branch out ${branchOut?.toJson()}");
                    Get.dialog(
                      CancelPaymentDialog(
                        subtitle:
                            'Are you sure you want to cancel this branch out record?',
                        onYesPressed: () async {
                          await controller.cancelBranchOutRecord(
                            branchOut!.branchTransferNumber.toString(),
                          );
                        },
                      ),
                    );
                    break;
                }
              },
            ),
          ),
          const SizedBox(height: 7),
          CustomDashedLineWidget(width: Get.width),
        ],
      ),
    );

    return TableRow(children: cells);
  }
}
