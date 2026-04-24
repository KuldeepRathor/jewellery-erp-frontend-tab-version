import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/receipt/create_receipt/view_model/account_receipt_line_item_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';

class AccountsReceiptLineItemTableWidget extends StatelessWidget {
  final AccountsReceiptLineItemController controller = Get.find();

  AccountsReceiptLineItemTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Invoice Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => CustomTableWidget(
                    headers: [_buildTableHeaders()],
                    columnWidths: controller.columnWidths,
                    rows: _buildRows(),
                    isLoadingMore: false,
                    addSizedBox: false,
                  ),
                ),
              ),
              Obx(
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
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      children:
          controller.headers
              .map(
                (header) => Row(
                  children: [
                    if (header != "Sn") const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        header,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  List<TableRow> _buildRows() {
    return List.generate(
      controller.items.length,
      (index) => _buildTableRow(index),
    );
  }

  TableRow _buildTableRow(int index) {
    final item = controller.items[index];
    return TableRow(
      children: [
        _buildCell(text: (index + 1).toString()),
        _buildCell(text: item.invoiceDate),
        _buildCell(text: item.invoiceAmount, color: secondaryColor),
        _buildCell(text: item.invoiceNumber),
        _buildCell(text: item.balance),
        _buildCell(text: item.remarks),
      ],
    );
  }

  Widget _buildCell({required String text, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
