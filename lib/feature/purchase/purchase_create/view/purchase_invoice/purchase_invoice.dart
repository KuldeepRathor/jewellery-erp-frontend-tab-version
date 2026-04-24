// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/view/add_customer_dialog.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/view/header_widget.dart';
// import '../../../../utils/widgets/custom_button2.dart';
// import '../item_list_sample_widget.dart';
// import 'package:flutter/services.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';

// class PurchaseInvoice extends StatefulWidget {
//   const PurchaseInvoice({super.key});

//   @override
//   State<PurchaseInvoice> createState() => _PurchaseInvoiceState();
// }

// class _PurchaseInvoiceState extends State<PurchaseInvoice>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       length: 2,
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _openEditPage() {
//     debugPrint('Edit Page Opened');
//     Get.dialog(const AddCustomerDialog());
//   }

//   void _openNextScreen() {
//     debugPrint('Next Screen Opened');
//   }

//   void _clickVendorButton() {
//     debugPrint('Vendor Button Clicked');
//   }

//   void _clickCustomerButton() {
//     debugPrint('Customer Button Clicked');
//     // Implement the customer button click action
//   }

//   void _addNewRow() {
//     debugPrint('New Row Added');
//     // Implement the action to add a new row
//   }

//   void _removeRow() {
//     debugPrint('Row Removed');
//     // Implement the action to remove a row
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Actions(
//       actions: <Type, Action<Intent>>{
//         EditPageIntent: CallbackAction<EditPageIntent>(
//           onInvoke: (intent) => _openEditPage(),
//         ),
//         NextScreenIntent: CallbackAction<NextScreenIntent>(
//           onInvoke: (intent) => _openNextScreen(),
//         ),
//         VendorButtonIntent: CallbackAction<VendorButtonIntent>(
//           onInvoke: (intent) => _clickVendorButton(),
//         ),
//         CustomerButtonIntent: CallbackAction<CustomerButtonIntent>(
//           onInvoke: (intent) => _clickCustomerButton(),
//         ),
//         AddRowIntent: CallbackAction<AddRowIntent>(
//           onInvoke: (intent) => _addNewRow(),
//         ),
//         RemoveRowIntent: CallbackAction<RemoveRowIntent>(
//           onInvoke: (intent) => _removeRow(),
//         ),
//       },
//       child: Shortcuts(
//         shortcuts: <LogicalKeySet, Intent>{
//           LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE):
//               const EditPageIntent(),
//           LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
//               const NextScreenIntent(),
//           LogicalKeySet(LogicalKeyboardKey.keyV): const VendorButtonIntent(),
//           LogicalKeySet(LogicalKeyboardKey.keyC): const CustomerButtonIntent(),
//           LogicalKeySet(LogicalKeyboardKey.enter): const AddRowIntent(),
//           LogicalKeySet(LogicalKeyboardKey.escape): const RemoveRowIntent(),
//         },
//         child: Focus(
//             autofocus: true,
//             child: Container(
//               color: grey1,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   HeaderWidget(
//                     header: 'Purchase Invoice',
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Flexible(
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                     height: 38,
//                                     width: Get.width * 0.5,
//                                     child: TextFormField(
//                                       decoration: const InputDecoration(
//                                         border: InputBorder.none,
//                                         contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 16.0,
//                                           vertical: 14.0,
//                                         ),
//                                         hintText: 'Search',
//                                         hintStyle: TextStyle(
//                                           color: greyTextColor,
//                                         ),
//                                         suffixIcon: Icon(
//                                           Icons.search,
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 CustomButton2(
//                                   onTap: () {},
//                                   buttonName: 'Filter',
//                                   image: 'assets/svgs/filter.svg',
//                                 ),
//                                 const SizedBox(width: 16),
//                                 CustomButton2(
//                                   onTap: () {},
//                                   image: 'assets/svgs/download.svg',
//                                   buttonName: 'Download',
//                                 ),
//                                 SizedBox(
//                                   width: Get.width * 0.375,
//                                 ),
//                                 CustomButton2(
//                                   onTap: () {},
//                                   image: 'assets/svgs/add.svg',
//                                   buttonName: 'New Purchase',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // const Padding(
//                                   //   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                                   //   child: CustomText(
//                                   //     text: 'Item Details',
//                                   //     fontSize: 18,
//                                   //     fontWeight: FontWeight.bold,
//                                   //   ),
//                                   // ), const SizedBox(height: 24),
//                                   TabBar(
//                                     isScrollable: true,
//                                     labelColor: primaryColor,
//                                     tabAlignment: TabAlignment.start,
//                                     unselectedLabelColor: Colors.grey,
//                                     indicatorColor: primaryColor,
//                                     controller: _tabController,
//                                     tabs: const [
//                                       Tab(
//                                         child: Text(
//                                           "Vendor Purchases",
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontFamily: 'Satoshi',
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                       Tab(
//                                         child: Text(
//                                           "Customer Purchases",
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontFamily: 'Satoshi',
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 16),
//                                   SizedBox(
//                                     height: 400, // Adjust the height as needed
//                                     child: TabBarView(
//                                       controller: _tabController,
//                                       children: const [
//                                         // ItemListSampleWidget(),
//                                         ItemListTableWidget(
//                                           headers: [
//                                             'Sn',
//                                             'Code',
//                                             'Item Description',
//                                             'Pcs',
//                                             'G.Wt. (gm)',
//                                             'N.Wt. (gm)',
//                                             'VA/Pur%',
//                                             'MC (₹)',
//                                             'Stone (₹)',
//                                             'Rate (₹)',
//                                             'Amount (₹)',
//                                             ''
//                                           ],
//                                           columnWidths: [
//                                             0.1, // Sn
//                                             0.15, // Code
//                                             0.7, // Item Description
//                                             0.2, // Pcs
//                                             0.3, // G.Wt. (gm)
//                                             0.3, // N.Wt. (gm)
//                                             0.2, // VA/Pur%
//                                             0.3, // MC (₹)
//                                             0.3, // Stone (₹)
//                                             0.3, // Rate (₹)
//                                             0.3, // Amount (₹)
//                                             0.1, // Options
//                                           ],
//                                         ),
//                                         Center(
//                                             child: Text('Content for Tab 2')),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 24),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
// }
