// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/widgets/view_old_gold_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view_model/view_sales_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewSalesTableWidget extends StatefulWidget {
  const ViewSalesTableWidget({super.key});

  @override
  State<ViewSalesTableWidget> createState() => _ViewSalesTableWidgetState();
}

class _ViewSalesTableWidgetState extends State<ViewSalesTableWidget> {
  final ViewSalesItemDetailsController controller =
      Get.put<ViewSalesItemDetailsController>(ViewSalesItemDetailsController());
  final CreateSalesItemDetailsController createSalesItemDetailsController =
      Get.find<CreateSalesItemDetailsController>();
  final CreateSalesViewModel createSalesViewModel =
      Get.find<CreateSalesViewModel>();
  final SalesOldGoldController oldGoldController =
      Get.find<SalesOldGoldController>();
  final RateCaratInputController rateCaratInputController =
      Get.find<RateCaratInputController>();
  final ViewSalesController viewSalesController =
      Get.find<ViewSalesController>();

  final SalesPaymentDetailsController salesPaymentDetailsController =
      Get.find<SalesPaymentDetailsController>();

  late KeyEventResult Function(FocusNode, KeyEvent, int rowIndex)
  onTableKeyEvent = (node, event, rowIndex) {
    print("table key event called ${event.logicalKey} $rowIndex");
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          controller.validateAndAddRow();
          return KeyEventResult.handled;
        } else {
          controller.moveNextFocus();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        // controller.movePreviousFocus(addButtonFocusNode);
        controller.movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        controller.moveNextFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowUp,
          nextFocusNode: node,
          previousFocusNode: node,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        return controller.moveFocus(
          KeyEventResult.handled,
          LogicalKeyboardKey.arrowDown,
          nextFocusNode: node,
          previousFocusNode: node,
        );
      }

      if (event.logicalKey == LogicalKeyboardKey.escape &&
          HardwareKeyboard.instance.isShiftPressed) {
        controller.removeCurrentRow(rowIndex);
      }
    }
    return KeyEventResult.ignored;
  };

  @override
  void initState() {
    super.initState();
    controller.clearControllers();

    // Listen to API response changes
    ever(viewSalesController.getSalesRecordByIdAggregateResponse, (response) {
      if (response.status == Status.COMPLETED && response.data != null) {
        final lineItems = response.data?.lineItems ?? [];
        // Call updateTotalsFromLineItems here instead of during build
        controller.updateTotalsFromLineItems(lineItems);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Focus(
        // autofocus: true,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          final response =
                              viewSalesController
                                  .getSalesRecordByIdAggregateResponse
                                  .value;

                          if (response.status == Status.LOADING) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (response.status == Status.ERROR) {
                            return Center(
                              child: Text('Error: ${response.message}'),
                            );
                          }
                          if (response.status == Status.COMPLETED &&
                              response.data != null) {
                            final lineItems = response.data?.lineItems ?? [];

                            // Don't update totals here during build - we're doing it in the listener
                            // controller.updateTotalsFromLineItems(lineItems);

                            return CustomTableWidget(
                              headers: [_buildTableHeaders(controller)],
                              columnWidths: controller.columnWidths,
                              rows: _buildRows(lineItems),
                              addSizedBox: false,
                            );
                          }

                          return const SizedBox();
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Obx(
                      () => ItemListHeaderTable(
                        headers: controller.totalHeadersValue.toList(),
                        columnWidthsCustom: getColumnWidths(
                          columnWidths: controller.columnWidths,
                          context: context,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: totalGreenColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final response =
                        viewSalesController
                            .getSalesRecordByIdAggregateResponse
                            .value;
                    final hasOldGold =
                        response.status == Status.COMPLETED &&
                        response.data != null &&
                        (response.data?.oldGolds?.isNotEmpty ?? false);

                    // Only calculate values if we have old gold data
                    if (hasOldGold) {
                      final oldGolds = response.data!.oldGolds!;

                      // Calculate totals from the API response data
                      double totalPieces = 0;
                      double totalGrossWeight = 0;
                      double totalAmount = 0;

                      for (var item in oldGolds) {
                        totalPieces += item.pieces?.toDouble() ?? 0;
                        totalGrossWeight +=
                            double.tryParse(item.grossWeight ?? '0') ?? 0;
                        totalAmount += double.tryParse(item.total ?? '0') ?? 0;
                      }

                      // Update the controller's values using data from API
                      controller.totalHeadersValueOldGold.value = [
                        "Old Gold Total",
                        totalPieces.toStringAsFixed(2),
                        totalGrossWeight.toStringAsFixed(3),
                        "",
                        totalAmount.toStringAsFixed(2),
                        "",
                      ];
                    }

                    log("Has old gold: $hasOldGold");

                    return Visibility(
                      visible: hasOldGold,
                      child: GestureDetector(
                        onTap: () {
                          // Open the ViewOldGoldDialog when the row is tapped
                          Get.dialog(const ViewOldGoldDialog());
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ItemListHeaderTable(
                                  headers:
                                      controller.totalHeadersValueOldGold
                                          .toList(),
                                  columnWidthsCustom: getColumnWidths(
                                    columnWidths:
                                        controller.totalColumnWidthsOldGold,
                                    context: context,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  backgroundColor: tertiaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getTooltipMessage(String header) {
    if (header == "Stone (₹)") {
      return "Alt + D to add Stone details";
    } else {
      return "Alt + C or Double Click to Change";
    }
  }

  TableRow _buildTableHeaders(ViewSalesItemDetailsController controller) {
    List<Widget> cells = [];

    for (int i = 0; i < controller.headers.length; i++) {
      String header = controller.headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sn") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: controller.headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Visibility(
              visible:
                  header == 'WST/Tch' ||
                  // header == 'MC (₹)' ||
                  header == 'Stone (₹)',
              child: Tooltip(
                message: getTooltipMessage(header),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: toolTipBgColor,
                ),
                triggerMode: TooltipTriggerMode.tap,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  List<TableRow> _buildRows(
    List<GetSalesRecordByIdAggregateResponseLineItem> lineItems,
  ) {
    return lineItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      List<Widget> cells = [
        _buildCell(text: (index + 1).toString(), rowIndex: index),
        Stack(
          children: [
            _buildCell(
              textController: TextEditingController(text: item.code ?? ''),
              rowIndex: index,
              header: controller.headers[1],
            ),
            if ((item.taggingRecord?.status ?? '').toLowerCase() == 'sold')
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SOLD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        _buildCell(
          textController: TextEditingController(
            text: item.tag?.toString() ?? '',
          ),
          rowIndex: index,
          header: controller.headers[2],
        ),
        _buildCell(
          textController: TextEditingController(text: item.description ?? ''),
          rowIndex: index,
          header: controller.headers[3],
        ),
        _buildCell(
          textController: TextEditingController(
            text: item.finalPieces?.toString() ?? '0',
          ),
          rowIndex: index,
          header: controller.headers[4],
        ),
        _buildCell(
          textController: TextEditingController(
            text: item.finalGrossWeight ?? '0',
          ),
          rowIndex: index,
          header: controller.headers[5],
        ),
        _buildCell(
          textController: TextEditingController(
            text: item.finalNetWeight ?? '0',
          ),
          rowIndex: index,
          header: controller.headers[6],
        ),
        _buildCell(
          textController: TextEditingController(text: item.finalVa ?? '0'),
          rowIndex: index,
          header: controller.headers[7],
        ),
        _buildCell(
          textController: TextEditingController(
            text: getViewMcTotalValue(item: item),
          ),
          rowIndex: index,
          header: controller.headers[8],
        ),
        _buildCell(
          textController: TextEditingController(text: item.stoneCost ?? '0'),
          rowIndex: index,
          header: controller.headers[9],
        ),
        _buildCell(
          textController: TextEditingController(text: item.hallMark ?? '0'),
          rowIndex: index,
          header: controller.headers[10],
        ),
        _buildCell(
          textController: TextEditingController(text: item.rate ?? '0'),
          rowIndex: index,
          header: controller.headers[11],
        ),
        _buildCell(
          textController: TextEditingController(text: item.discount ?? '0'),
          rowIndex: index,
          header: controller.headers[12],
        ),
        _buildCell(
          textController: TextEditingController(text: item.salesAmount ?? '0'),
          rowIndex: index,
          header: controller.headers[13],
        ),
        _buildCell(
          textController: TextEditingController(text: item.totalAmount ?? '0'),
          rowIndex: index,
          header: controller.headers[14],
        ),
      ];

      cells.add(_buildMoreOptionsCell(index));
      return TableRow(children: cells);
    }).toList();
  }

  String getViewMcTotalValue({
    required GetSalesRecordByIdAggregateResponseLineItem item,
  }) {
    final mcValue = double.tryParse(item.finalMc ?? '0') ?? 0;

    final makingChargesType = item.makingChargesType?.toLowerCase() ?? '';

    double mcTotalValue = 0;
    if (makingChargesType == "gwt") {
      final gwt = double.tryParse(item.finalGrossWeight ?? '0') ?? 0;
      mcTotalValue = mcValue * gwt;
    } else if (makingChargesType == "nwt") {
      final nwt = double.tryParse(item.finalNetWeight ?? '0') ?? 0;
      mcTotalValue = mcValue * nwt;
    } else {
      // Fixed or per piece
      mcTotalValue = mcValue;
    }

    return mcTotalValue.toStringAsFixed(2);
  }

  Widget _buildCell({
    String? text,
    TextEditingController? textController,
    String? header,
    required int rowIndex,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: TextFormField(
        onTap:
            () => createSalesItemDetailsController.showItemDetails(
              index: rowIndex,
            ),
        controller: textController ?? TextEditingController(text: text),
        readOnly: true,
        enabled: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          disabledBorder: InputBorder.none,
          filled: true,
          fillColor:
              Colors.grey[100], // Light gray background to indicate read-only
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: header == "Item Description" ? secondaryColor : Colors.black,
          decoration:
              header == "Item Description" ? TextDecoration.underline : null,
          decorationThickness: 2,
          decorationColor:
              header == "Item Description" ? secondaryColor : Colors.white,
        ),
      ),
    );
  }

  Widget _buildMoreOptionsCell(int rowIndex) {
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
            (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'view',
                child: Text('View Details'),
              ),
            ],
        onSelected: (String value) {
          if (value == 'view') {
            createSalesItemDetailsController.showItemDetails(index: rowIndex);
          }
        },
      ),
    );
  }
}
