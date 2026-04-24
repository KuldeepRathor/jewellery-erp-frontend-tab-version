import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

typedef RowBuilder =
    Widget Function(BuildContext context, int index, double totalWidth);

class LineWiseCustomTable extends StatefulWidget {
  const LineWiseCustomTable({
    super.key,
    required this.headers,
    required this.columnWidths,
    required this.itemCount,
    required this.buildRow,
    this.controller,
    this.isLoadingMore = false,
    this.addBottomSpace = true,
    this.headerScrollController,
  });

  final List<String> headers;
  final List<double> columnWidths;
  final int itemCount;
  final RowBuilder buildRow;
  final ScrollController? controller;
  final ScrollController? headerScrollController;
  final bool isLoadingMore;
  final bool addBottomSpace;

  @override
  State<LineWiseCustomTable> createState() => _LineWiseCustomTableState();
}

class _LineWiseCustomTableState extends State<LineWiseCustomTable> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double contentWidth = _calculateContentWidth(availableWidth);

        // final bool needsHorizontalScroll = contentWidth > availableWidth;
        const bool needsHorizontalScroll = true;

        Widget content = SizedBox(
          width: contentWidth + 32,
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: _buildHeaderRow(availableWidth),
              ),

              // Rows using ListView.builder
              Expanded(
                child: ListView.builder(
                  controller: widget.controller,
                  itemCount:
                      widget.itemCount +
                      (widget.isLoadingMore ? 1 : 0) +
                      (widget.addBottomSpace ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Regular row
                    if (index < widget.itemCount) {
                      return Column(
                        children: [
                          widget.buildRow(context, index, availableWidth),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomDashedLineWidget(
                              width: double.infinity,
                            ),
                          ),
                        ],
                      );
                    }
                    // Loading indicator
                    else if (widget.isLoadingMore &&
                        index == widget.itemCount) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    // Bottom space
                    else if (widget.addBottomSpace) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );

        // Only wrap with SingleChildScrollView if horizontal scrolling is needed
        if (needsHorizontalScroll) {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.headerScrollController,
            child: content,
          );
        }

        return content;
      },
    );
  }

  double _calculateContentWidth(double availableWidth) {
    double totalWidthRatio = widget.columnWidths.fold(
      0,
      (sum, width) => sum + ((width / 4) * availableWidth),
    );

    return totalWidthRatio;
  }

  Widget _buildHeaderRow(double availableWidth) {
    return Row(
      children: List.generate(
        widget.headers.length,
        (index) => SizedBox(
          width: availableWidth * (widget.columnWidths[index] / 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: CustomText(
              text: widget.headers[index],
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class LineWiseCustomHeaderTable extends StatelessWidget {
  const LineWiseCustomHeaderTable({
    super.key,
    required this.headers,
    required this.columnWidths,
    this.backgroundColor = secondaryColor,
    this.textColor = Colors.white,
    this.headerScrollController,
  });

  final List<String> headers;
  final List<double> columnWidths;
  final Color backgroundColor;
  final Color textColor;
  final ScrollController? headerScrollController;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double contentWidth = _calculateContentWidth(availableWidth);

        Widget content = SizedBox(
          width: contentWidth + 32,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: _buildHeaderRow(availableWidth),
          ),
        );

        // Always wrap with SingleChildScrollView for consistency with LineWiseCustomTable
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: headerScrollController,
          child: content,
        );
      },
    );
  }

  double _calculateContentWidth(double availableWidth) {
    return columnWidths.fold(
      0.0,
      (sum, width) => sum + ((width / 4) * availableWidth),
    );
  }

  Widget _buildHeaderRow(double availableWidth) {
    return Row(
      children: List.generate(
        headers.length,
        (index) => SizedBox(
          width: availableWidth * (columnWidths[index] / 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: CustomText(
              text: headers[index],
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class LineWiseCustomHeaderTableForLot extends StatelessWidget {
  const LineWiseCustomHeaderTableForLot({
    super.key,
    required this.headers,
    required this.columnWidths,
    this.backgroundColor = secondaryColor,
    this.textColor = Colors.white,
    this.headerScrollController,
  });

  final List<String> headers;
  final List<double> columnWidths;
  final Color backgroundColor;
  final Color textColor;
  final ScrollController? headerScrollController;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double contentWidth = _calculateContentWidth(availableWidth);

        Widget content = SizedBox(
          width: contentWidth + 32,
          child: Container(
            decoration: BoxDecoration(
              // color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            // padding: const EdgeInsets.symmetric(
            //   horizontal: 16,
            //   vertical: 4,
            // ),
            child: _buildHeaderRow(availableWidth),
          ),
        );

        // Always wrap with SingleChildScrollView for consistency with LineWiseCustomTable
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: headerScrollController,
          child: content,
        );
      },
    );
  }

  double _calculateContentWidth(double availableWidth) {
    return columnWidths.fold(
      0.0,
      (sum, width) => sum + ((width / 4) * availableWidth),
    );
  }

  Widget _buildHeaderRow(double availableWidth) {
    return Row(
      children: List.generate(
        headers.length,
        (index) => Container(
          width: availableWidth * (columnWidths[index] / 4),
          decoration: BoxDecoration(
            color: headers[index] == "" ? Colors.transparent : backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          margin: const EdgeInsets.only(left: 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: CustomText(
              text: headers[index],
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
