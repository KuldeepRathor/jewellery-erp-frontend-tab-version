// Fixed view_sales_return_table_widget.dart with working totals
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/model/get_sales_return_record_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view_model/view_sales_return_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view_model/view_sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class ViewSalesReturnTableWidget extends StatefulWidget {
  const ViewSalesReturnTableWidget({super.key});

  @override
  State<ViewSalesReturnTableWidget> createState() =>
      _ViewSalesReturnTableWidgetState();
}

class _ViewSalesReturnTableWidgetState
    extends State<ViewSalesReturnTableWidget> {
  final ViewSalesReturnItemDetailsController controller =
      Get.find<ViewSalesReturnItemDetailsController>();
  final ViewSalesReturnRecordController viewSalesReturnController =
      Get.find<ViewSalesReturnRecordController>();

  @override
  void initState() {
    super.initState();
    controller.clearControllers();

    // Check if data is already available and update totals immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final response =
          viewSalesReturnController.getSalesReturnRecordByIdResponse.value;
      if (response.status == Status.COMPLETED && response.data != null) {
        final lineItems = response.data?.lineItems ?? [];
        if (lineItems.isNotEmpty) {
          controller.updateTotalsFromLineItems(lineItems);
        }
      }
    });

    // Listen to API response changes for future updates
    ever(viewSalesReturnController.getSalesReturnRecordByIdResponse, (
      response,
    ) {
      if (response.status == Status.COMPLETED && response.data != null) {
        final lineItems = response.data?.lineItems ?? [];
        controller.updateTotalsFromLineItems(lineItems);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Container(
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
                            viewSalesReturnController
                                .getSalesReturnRecordByIdResponse
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

                          // Update totals in build method as well for immediate effect
                          if (lineItems.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.updateTotalsFromLineItems(lineItems);
                            });
                          }

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
                      backgroundColor: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTooltipMessage(String header) {
    if (header == "Stone Cost(₹)") {
      return "Stone details";
    } else {
      return "Return item details";
    }
  }

  TableRow _buildTableHeaders(ViewSalesReturnItemDetailsController controller) {
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
              visible: header == 'Stone Cost(₹)',
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
    List<GetSalesReturnRecordByIdResponseLineItem> lineItems,
  ) {
    return lineItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      List<Widget> cells = [
        _buildCell(text: (index + 1).toString(), rowIndex: index),
        _buildCell(
          textController: TextEditingController(text: item.code ?? ''),
          rowIndex: index,
          header: controller.headers[1],
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
            text: item.pieces?.toString() ?? '0',
          ),
          rowIndex: index,
          header: controller.headers[4],
        ),
        _buildCell(
          textController: TextEditingController(text: item.grossWeight ?? '0'),
          rowIndex: index,
          header: controller.headers[5],
        ),
        _buildCell(
          textController: TextEditingController(text: item.netWeight ?? '0'),
          rowIndex: index,
          header: controller.headers[6],
        ),
        _buildCell(
          textController: TextEditingController(text: item.finalVa ?? '0'),
          rowIndex: index,
          header: controller.headers[7],
        ),
        _buildCell(
          textController: TextEditingController(text: item.finalMc ?? '0'),
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
          textController: TextEditingController(text: item.discount ?? '0'),
          rowIndex: index,
          header: controller.headers[11],
        ),
        _buildCell(
          textController: TextEditingController(text: item.salesAmount ?? '0'),
          rowIndex: index,
          header: controller.headers[12],
        ),
        _buildCell(
          textController: TextEditingController(text: item.totalAmount ?? '0'),
          rowIndex: index,
          header: controller.headers[13],
        ),
      ];

      cells.add(_buildMoreOptionsCell(index));
      return TableRow(children: cells);
    }).toList();
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
        onTap: () {
          controller.showItemDetails(index: rowIndex);
          // Also update the main controller's selected item
          viewSalesReturnController.updateSelectedItem(rowIndex);
        },
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
          color: header == "Description" ? secondaryColor : Colors.black,
          decoration: header == "Description" ? TextDecoration.underline : null,
          decorationThickness: 2,
          decorationColor:
              header == "Description" ? secondaryColor : Colors.white,
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
            controller.showItemDetails(index: rowIndex);
            viewSalesReturnController.updateSelectedItem(rowIndex);
          }
        },
      ),
    );
  }
}
