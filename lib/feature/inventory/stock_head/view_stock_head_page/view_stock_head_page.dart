// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/api_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/stock_head_listing/view_model/stock_head_listing_view_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/model/stock_head/size_group_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_value.dart';
// import 'package:jewellery_erp_frontend_tab_version/model/stock_head/weight_group_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_table_widget.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

// class ViewStockHeadPage extends StatefulWidget {
//   final String stockHeadId;

//   const ViewStockHeadPage({super.key, required this.stockHeadId});

//   @override
//   State<ViewStockHeadPage> createState() => _ViewStockHeadPageState();
// }

// class _ViewStockHeadPageState extends State<ViewStockHeadPage>
//     with SingleTickerProviderStateMixin {
//   final StockHeadListingController controller =
//       Get.find<StockHeadListingController>();
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     controller.getStockHeadListingDetails(stockHeadName: widget.stockHeadId);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: grey1,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeaderWidget(
//             header: 'View Stock Head',
//             wantBackButton: true,
//             onBackButtonTap: () {
//               SidebarController sidebarController = Get.find();
//               sidebarController.popBackSelectedWidget();
//             },
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Obx(() {
//                   final response = controller.getStockHeadDetailsResponse.value;
//                   if (response.status == Status.LOADING) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (response.status == Status.ERROR) {
//                     return Center(child: Text('Error: ${response.message}'));
//                   } else if (response.status == Status.COMPLETED) {
//                     final stockHeadDetails = response.data?.values?.first;
//                     if (stockHeadDetails == null) {
//                       return const Center(child: Text('No details found'));
//                     }
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildDetailsTab(stockHeadDetails),
//                         const SizedBox(height: 16),
//                         _buildGroupSection(stockHeadDetails),
//                       ],
//                     );
//                   }
//                   return const SizedBox();
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailsTab(StockHeadValue stockHeadDetails) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 6,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMetalSection(stockHeadDetails),
//                   const SizedBox(width: 16),
//                   const CustomDashedLineWidget(
//                     width: 100,
//                     orientation: DashOrientation.vertical,
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildDetailsSection(stockHeadDetails)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Container(),
//         ),
//       ],
//     );
//   }

//   Widget _buildMetalSection(StockHeadValue stockHeadDetails) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Metal",
//           style: TextStyle(
//             fontSize: 16,
//             fontFamily: 'Satoshi',
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           stockHeadDetails.metalType?.typeName ?? 'N/A',
//           style: const TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailsSection(StockHeadValue stockHeadDetails) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Details",
//           style: TextStyle(
//             fontSize: 16,
//             fontFamily: 'Satoshi',
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildDetailItem("Stock Head Code", stockHeadDetails.code ?? 'N/A'),
//             _buildDetailItem("Stock Head Name", stockHeadDetails.name ?? 'N/A'),
//             _buildDetailItem("Stock Head Category",
//                 stockHeadDetails.category?.categoryName ?? 'N/A'),
//             _buildDetailItem("Hallmark Charges",
//                 stockHeadDetails.hallmarkExtraCharge ?? 'N/A'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailItem(String label, String value) {
//     return SizedBox(
//       width: Get.width * 0.1,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 12,
//               color: primaryColor,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGroupSection(StockHeadValue stockHeadDetails) {
//     return Container(
//       width: Get.width * 0.55,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           TabBar(
//             controller: _tabController,
//             isScrollable: true,
//             tabAlignment: TabAlignment.start,
//             tabs: const [
//               Tab(text: 'Weight Group'),
//               Tab(text: 'Size Group'),
//             ],
//             labelColor: primaryColor,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: primaryColor,
//           ),
//           SizedBox(
//             height: 400,
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildWeightGroupTable(stockHeadDetails.weightGroups ?? []),
//                 _buildSizeGroupTable(stockHeadDetails.sizeGroups ?? []),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeightGroupTable(List<WeightGroup> weightGroups) {
//     final headers = ["Code", "Name", "Weight (gm)", ""];
//     final columnWidths = [0.4, 1.16, 0.4, 0.15];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: CustomTableWidget(
//         headers: [_buildTableHeaders(headers)],
//         columnWidths: columnWidths,
//         rows: _buildWeightGroupRows(weightGroups),
//         addSizedBox: false,
//       ),
//     );
//   }

//   Widget _buildSizeGroupTable(List<SizeGroup> sizeGroups) {
//     final headers = ["Code", "Size", ""];
//     final columnWidths = [0.4, 1.56, 0.15];

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: CustomTableWidget(
//         headers: [_buildTableHeaders(headers)],
//         columnWidths: columnWidths,
//         rows: _buildSizeGroupRows(sizeGroups),
//         addSizedBox: false,
//       ),
//     );
//   }

//   TableRow _buildTableHeaders(List<String> headers) {
//     return TableRow(
//       children: headers.map((header) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//           child: CustomText(
//             text: header,
//             fontSize: 14,
//             overflow: TextOverflow.ellipsis,
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   List<TableRow> _buildWeightGroupRows(List<WeightGroup> weightGroups) {
//     return weightGroups.map((group) {
//       return TableRow(
//         children: [
//           _buildCell(group.code ?? ''),
//           _buildCell(group.name ?? ''),
//           _buildCell("${group.minWeight ?? ''} - ${group.maxWeight ?? ''}"),
//           _buildCell(''),
//         ],
//       );
//     }).toList();
//   }

//   List<TableRow> _buildSizeGroupRows(List<SizeGroup> sizeGroups) {
//     return sizeGroups.map((group) {
//       return TableRow(
//         children: [
//           _buildCell(group.code ?? ''),
//           _buildCell(group.size ?? ''),
//           _buildCell(''),
//         ],
//       );
//     }).toList();
//   }

//   Widget _buildCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }
