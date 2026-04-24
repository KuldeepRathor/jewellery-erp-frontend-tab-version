import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/model/get_payments_by_id_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/view/payment_details_info_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/view/payment_line_items_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/view_paymnets/view_model/view_payments_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

class ViewPaymentsPage extends StatefulWidget {
  const ViewPaymentsPage({super.key, required this.id});
  final String id;
  @override
  State<ViewPaymentsPage> createState() => _ViewPaymentsPageState();
}

class _ViewPaymentsPageState extends State<ViewPaymentsPage> {
  final ViewPaymentsController viewPaymentsController = Get.put(
    ViewPaymentsController(),
  );

  @override
  void initState() {
    viewPaymentsController.getSalesRecordById(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: grey1,
        child: Obx(() {
          final response = viewPaymentsController.getPaymentsByIdResponse.value;
          if (response.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          } else if (response.status == Status.ERROR) {
            return Center(child: Text('Error: ${response.message}'));
          } else if (response.status == Status.COMPLETED &&
              response.data != null) {
            return PaymentDetailsWidget(data: response.data!);
          } else {
            return const Center(child: Text('No data available'));
          }
        }),
      ),
    );
  }
}

class PaymentDetailsWidget extends StatefulWidget {
  final GetPaymentsByIdResponse data;

  const PaymentDetailsWidget({super.key, required this.data});

  @override
  State<PaymentDetailsWidget> createState() => _PaymentDetailsWidgetState();
}

class _PaymentDetailsWidgetState extends State<PaymentDetailsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        HeaderWidget(
          header: "Payment Details",
          wantBackButton: true,
          onBackButtonTap: () {
            SidebarController sidebarController = Get.find();
            sidebarController.popBackSelectedWidget();
          },
        ),
        PaymentDetailsInfoWidget(data: widget.data),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryColor,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Payment Items'),
                      Tab(text: 'Payment Details'),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PaymentLineItemsWidget(
                          lineItems: widget.data.lineItems ?? [],
                          partyDetails: widget.data.partyDetails,
                        ),
                        // You can create a new widget for payment details or use an existing one
                        PaymentSummaryWidget(data: widget.data),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// This is a new widget you'll need to create for the second tab
class PaymentSummaryWidget extends StatelessWidget {
  final GetPaymentsByIdResponse data;

  const PaymentSummaryWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
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
                  _buildDetailRow('Amount', '₹${data.amount ?? "0"}'),
                  if (data.roundOff != null && data.roundOff != "0") ...[
                    const SizedBox(height: 8),
                    _buildDetailRow('Round Off', '₹${data.roundOff}'),
                  ],
                  if (data.bankCharges != null && data.bankCharges != "0") ...[
                    const SizedBox(height: 8),
                    _buildDetailRow('Bank Charges', '₹${data.bankCharges}'),
                  ],
                  if (data.tcs != null && data.tcs != "0") ...[
                    const SizedBox(height: 8),
                    _buildDetailRow('TCS', '₹${data.tcs}'),
                  ],
                  if (data.tds != null && data.tds != "0") ...[
                    const SizedBox(height: 8),
                    _buildDetailRow('TDS', '₹${data.tds}'),
                  ],
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Total',
                    '₹${data.total ?? "0"}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
