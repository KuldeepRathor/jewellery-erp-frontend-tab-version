import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/view_order/model/get_order_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/view_order/view_model/view_order_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:svg_flutter/svg.dart';

class ViewOrderPage extends StatefulWidget {
  const ViewOrderPage({super.key, required this.id});
  final String id;

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage>
    with SingleTickerProviderStateMixin {
  final ViewOrderController controller = Get.put(ViewOrderController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Changed to 3 tabs
    controller.getOrderDetailsById(id: widget.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/svgs/auth/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildTabBar(),
              Expanded(
                child: Obx(() {
                  final response = controller.getInvoiceDetailsResponse.value;
                  if (response.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (response.status == Status.ERROR) {
                    return Center(child: Text('Error: ${response.message}'));
                  } else if (response.status == Status.COMPLETED &&
                      response.data != null) {
                    final orderData = response.data!;
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrderDetailsTab(orderData),
                        _buildPaymentDetailsTab(orderData),
                        _buildOrderTimelineTab(orderData),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
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
          const CustomText(
            text: 'View Order',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Order Details'),
              Tab(text: 'Payment Details'),
              Tab(text: 'Order Timeline'),
            ],
          ),
          const Spacer(),
          CustomInkButton(
            onPressed: () {},
            text: "Add Advance",
            backgroundColor: grey1,
            textColor: primaryColor,
          ),
          const SizedBox(width: 8),
          CustomInkButton(
            onPressed: () {},
            text: "Add Old Gold",
            backgroundColor: grey1,
            textColor: primaryColor,
          ),
          const SizedBox(width: 8),
          CustomInkButton(
            onPressed: () {},
            text: "Add Notes",
            backgroundColor: grey1,
            textColor: primaryColor,
          ),
          const SizedBox(width: 8),
          CustomInkButton(
            onPressed: () {},
            text: "Edit Order",
            backgroundColor: grey1,
            textColor: primaryColor,
          ),
          const SizedBox(width: 8),
          CustomInkButton(
            onPressed: () {},
            text: "Cancel Order",
            backgroundColor: grey1,
            textColor: primaryColor,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsTab(GetOrderDetailsByIdResponse orderData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCustomerDetailsSection(orderData),
          _buildOrderDetailsSection(orderData),
          const SizedBox(height: 16),
          _buildItemDetailsSection(orderData),
          const SizedBox(height: 16),
          _buildNotesSection(orderData),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsSection(GetOrderDetailsByIdResponse orderData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Customer Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoField('User Name', orderData.customerName ?? 'N/A'),
              const SizedBox(width: 16),
              _buildInfoField('Phone Number', '-'),
              const SizedBox(width: 16),
              _buildInfoField('Address', '-'),
              const SizedBox(width: 16),
              _buildInfoField('GSTIN', '-'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsSection(GetOrderDetailsByIdResponse orderData) {
    String formattedDate =
        orderData.createdAt != null
            ? "${orderData.createdAt!.day.toString().padLeft(2, '0')}/${orderData.createdAt!.month.toString().padLeft(2, '0')}/${orderData.createdAt!.year}"
            : "N/A";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Order Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoField('Commodity Type', 'GOLD'),
              const SizedBox(width: 16),
              _buildInfoField('Order Number', orderData.orderNumber ?? 'N/A'),
              const SizedBox(width: 16),
              _buildInfoField('Order Date', formattedDate),
              const SizedBox(width: 16),
              _buildInfoField('Customer Name', orderData.customerName ?? 'N/A'),
              const SizedBox(width: 16),
              _buildInfoField('Booking Type', '-'),
              const SizedBox(width: 16),
              _buildInfoField('Rate / gm', '-'),
              const SizedBox(width: 16),
              _buildInfoField(
                'Order Taken BY',
                orderData.orderTakenByName ?? 'N/A',
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildItemDetailsSection(GetOrderDetailsByIdResponse orderData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CustomText(
              text: 'Item Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildItemTable(orderData),
        ],
      ),
    );
  }

  Widget _buildItemTable(GetOrderDetailsByIdResponse orderData) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade300),
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
      columnWidths: const {
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
        7: FlexColumnWidth(1),
        8: FlexColumnWidth(1),
        9: FlexColumnWidth(1.5),
      },
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(color: secondaryColor),
          children: [
            _buildTableHeader('Sn'),
            _buildTableHeader('Item Description'),
            _buildTableHeader('Size'),
            _buildTableHeader('Purity'),
            _buildTableHeader('N.Wt. (gm)'),
            _buildTableHeader('VA %'),
            _buildTableHeader('MC'),
            _buildTableHeader('Stone'),
            _buildTableHeader('GST %'),
            _buildTableHeader('Total Amount (₹)'),
          ],
        ),
        // Data row
        TableRow(
          children: [
            _buildTableCell('1'),
            _buildTableCell(orderData.itemDescription ?? 'N/A'),
            _buildTableCell(orderData.size ?? 'N/A'),
            _buildTableCell(orderData.purity ?? 'N/A'),
            _buildTableCell(orderData.netWeight ?? 'N/A'),
            _buildTableCell('45'), // You'll need to add VA% field
            _buildTableCell('00.67'), // You'll need to add MC field
            _buildTableCell(orderData.stoneCharge?.toString() ?? '0'),
            _buildTableCell('2332'), // You'll need to add GST% field
            _buildTableCell(orderData.total ?? '0'),
          ],
        ),
        // Total row
        TableRow(
          decoration: const BoxDecoration(color: greenColor),
          children: [
            const SizedBox(),
            _buildTableCell(
              'Total',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(),
            const SizedBox(),
            _buildTableCell(
              orderData.netWeight ?? '0',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            _buildTableCell(
              orderData.total ?? '0',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        // Old Gold Total row
        TableRow(
          decoration: const BoxDecoration(color: tertiaryColor),
          children: [
            const SizedBox(),
            _buildTableCell(
              'Old Gold Total',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(),
            const SizedBox(),
            _buildTableCell(
              orderData.netWeight ?? '0',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            _buildTableCell(
              orderData.total ?? '0',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomText(
        text: text,
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CustomText(
        text: text,
        fontSize: 12,
        fontWeight: fontWeight,
        textAlign: TextAlign.center,
        color: color,
      ),
    );
  }

  Widget _buildNotesSection(GetOrderDetailsByIdResponse orderData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Added Notes :',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          CustomText(text: "-", fontSize: 12, color: Colors.grey.shade700),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsTab(GetOrderDetailsByIdResponse orderData) {
    final paymentDetail =
        orderData.paymentDetails?.isNotEmpty == true
            ? orderData.paymentDetails!.first
            : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildInvoiceDetailsCard(orderData, paymentDetail),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _buildPaymentMethodsCard(paymentDetail)),
        ],
      ),
    );
  }

  Widget _buildOrderTimelineTab(GetOrderDetailsByIdResponse orderData) {
    return const Center(child: Text('Order Timeline Tab - To be implemented'));
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: value,
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildInvoiceDetailsCard(
    GetOrderDetailsByIdResponse orderData,
    PaymentDetail? paymentDetail,
  ) {
    double totalAmount = double.tryParse(orderData.total ?? '0') ?? 0;
    double oldGoldTotal = 0;

    if (orderData.oldGolds != null) {
      for (var oldGold in orderData.oldGolds!) {
        oldGoldTotal += double.tryParse(oldGold.total ?? '0') ?? 0;
      }
    }

    double gst = double.tryParse(orderData.gstPercentage ?? '0') ?? 0;
    double amount = double.tryParse(paymentDetail?.amount ?? '0') ?? 0;
    double receivedAmount =
        double.tryParse(paymentDetail?.receivedAmount ?? '0') ?? 0;
    double balanceAmount =
        double.tryParse(paymentDetail?.balanceAmount ?? '0') ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CustomText(
              text: 'Invoice Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade300),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                _buildPaymentDetailRow(
                  'Amount',
                  '₹${totalAmount.toStringAsFixed(2)}',
                ),
                _buildPaymentDetailRow('GST', '₹${gst.toStringAsFixed(2)}'),
                _buildPaymentDetailRow(
                  'Old Gold',
                  '₹${oldGoldTotal.toStringAsFixed(2)}',
                ),
                _buildPaymentDetailRow(
                  'Total',
                  '₹${amount.toStringAsFixed(2)}',
                  isHighlighted: true,
                ),
                _buildPaymentDetailRow(
                  'Amount Received',
                  '₹${receivedAmount.toStringAsFixed(2)}',
                ),
                _buildPaymentDetailRow(
                  'Balance',
                  '₹${balanceAmount.toStringAsFixed(2)}',
                  isBalance: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard(PaymentDetail? paymentDetail) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CustomText(
              text: 'Other Payment Details',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildPaymentMethodsTable(paymentDetail),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsTable(PaymentDetail? paymentDetail) {
    if (paymentDetail?.paymentMethods == null ||
        paymentDetail!.paymentMethods!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CustomText(
          text: 'No payment methods added',
          fontSize: 14,
          color: Colors.grey,
        ),
      );
    }

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.grey.shade300),
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
      columnWidths: const {
        0: FixedColumnWidth(100),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
      },
      children: [
        // Header row
        TableRow(
          decoration: const BoxDecoration(color: secondaryColor),
          children: [
            _buildPaymentTableHeader('Payment ID'),
            _buildPaymentTableHeader('Method'),
            _buildPaymentTableHeader('Date'),
            _buildPaymentTableHeader('POS Bank'),
            _buildPaymentTableHeader('UPI/TXN ID'),
            _buildPaymentTableHeader('Amount'),
          ],
        ),
        // Data rows
        ...paymentDetail.paymentMethods!.map((payment) {
          String formattedDate =
              payment.date != null
                  ? "${payment.date!.day.toString().padLeft(2, '0')}/${payment.date!.month.toString().padLeft(2, '0')}/${payment.date!.year}"
                  : "N/A";

          return TableRow(
            children: [
              _buildPaymentTableCell('N/A'),
              _buildPaymentTableCell(payment.method ?? 'N/A'),
              _buildPaymentTableCell(formattedDate),
              _buildPaymentTableCell(payment.pos ?? 'N/A'),
              _buildPaymentTableCell(payment.paymentCode ?? '-'),
              _buildPaymentTableCell('₹${payment.amount ?? '0'}'),
            ],
          );
        }),
      ],
    );
  }

  TableRow _buildPaymentDetailRow(
    String label,
    String value, {
    bool isHighlighted = false,
    bool isBalance = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.grey.shade100 : Colors.white,
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CustomText(
            text: label,
            fontSize: 14,
            fontWeight:
                isHighlighted || isBalance
                    ? FontWeight.bold
                    : FontWeight.normal,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.centerRight,
          child: CustomText(
            text: value,
            fontSize: 14,
            fontWeight:
                isHighlighted || isBalance
                    ? FontWeight.bold
                    : FontWeight.normal,
            color: isBalance ? primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: CustomText(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: whiteColor,
      ),
    );
  }

  Widget _buildPaymentTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: CustomText(text: text, fontSize: 12, color: Colors.black87),
    );
  }
}
