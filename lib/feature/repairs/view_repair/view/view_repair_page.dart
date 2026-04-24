import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/cards/party_details_card.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/model/get_repair_details_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/view/view_repair_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/view/view_repair_payment_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/view_repair/view_model/view_repair_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:svg_flutter/svg.dart';

class ViewRepairPage extends StatefulWidget {
  const ViewRepairPage({super.key, required this.id});
  final String id;

  @override
  State<ViewRepairPage> createState() => _ViewRepairPageState();
}

class _ViewRepairPageState extends State<ViewRepairPage>
    with SingleTickerProviderStateMixin {
  final ViewRepairController controller = Get.put(ViewRepairController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.getRepairDetailsById(id: widget.id);
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
              HeaderWidget(
                header: 'View Repair',
                wantBackButton: true,
                onBackButtonTap: () {
                  SidebarController sidebarController = Get.find();
                  sidebarController.popBackSelectedWidget();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final response = controller.getRepairDetailsResponse.value;
                  if (response.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (response.status == Status.ERROR) {
                    return Center(child: Text('Error: ${response.message}'));
                  } else if (response.status == Status.COMPLETED &&
                      response.data != null) {
                    final repairData = response.data!;
                    return _buildRepairContent(repairData);
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

  Widget _buildRepairContent(GetRepairDetailsByIdResponse repairData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ViewRepairPartyDetailsWidget(repairData: repairData),
            const SizedBox(height: 16),
            _buildRepairDetails(repairData),
            const SizedBox(height: 16),
            _buildTabbedView(repairData),
          ],
        ),
      ),
    );
  }

  Widget _buildTabbedView(GetRepairDetailsByIdResponse repairData) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [Tab(text: 'Item Details'), Tab(text: 'Payments')],
          ),
        ),
        Container(
          height:
              400, // Set a fixed height or use a different approach for sizing
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              ViewRepairItemDetailsWidget(repairData: repairData),
              ViewRepairPaymentDetailsWidget(repairData: repairData),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRepairDetails(GetRepairDetailsByIdResponse repairData) {
    // Format the date
    String formattedDate =
        repairData.repairDate != null
            ? "${repairData.repairDate!.day.toString().padLeft(2, '0')}-${repairData.repairDate!.month.toString().padLeft(2, '0')}-${repairData.repairDate!.year}"
            : "N/A";

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Repair Details',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildDetailField(
                "Commodity Type",
                repairData.commodityType ?? "N/A",
              ),
              const SizedBox(width: 16),
              _buildDetailField("Repair No", repairData.repairNumber ?? "N/A"),
              const SizedBox(width: 16),
              _buildDetailField("Repair Date", formattedDate),
              const SizedBox(width: 16),
              _buildDetailField(
                "Repair Taken By",
                repairData.repairTakenByName ?? "N/A",
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (repairData.remarks != null)
            Row(
              children: [
                _buildDetailField("Remarks", repairData.remarks.toString()),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontSize: 12,
            color: blackColor,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: secondaryColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(text: value, fontSize: 14, color: blackColor),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewRepairPartyDetailsWidget extends StatelessWidget {
  final GetRepairDetailsByIdResponse repairData;

  const ViewRepairPartyDetailsWidget({super.key, required this.repairData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 8),
          _buildPartyDetails(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const CustomText(
      text: 'Party Details',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _buildPartyDetails() {
    // Create a formatted address string from customer address if available
    String address = 'N/A';
    if (repairData.customerAddress != null) {
      final addressData = repairData.customerAddress!;
      List<String> addressParts = [];

      if (addressData.addressLine1 != null &&
          addressData.addressLine1!.isNotEmpty) {
        addressParts.add(addressData.addressLine1!);
      }

      if (addressData.addressLine2 != null &&
          addressData.addressLine2!.isNotEmpty) {
        addressParts.add(addressData.addressLine2!);
      }

      if (addressData.city != null && addressData.city!.isNotEmpty) {
        addressParts.add(addressData.city!);
      }

      if (addressData.state != null && addressData.state!.isNotEmpty) {
        addressParts.add(addressData.state!);
      }

      if (addressData.pincode != null && addressData.pincode!.isNotEmpty) {
        addressParts.add(addressData.pincode!);
      }

      if (addressParts.isNotEmpty) {
        address = addressParts.join(', ');
      }
    }

    return PartyDetailsCard(
      sundryDebtor: repairData.customerName ?? 'N/A',
      sgst: repairData.customerGst ?? 'N/A',
      address: address,
      onEditPressed: () {},
    );
  }
}
