import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/orders/create_order/view_model/create_order_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class AddNotesDialog extends StatelessWidget {
  const AddNotesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateOrderViewModel controller = Get.find<CreateOrderViewModel>();
    final TextEditingController tempNotesController = TextEditingController(
      text: controller.notesController.text,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: Get.width * 0.5,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Add Notes",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tempNotesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your notes here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: secondaryColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const CustomText(
                    text: "Cancel",
                    color: grey2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    controller.notesController.text = tempNotesController.text;
                    controller.hasNotes.value =
                        tempNotesController.text.isNotEmpty;
                    Get.back();
                  },
                  child: const CustomText(
                    text: "Save",
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
