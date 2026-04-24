import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/quick_estimate/sales_quick_estimate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class SalesQuickEstimateDialog extends StatelessWidget {
  const SalesQuickEstimateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesQuickEstimateController controller =
        Get.find<SalesQuickEstimateController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveAdvanceBookingIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveAdvanceBookingIntent: CallbackAction<SaveAdvanceBookingIntent>(
              onInvoke: (SaveAdvanceBookingIntent intent) {
                controller.handleQuickEstimateDone();
                return;
              },
            ),
          },
          child: Container(
            height: Get.height * .65,
            width: Get.width * .5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: controller.quickEstimateFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller),
                  Expanded(child: _buildBookingForm(controller)),
                  _buildFooter(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SalesQuickEstimateController controller) {
    return Container(
      height: 54,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: 'Add Estimate',
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm(SalesQuickEstimateController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Booking Details",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  autofocus: true,
                  controller: controller.estimateNumberTextController,
                  name: 'Estimate Number',
                  width: Get.width * .2,
                  onEditingComplete: () {
                    controller.fetchEstimateByEstimateNumber();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Estimate details';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final textController =
                        controller.estimateNumberTextController;
                    final capitalizedValue = value.toUpperCase();
                    final currentCursorPosition =
                        textController.selection.baseOffset;
                    textController.value = TextEditingValue(
                      text: capitalizedValue,
                      selection: TextSelection.collapsed(
                        offset: currentCursorPosition,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     const CustomText(text: ""),
              //     Obx(
              //       () => CustomButton1(
              //         buttonName: 'Fetch Details',
              //         isLoading: controller
              //                 .getEstimateByEstimationNumberResponse
              //                 .value
              //                 .status ==
              //             Status.LOADING,
              //         onTap: controller.fetchEstimateByEstimateNumber,
              //       ),
              //     ),
              //   ],
              // ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              final response =
                  controller.getEstimateByEstimationNumberResponse.value;

              switch (response.status) {
                case Status.LOADING:
                  return const Center(child: CircularProgressIndicator());

                case Status.COMPLETED:
                  if (response.data?.lineItems == null ||
                      response.data!.lineItems!.isEmpty) {
                    return const Center(child: Text('No items found'));
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            text: "Found Items:",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.selectAllItems,
                            child: const Text('Select All'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: controller.clearSelection,
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const CustomDashedLineWidget(width: double.infinity),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: response.data!.lineItems!.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = response.data!.lineItems![index];
                            return _buildListItem(controller, item, index);
                          },
                        ),
                      ),
                    ],
                  );

                case Status.ERROR:
                  return Center(
                    child: Text(
                      response.message ?? 'Error occurred',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    SalesQuickEstimateController controller,
    GetSaleByEstimateResponseLineItem item,
    int index,
  ) {
    final bool isAvailable =
        item.taggingDetails?.status?.toLowerCase() == "available";

    return Obx(
      () => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: isAvailable ? Colors.grey[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),

          // border: Border.all(
          //   color: isAvailable ? Colors.transparent : Colors.grey[300]!,
          // ),
          child: CheckboxListTile(
            value: controller.isItemSelected(index),
            onChanged:
                isAvailable
                    ? (bool? value) => controller.toggleItemSelection(index)
                    : null,
            title: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // color: isAvailable ? Colors.grey[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isAvailable ? Colors.transparent : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description ?? 'No description',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isAvailable ? Colors.black : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Code: ${item.code ?? 'N/A'}',
                              style: TextStyle(
                                color:
                                    isAvailable
                                        ? Colors.grey
                                        : Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isAvailable
                                        ? Colors.green[100]
                                        : Colors.orange[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.taggingDetails?.status ?? 'Unknown',
                                style: TextStyle(
                                  color:
                                      isAvailable
                                          ? Colors.green[800]
                                          : Colors.orange[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Net Wt: ${item.finalNetWeight ?? '0'} g',
                      style: TextStyle(
                        fontSize: 13,
                        color: isAvailable ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'VA: ${item.finalVa ?? '0'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isAvailable ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'MC: ${item.finalMc ?? '0'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isAvailable ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            enabled: isAvailable,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(SalesQuickEstimateController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: controller.handleQuickEstimateDone,
            child: Container(
              width: 120,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Obx(
                  () =>
                      controller
                                  .getEstimateByEstimationNumberResponse
                                  .value
                                  .status ==
                              Status.LOADING
                          ? const CircularProgressIndicator(color: whiteColor)
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Done",
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: " (ctrl + s)",
                                color: whiteColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
