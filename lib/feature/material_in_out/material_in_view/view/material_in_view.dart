import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_view/model/get_material_in_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_view/view_model/view_material_in_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/vendor_bill_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class ViewMaterialInPage extends StatefulWidget {
  final String id;

  const ViewMaterialInPage({super.key, required this.id});

  @override
  State<ViewMaterialInPage> createState() => _ViewMaterialInPageState();
}

class _ViewMaterialInPageState extends State<ViewMaterialInPage> {
  final ViewMaterialInController controller = Get.put(
    ViewMaterialInController(),
  );

  @override
  void initState() {
    super.initState();
    controller.getMaterialInById(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.getMaterialInByIdResponse.value.status) {
          case Status.LOADING:
            return const Center(child: CircularProgressIndicator());
          case Status.COMPLETED:
            final data = controller.getMaterialInByIdResponse.value.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderWidget(
                    header: "View Material In",
                    wantBackButton: true,
                    onBackButtonTap: () {
                      SidebarController sidebarController = Get.find();
                      sidebarController.popBackSelectedWidget();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: PartyDetailsWidget(
                                partyDetails: {
                                  'name': data.partyName ?? '',
                                  'gstNumber': data.partyGst ?? '',
                                  'addressLine1': data.partyAddress ?? '',
                                  'type': data.partyType ?? '',
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: VendorBillDetailsWidget(
                                invoiceNo: data.invoiceNumber ?? '',
                                vendorInvoiceNo: data.partyInvoiceNumber ?? '',
                                invoiceCreated: convertDateTimeToString(
                                  data.invoiceCreateDate,
                                ),
                                invoiceReceived: convertDateTimeToString(
                                  data.invoiceReceiveDate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        MaterialInItemDetailsWidget(
                          lineItems: data.lineItems ?? [],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          case Status.ERROR:
            return Center(
              child: Text(
                controller.getMaterialInByIdResponse.value.message ?? '',
              ),
            );
          default:
            return const SizedBox();
        }
      }),
    );
  }
}

class MaterialInItemDetailsWidget extends StatelessWidget {
  final List<LineItem> lineItems;

  const MaterialInItemDetailsWidget({super.key, required this.lineItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Item Details',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(0.5), // Sn
                  1: FlexColumnWidth(1.2), // Code
                  2: FlexColumnWidth(2.0), // Description
                  3: FlexColumnWidth(0.8), // Pcs
                  4: FlexColumnWidth(0.8), // G.Wt
                  5: FlexColumnWidth(0.8), // N.Wt
                  6: FlexColumnWidth(0.8), // VA
                  7: FlexColumnWidth(0.8), // MC
                  8: FlexColumnWidth(0.8), // Stone
                  9: FlexColumnWidth(1.0), // Amount
                },
                children: [_buildTableHeaders(), ..._buildRows()],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: totalGreenColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.5), // Sn
                    1: FlexColumnWidth(1.2), // Code
                    2: FlexColumnWidth(2.0), // Description
                    3: FlexColumnWidth(0.8), // Pcs
                    4: FlexColumnWidth(0.8), // G.Wt
                    5: FlexColumnWidth(0.8), // N.Wt
                    6: FlexColumnWidth(0.8), // VA
                    7: FlexColumnWidth(0.8), // MC
                    8: FlexColumnWidth(0.8), // Stone
                    9: FlexColumnWidth(1.0), // Amount
                  },
                  children: [
                    TableRow(
                      children: [
                        _buildTotalCell('Total', TextAlign.left),
                        _buildTotalCell('', TextAlign.left),
                        _buildTotalCell('', TextAlign.left),
                        ..._calculateTotals().map(
                          (value) => _buildTotalCell(value, TextAlign.right),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                SidebarController sidebarController = Get.find();
                // sidebarController.selectSubItem(4, 0);
                sidebarController.selectSubMenuItem('stock', 'stock_purchase');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomText(
                  text: "Create Purchase Invoice",
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeaders() {
    return TableRow(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      children:
          headers.map((header) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: CustomText(
                text: header,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                textAlign:
                    header == 'Sn'
                        ? TextAlign.center
                        : (header == 'Code' || header == 'Description')
                        ? TextAlign.left
                        : TextAlign.right,
              ),
            );
          }).toList(),
    );
  }

  List<TableRow> _buildRows() {
    return lineItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return TableRow(
        children: [
          _buildCell((index + 1).toString(), TextAlign.center),
          _buildCell(item.code ?? '-', TextAlign.left),
          _buildCell(item.itemDescription ?? '-', TextAlign.left),
          _buildCell(item.pieces?.toString() ?? '-', TextAlign.right),
          _buildCell(item.grossWeight ?? '-', TextAlign.right),
          _buildCell(item.netWeight ?? '-', TextAlign.right),
          _buildCell(item.va ?? '-', TextAlign.right),
          _buildCell(item.mc ?? '-', TextAlign.right),
          _buildCell(item.stone ?? '-', TextAlign.right),
          _buildCell(item.amount ?? '-', TextAlign.right),
        ],
      );
    }).toList();
  }

  Widget _buildCell(String text, TextAlign alignment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: text,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            textAlign: alignment,
          ),
          const SizedBox(height: 8),
          const CustomDashedLineWidget(width: double.maxFinite),
        ],
      ),
    );
  }

  Widget _buildTotalCell(String text, TextAlign alignment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CustomText(
        text: text,
        fontSize: 14,
        color: Colors.white,
        textAlign: alignment,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  List<String> _calculateTotals() {
    double totalPieces = 0,
        totalGrossWeight = 0,
        totalNetWeight = 0,
        totalVA = 0,
        totalMC = 0,
        totalStone = 0,
        totalAmount = 0;

    for (var item in lineItems) {
      totalPieces += item.pieces?.toDouble() ?? 0;
      totalGrossWeight += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalNetWeight += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalVA += double.tryParse(item.va ?? '0') ?? 0;
      totalMC += double.tryParse(item.mc ?? '0') ?? 0;
      totalStone += double.tryParse(item.stone ?? '0') ?? 0;
      totalAmount += double.tryParse(item.amount ?? '0') ?? 0;
    }

    return [
      totalPieces.toStringAsFixed(2),
      totalGrossWeight.toStringAsFixed(3),
      totalNetWeight.toStringAsFixed(3),
      totalVA.toStringAsFixed(2),
      totalMC.toStringAsFixed(2),
      totalStone.toStringAsFixed(2),
      totalAmount.toStringAsFixed(2),
    ];
  }

  static const List<String> headers = [
    'Sn',
    'Code',
    'Description',
    'Pcs',
    'G.Wt',
    'N.Wt',
    'VA',
    'MC',
    'Stone',
    'Amount',
  ];
}
