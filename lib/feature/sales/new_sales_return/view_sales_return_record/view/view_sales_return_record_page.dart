// Fixed view_sales_return_invoice_page.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/model/get_sales_return_record_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view/view_sales_return_bottom_sticky_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view/view_sales_return_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view_model/view_sales_return_record_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/view_model/view_sales_return_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class ViewSalesReturnInvoicePage extends StatefulWidget {
  const ViewSalesReturnInvoicePage({super.key, required this.id});
  final String id;

  @override
  State<ViewSalesReturnInvoicePage> createState() =>
      _ViewSalesReturnInvoicePageState();
}

class _ViewSalesReturnInvoicePageState
    extends State<ViewSalesReturnInvoicePage> {
  final ViewSalesReturnRecordController viewSalesReturnController = Get.put(
    ViewSalesReturnRecordController(),
  );
  final ViewSalesReturnTabController tabController =
      Get.put<ViewSalesReturnTabController>(ViewSalesReturnTabController());
  // Add this line to initialize the ViewSalesReturnItemDetailsController
  final ViewSalesReturnItemDetailsController returnItemController = Get.put(
    ViewSalesReturnItemDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewSalesReturnController.getSalesRecordById(id: widget.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ViewSalesReturnHeaderWidget(),
          ViewSalesReturnDetailsWidget(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              child: ViewSalesReturnTabWidget(),
            ),
          ),
          Obx(
            () => Visibility(
              visible: tabController.currentTabIndex.value == 0,
              child: const Expanded(child: ViewSalesReturnBottomStickyWidget()),
            ),
          ),
        ],
      ),
    );
  }
}

