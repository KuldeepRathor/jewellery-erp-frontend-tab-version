import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/model/daily_reports_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class TotalOldGoldDailog extends StatelessWidget {
  final List<OldMetal>? oldMetals;

  const TotalOldGoldDailog({super.key, required this.oldMetals});

  @override
  Widget build(BuildContext context) {
    final headers = [
      "Code",
      "Desc",
      "Pcs",
      "G_wt",
      "N_wt",
      "Amount",
      "Avg rate per gm",
    ];
    final columnWidths = [0.15, 0.35, 0.15, 0.15, 0.15, 0.15, 0.20];

    // Calculate totals
    int totalPieces = 0;
    double totalWeight = 0;
    double totalCarat = 0;
    double totalAmount = 0;
    double avgRate = 0;

    if (oldMetals != null && oldMetals!.isNotEmpty) {
      for (var metal in oldMetals!) {
        totalPieces += metal.pcs ?? 0;

        totalWeight += double.tryParse(metal.gWt ?? '0') ?? 0;

        totalCarat += double.tryParse(metal.nWt ?? '0') ?? 0;

        totalAmount += double.tryParse(metal.amount ?? '0') ?? 0;

        avgRate += double.tryParse(metal.avgRatePerGm ?? '0') ?? 0;
      }
    }

    // Calculate dialog width based on screen size
    final screenWidth = Get.width;
    final dialogWidth = screenWidth > 1200 ? 900.0 : screenWidth * 0.9;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: dialogWidth,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stone Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Satoshi',
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.black),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Custom Table Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children:
                              headers.asMap().entries.map((entry) {
                                final index = entry.key;
                                final header = entry.value;
                                return Expanded(
                                  flex: (columnWidths[index] * 100).toInt(),
                                  child: Text(
                                    header,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Table Content
                      if (oldMetals == null || oldMetals!.isEmpty)
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: const Text(
                            'No stone data available',
                            style: TextStyle(
                              color: greyTextColor,
                              fontSize: 16,
                              fontFamily: 'Satoshi',
                            ),
                          ),
                        )
                      else
                        Column(
                          children:
                              oldMetals!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final oldMetal = entry.value;
                                final isLastItem =
                                    index == oldMetals!.length - 1;

                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          // Stone Name
                                          Expanded(
                                            flex:
                                                (columnWidths[0] * 100).toInt(),
                                            child: Text(
                                              oldMetal.code ?? '-',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Pieces
                                          Expanded(
                                            flex:
                                                (columnWidths[1] * 100).toInt(),
                                            child: Text(
                                              oldMetal.desc ?? "-",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          // Weight
                                          Expanded(
                                            flex:
                                                (columnWidths[2] * 100).toInt(),
                                            child: Text(
                                              oldMetal.pcs.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          // Carat
                                          Expanded(
                                            flex:
                                                (columnWidths[3] * 100).toInt(),
                                            child: Text(
                                              oldMetal.gWt ?? "-",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          // Total Amount
                                          Expanded(
                                            flex:
                                                (columnWidths[4] * 100).toInt(),
                                            child: Text(
                                              oldMetal.nWt ?? '-',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:
                                                (columnWidths[5] * 100).toInt(),
                                            child: Text(
                                              oldMetal.amount ?? '-',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex:
                                                (columnWidths[6] * 100).toInt(),
                                            child: Text(
                                              oldMetal.avgRatePerGm ?? '-',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Satoshi',
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!isLastItem)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: CustomDashedLineWidget(
                                          width: double.infinity,
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                        ),

                      // Totals Row
                      if (oldMetals != null && oldMetals!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: greenColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // Total Label
                              Expanded(
                                flex: (columnWidths[0] * 100).toInt(),
                                child: const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Description
                              Expanded(
                                flex: (columnWidths[1] * 100).toInt(),
                                child: const Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Total Pieces
                              Expanded(
                                flex: (columnWidths[2] * 100).toInt(),
                                child: Text(
                                  totalPieces.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Total Weight
                              Expanded(
                                flex: (columnWidths[3] * 100).toInt(),
                                child: Text(
                                  totalWeight.toStringAsFixed(3),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Total Carat
                              Expanded(
                                flex: (columnWidths[4] * 100).toInt(),
                                child: Text(
                                  totalCarat.toStringAsFixed(3),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Total Amount
                              Expanded(
                                flex: (columnWidths[5] * 100).toInt(),
                                child: Text(
                                  totalAmount.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Total Avg rate per gm
                              Expanded(
                                flex: (columnWidths[6] * 100).toInt(),
                                child: Text(
                                  avgRate.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
