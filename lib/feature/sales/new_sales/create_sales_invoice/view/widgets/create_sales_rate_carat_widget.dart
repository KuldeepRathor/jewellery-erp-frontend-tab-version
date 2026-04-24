// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_erp_frontend_tab_version/base/api_response.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';

// class CreateSalesRateCaratInput extends StatefulWidget {
//   final void Function(double rate, String carat) onChanged;

//   const CreateSalesRateCaratInput({super.key, required this.onChanged});

//   @override
//   State<CreateSalesRateCaratInput> createState() =>
//       _CreateSalesRateCaratInputState();
// }

// class _CreateSalesRateCaratInputState extends State<CreateSalesRateCaratInput> {
//   final RateCaratInputController controller =
//       Get.put(RateCaratInputController());

//   @override
//   void initState() {
//     controller.fetchGoldRates();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       controller
//           .currentRate; // This is to make sure the widget rebuilds when the rate changes
//       return SizedBox(
//         width: 275,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Rate/gm',
//               style: TextStyle(
//                 color: Color(0xFF111111),
//                 fontSize: 12,
//                 fontFamily: 'Satoshi',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 34,
//                     decoration: const ShapeDecoration(
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Color(0xFF4758EC)),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(6),
//                           bottomLeft: Radius.circular(6),
//                         ),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.only(left: 12),
//                           child: Text(
//                             '₹ ',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontFamily: 'Satoshi',
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: controller.getGoldRatesResponse.value.status ==
//                                   Status.LOADING
//                               ? const Center(
//                                   child: SizedBox(
//                                     height: 26,
//                                     width: 26,
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                 )
//                               : Text(
//                                   controller.currentRate,
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontFamily: 'Satoshi',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 34,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: const ShapeDecoration(
//                     color: Color(0xFFE6E8FF),
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(color: Color(0xFF4758EC)),
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(6),
//                         bottomRight: Radius.circular(6),
//                       ),
//                     ),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: controller.selectedCarat.value,
//                       icon: const Icon(Icons.arrow_drop_down),
//                       iconSize: 20,
//                       elevation: 16,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontFamily: 'Satoshi',
//                         fontWeight: FontWeight.w500,
//                       ),
//                       onChanged: (String? newValue) {
//                         controller.updateSelectedCarat(newValue);
//                         // onChanged(controller.currentRate,
//                         //     controller.selectedCarat.value);
//                       },
//                       menuMaxHeight: 250,
//                       alignment: AlignmentDirectional.bottomCenter,
//                       items: controller.caratOptions
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
