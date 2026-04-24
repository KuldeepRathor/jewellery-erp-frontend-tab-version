import 'package:flutter/material.dart';

import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CustomTableWidget extends StatefulWidget {
  const CustomTableWidget({
    super.key,
    required this.headers,
    required this.columnWidths,
    required this.rows,
    this.controller,
    this.isLoadingMore = false,
    this.addSizedBox = true,
  });
  final List<TableRow> headers;
  final List<double> columnWidths;
  final List<TableRow> rows;
  final ScrollController? controller;
  final bool isLoadingMore;
  final bool addSizedBox;

  @override
  State<CustomTableWidget> createState() => _CustomTableWidgetState();
}

class _CustomTableWidgetState extends State<CustomTableWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: widget.controller,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Table(
                columnWidths: getColumnWidths(
                  columnWidths: widget.columnWidths,
                  context: context,
                ),
                children: widget.headers,
              ),
            ),
            Table(
              columnWidths: getColumnWidths(
                columnWidths: widget.columnWidths,
                context: context,
              ),
              children: widget.rows,
            ),
            Visibility(
              visible: widget.isLoadingMore,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Visibility(
              visible: widget.addSizedBox,
              child: SizedBox(height: MediaQuery.of(context).size.height * 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListHeaderTable extends StatelessWidget {
  final List<String> headers;

  final Map<int, TableColumnWidth> columnWidthsCustom;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ItemListHeaderTable({
    super.key,
    required this.headers,
    required this.columnWidthsCustom,
    this.backgroundColor = secondaryColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: padding,
      child: Table(
        columnWidths: columnWidthsCustom,
        children: [
          TableRow(
            children:
                headers.map((header) => _buildHeaderCell(header)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: CustomText(
        text: text,
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        maxLines: 1,
      ),
    );
  }
}
