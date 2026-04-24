// import 'package:flutter/material.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';

// class TaggedItemsNextPreviousNavigatorWidget extends StatelessWidget {
//   final VoidCallback onPreviousPressed;
//   final VoidCallback onNextPressed;

//   const TaggedItemsNextPreviousNavigatorWidget({
//     super.key,
//     required this.onPreviousPressed,
//     required this.onNextPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(color: Colors.white),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomInkButton(onPressed: onPreviousPressed, text: "< Previous"),
//           CustomInkButton(onPressed: onNextPressed, text: "Next >")
//           // _buildNavigationButton(
//           //   icon: Icons.arrow_back_ios_rounded,
//           //   label: 'Previous',
//           //   onPressed: onPreviousPressed,
//           // ),
//           // _buildNavigationButton(
//           //   icon: Icons.arrow_forward_ios_rounded,
//           //   label: 'Next',
//           //   onPressed: onNextPressed,
//           // ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildNavigationButton({
//   //   required IconData icon,
//   //   required String label,
//   //   required VoidCallback onPressed,
//   // }) {
//   //   return Material(
//   //     color: Colors.transparent,
//   //     clipBehavior: Clip.hardEdge,
//   //     child: ElevatedButton.icon(
//   //       onPressed: onPressed,
//   //       icon: Icon(icon, color: Colors.white),
//   //       iconAlignment: IconAlignment.end,
//   //       label: Text(
//   //         label,
//   //         style: const TextStyle(
//   //           color: Colors.white,
//   //           fontSize: 16,
//   //           fontFamily: 'Satoshi',
//   //           fontWeight: FontWeight.w700,
//   //         ),
//   //       ),
//   //       style: ElevatedButton.styleFrom(
//   //         backgroundColor: secondaryColor,
//   //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(8),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
