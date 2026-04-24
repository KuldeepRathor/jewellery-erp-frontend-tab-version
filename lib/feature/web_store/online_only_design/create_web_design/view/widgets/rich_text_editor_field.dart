// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/online_only_design/create_web_design/view_model/online_only_design_details_controller.dart';
// import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';

// class RichTextDescriptionField extends StatefulWidget {
//   final OnlineOnlyDesignDetailsController controller;
//   final FocusNode? focusNode;
//   final VoidCallback? onEditingComplete;

//   const RichTextDescriptionField({
//     super.key,
//     required this.controller,
//     this.focusNode,
//     this.onEditingComplete,
//   });

//   @override
//   State<RichTextDescriptionField> createState() =>
//       _RichTextDescriptionFieldState();
// }

// class _RichTextDescriptionFieldState extends State<RichTextDescriptionField> {
//   late ScrollController _editorScrollController;

//   @override
//   void initState() {
//     super.initState();
//     _editorScrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _editorScrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Row(
//           children: [
//             Text(
//               'Description',
//               style: TextStyle(
//                 color: Color(0xFF111111),
//                 fontSize: 12,
//                 fontFamily: 'Satoshi',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             Text(
//               ' *',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: secondaryColor),
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.white,
//           ),
//           child: Column(
//             children: [
//               // Toolbar
//               QuillSimpleToolbar(
//                 controller: widget.controller.descriptionQuillController,
//                 config: QuillSimpleToolbarConfig(
//                   multiRowsDisplay: false,
//                   showCodeBlock: false,
//                   showInlineCode: false,
//                   showSearchButton: false,
//                   showSubscript: false,
//                   showSuperscript: false,
//                   showColorButton: false,
//                   showBackgroundColorButton: false,
//                   showListCheck: false,
//                   showQuote: false,
//                   showIndent: false,
//                   showLink: false,
//                   showHeaderStyle: true,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     border: const Border(
//                       bottom: BorderSide(color: secondaryColor),
//                     ),
//                   ),
//                   buttonOptions: QuillSimpleToolbarButtonOptions(
//                     base: QuillToolbarBaseButtonOptions(
//                       afterButtonPressed: () {
//                         // Keep focus on editor after toolbar button press
//                         if (widget.focusNode != null && mounted) {
//                           widget.focusNode!.requestFocus();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               // Editor
//               Container(
//                 constraints: const BoxConstraints(
//                   minHeight: 100,
//                   maxHeight: 200,
//                 ),
//                 child: QuillEditor(
//                   controller: widget.controller.descriptionQuillController,
//                   scrollController: _editorScrollController,
//                   focusNode: widget.focusNode ?? FocusNode(),
//                   config: const QuillEditorConfig(
//                     placeholder: 'Enter description...',
//                     padding: EdgeInsets.all(12),
//                     scrollable: true,
//                     autoFocus: false,
//                     expands: false,
//                     keyboardAppearance: Brightness.light,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
