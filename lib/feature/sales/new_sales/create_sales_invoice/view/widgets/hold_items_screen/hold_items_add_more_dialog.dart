import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/hold_items_table_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';

class AddMoreItemsDialog extends StatelessWidget {
  AddMoreItemsDialog({super.key});
  final HoldItemDetailsController controller =
      Get.find<HoldItemDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: Get.width * 0.6,
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Hold Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF28328B),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: controller.clearHoldItems,
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Form(
              key: controller.dialogFormKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.itemDescriptionController,
                      autofocus: true,
                      onEditingComplete: () {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Item Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item description';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: controller.netWeightController,
                      onEditingComplete: () {
                        FocusManager.instance.primaryFocus?.nextFocus();
                      },
                      decoration: const InputDecoration(
                        labelText: 'Net Weight',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter net weight';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  CustomButton1(
                    buttonName: "Add",
                    onTap: controller.addHoldItem,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(
                () =>
                    controller.holdItems.isEmpty
                        ? const Center(
                          child: Text(
                            'No hold items added',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hold Items',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF28328B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.separated(
                                itemCount: controller.holdItems.length,
                                separatorBuilder:
                                    (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  final item = controller.holdItems[index];
                                  return ListTile(
                                    title: Text(item.itemDescription),
                                    subtitle: Text(
                                      'Net Weight: ${item.netWeight}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () =>
                                              controller.removeHoldItem(index),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CustomButton1(buttonName: "Done", onTap: Get.back)],
            ),
          ],
        ),
      ),
    );
  }
}
