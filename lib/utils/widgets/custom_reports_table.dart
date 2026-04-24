import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CustomTableReportWidget extends StatefulWidget {
  const CustomTableReportWidget({
    super.key,
    required this.headers,
    required this.subHeaders,
    required this.columnWidths,
    required this.columnWidthsHeaders,
    required this.rows,
    this.controller,
    this.isLoadingMore = false,
    this.addSizedBox = true,
  });
  final List<TableRow> headers;
  final List<TableRow> subHeaders;
  final List<double> columnWidths;
  final List<double> columnWidthsHeaders;
  final List<TableRow> rows;
  final ScrollController? controller;
  final bool isLoadingMore;
  final bool addSizedBox;

  @override
  State<CustomTableReportWidget> createState() =>
      _CustomTableReportWidgetState();
}

class _CustomTableReportWidgetState extends State<CustomTableReportWidget> {
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Table(
                columnWidths: getColumnWidths(
                  columnWidths: widget.columnWidthsHeaders,
                  context: context,
                ),
                children: widget.headers,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Table(
                columnWidths: getColumnWidths(
                  columnWidths: widget.columnWidths,
                  context: context,
                ),
                children: widget.subHeaders,
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