// view_sales_return_header_widget.dart
class ViewSalesReturnHeaderWidget extends StatelessWidget {
  const ViewSalesReturnHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              log("Tapped");
              SidebarController sidebarController = Get.find();
              sidebarController.popBackSelectedWidget();
            },
            child: Container(
              width: 27,
              height: 35,
              decoration: ShapeDecoration(
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const SizedBox(
                width: 15,
                height: 15,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'View Sales Return',
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const Row(
            children: [
              Text(
                'Sales Counter 2',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// view_sales_return_details_widget.dart
class ViewSalesReturnDetailsWidget extends StatelessWidget {
  ViewSalesReturnDetailsWidget({super.key});

  final ViewSalesReturnRecordController viewSalesReturnController =
      Get.find<ViewSalesReturnRecordController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: grey1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: ViewSalesReturnSearchPartyDropdown(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(color: grey2, height: 60, width: 2),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CustomText(
                          text: "Return Number:",
                          fontSize: 12,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Obx(() {
                              final response =
                                  viewSalesReturnController
                                      .getSalesReturnRecordByIdResponse
                                      .value;
                              final returnNumber =
                                  response.data?.saleReturnNumber ?? '-';
                              return CustomText(
                                text: returnNumber,
                                fontSize: 16,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              final response =
                  viewSalesReturnController
                      .getSalesReturnRecordByIdResponse
                      .value;

              if (response.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              if (response.status == Status.ERROR) {
                return const Center(
                  child: Text('Error loading customer details'),
                );
              }

              final returnRecord = response.data;
              if (returnRecord == null) {
                return const SizedBox.shrink();
              }

              return SalesReturnCustomerInfoCard(
                customerName: returnRecord.partyDetails?.name ?? '-',
                sgstNumber: returnRecord.partyDetails?.gstNumber ?? "-",
                address:
                    returnRecord
                        .partyDetails
                        ?.address
                        ?.firstOrNull
                        ?.addressLine1 ??
                    '-',
                originalSaleNumber: returnRecord.saleRecord?.saleNumber ?? '-',
                onViewLedger: () {},
              );
            }),
          ],
        ),
      ),
    );
  }
}

// view_sales_return_customer_info_card_widget.dart
class SalesReturnCustomerInfoCard extends StatelessWidget {
  final String customerName;
  final String sgstNumber;
  final String address;
  final String originalSaleNumber;
  final VoidCallback onViewLedger;
  final double? width;

  const SalesReturnCustomerInfoCard({
    super.key,
    required this.customerName,
    required this.sgstNumber,
    required this.address,
    required this.originalSaleNumber,
    required this.onViewLedger,
    this.width,
  });

  Widget _buildInfoColumn({
    required String label,
    required String value,
    Color labelColor = const Color(0xFF28328B),
    Color valueColor = const Color(0xFF111111),
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontFamily: 'Satoshi',
              fontWeight:
                  label == 'Customer Name' ? FontWeight.w700 : FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: width,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: valueColor,
                fontSize: 12,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: grey1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoColumn(label: 'Customer Name', value: customerName),
              const SizedBox(width: 32),
              _buildInfoColumn(label: 'GSTIN', value: sgstNumber, width: 168),
              const SizedBox(width: 32),
              _buildInfoColumn(label: 'Address', value: address),
              const SizedBox(width: 32),
              _buildInfoColumn(
                label: 'Original Sale #',
                value: originalSaleNumber,
                labelColor: primaryColor,
                valueColor: primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// view_sales_return_search_party_widget.dart
class ViewSalesReturnSearchPartyDropdown extends StatelessWidget {
  const ViewSalesReturnSearchPartyDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewSalesReturnRecordController viewSalesReturnController =
        Get.find<ViewSalesReturnRecordController>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Customer Details",
              color: blackColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            const SizedBox(height: 8),
            Container(
              width: constraints.maxWidth,
              height: 38,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF5F5F5),
              ),
              child: Obx(() {
                final response =
                    viewSalesReturnController
                        .getSalesReturnRecordByIdResponse
                        .value;

                if (response.status == Status.LOADING) {
                  return const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                if (response.status == Status.ERROR) {
                  return const Center(
                    child: Text(
                      'Error loading customer details',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final returnRecord = response.data;
                if (returnRecord == null) {
                  return const Center(
                    child: Text('No customer details available'),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor:
                              returnRecord.partyType == 'CUSTOMER'
                                  ? primaryColor
                                  : tertiaryColor,
                          child: Text(
                            returnRecord.partyType?.substring(0, 1) ?? '-',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${returnRecord.partyDetails?.name ?? 'No Name'} - ${returnRecord.partyDetails?.phoneNumber ?? 'No Phone'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

// view_sales_return_tab_widget.dart
class ViewSalesReturnTabWidget extends StatefulWidget {
  const ViewSalesReturnTabWidget({super.key});

  @override
  State<ViewSalesReturnTabWidget> createState() =>
      _ViewSalesReturnTabWidgetState();
}

class _ViewSalesReturnTabWidgetState extends State<ViewSalesReturnTabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ViewSalesReturnTabController tabController = Get.put(
    ViewSalesReturnTabController(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        tabController.updateTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Returned Items'),
              Tab(text: 'Payment Details'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const ViewSalesReturnTableWidget(),
              ViewSalesReturnPaymentDetailsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

class ViewSalesReturnPaymentDetailsWidget extends StatelessWidget {
  ViewSalesReturnPaymentDetailsWidget({super.key});

  final ViewSalesReturnRecordController viewSalesReturnController =
      Get.find<ViewSalesReturnRecordController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Obx(() {
          final response =
              viewSalesReturnController.getSalesReturnRecordByIdResponse.value;

          if (response.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (response.status == Status.ERROR) {
            return Center(child: Text('Error: ${response.message}'));
          }

          final paymentDetails = response.data?.paymentDetails?.firstOrNull;
          if (paymentDetails == null) {
            return const Center(child: Text('No payment details available'));
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInvoiceDetails(paymentDetails)),
              const SizedBox(width: 24),
              Expanded(child: _buildPaymentDetailsTable(paymentDetails)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInvoiceDetails(
    GetSalesReturnRecordByIdResponsePaymentDetail details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invoice Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildInvoiceRow('Sub Total', details.subTotal ?? '0'),
              _buildInvoiceRow('Scheme Disct', details.schemeDiscount ?? '0'),
              _buildInvoiceRow('Rate Disct', details.rateDiscount ?? '0'),
              _buildInvoiceRow('Sales Amount', details.salesAmount ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('CGST', details.cgst ?? '0'),
              _buildInvoiceRow('SGST', details.sgst ?? '0'),
              _buildInvoiceRow('IGST', details.igst ?? '0'),
              _buildInvoiceRow('Nett GST', details.nettGst ?? '0'),
              _buildDivider(),
              if (details.tcs != null && details.tcs.toString() != '0')
                _buildInvoiceRow('TCS', details.tcs.toString()),
              if (details.tds != null && details.tds.toString() != '0')
                _buildInvoiceRow('TDS', details.tds.toString()),
              if ((details.tcs != null || details.tds != null) &&
                  details.nettTdsTcs != null)
                _buildInvoiceRow('Nett TDS/TCS', details.nettTdsTcs ?? '0'),
              _buildDivider(),
              _buildInvoiceRow('Purchase (OG)', details.purchaseOldGold ?? '0'),
              _buildInvoiceRow('Advance', details.advance ?? '0'),
              _buildInvoiceRow('Round Off', details.roundOff ?? '0'),
              _buildInvoiceRow('Bank Charges', details.bankCharges ?? '0'),
              _buildDivider(),
              _buildInvoiceRow(
                'Final Amount',
                details.finalAmount ?? '0',
                isBold: true,
              ),
              _buildInvoiceRow(
                'Balance',
                details.balance ?? '0',
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsTable(
    GetSalesReturnRecordByIdResponsePaymentDetail details,
  ) {
    // Get the return date and original sale info

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Total Amount : ₹ ${formatCurrency(details.finalAmount ?? '0')}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 16),
            Container(height: 16, width: 1, color: Colors.grey.shade300),
            const SizedBox(width: 16),
            Text(
              'Pending Amount : ₹ ${formatCurrency(details.balance ?? '0')}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Amount (₹)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Method',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Adj INV no',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Uni code',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Single row showing the return adjustment
              // Replace the single Container with a Column that maps through the list
              Column(
                children: [
                  // Table rows for each payment method detail
                  ...(details.paymentMethodDetails ?? []).map((paymentMethod) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatCurrency(paymentMethod.amount ?? '0'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                paymentMethod.method ?? '-',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                paymentMethod.date != null
                                    ? _formatDate(paymentMethod.date!)
                                    : '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                paymentMethod.adjustInvoiceNumber ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                paymentMethod.universalPaymentCode ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Show a message if no payment details exist
                  if (details.paymentMethodDetails == null ||
                      details.paymentMethodDetails!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text(
                          'No payment method details available',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildInvoiceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹ ${formatCurrency(value)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: Colors.grey.shade300),
    );
  }
}

class ViewSalesReturnTabController extends GetxController {
  final RxInt currentTabIndex = 0.obs;

  void updateTabIndex(int index) {
    currentTabIndex.value = index;
  }
}
