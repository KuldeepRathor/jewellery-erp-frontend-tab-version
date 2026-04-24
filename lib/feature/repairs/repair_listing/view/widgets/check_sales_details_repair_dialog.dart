import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/repairs/repair_listing/view_model/repair_status_controlller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button1.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';

class CheckSalesDetailsRepairDialog extends StatelessWidget {
  final String repairId;
  final String status;

  const CheckSalesDetailsRepairDialog({
    super.key,
    required this.repairId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final RepairStatusController controller = Get.put<RepairStatusController>(
      RepairStatusController(initialStatus: status, repairId: repairId),
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveQuickOldGoldEstimateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveQuickOldGoldEstimateIntent:
                CallbackAction<SaveQuickOldGoldEstimateIntent>(
                  onInvoke: (SaveQuickOldGoldEstimateIntent intent) {
                    return;
                  },
                ),
          },
          child: Focus(
            autofocus: true,
            child: Container(
              height: Get.height * .6,
              width: Get.width * .6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildSalesDetailsForm(controller)),
                    _buildFooter(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            text: 'Verify Sales Details',
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

  Widget _buildSalesDetailsForm(RepairStatusController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomTextField(
                  width: Get.width * 0.2,
                  name: "Sales Number",
                  controller: controller.salesNoController,
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    Obx(
                      () => CustomButton1(
                        buttonName: "Fetch Details",
                        onTap:
                            controller.isLoadingTagging.value
                                ? null
                                : controller.fetchSalesDetails,
                        isLoading: controller.isLoadingTagging.value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display sales details
            Obx(() {
              final response = controller.getSaleBySalesNumberResponse.value;

              if (response.status == Status.LOADING) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }

              if (response.status != Status.COMPLETED ||
                  response.data == null) {
                return const SizedBox.shrink();
              }

              final salesDetails = response.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: CustomText(
                      text: 'Sales Information',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),

                  // Basic sales information
                  _buildInfoSection(
                    title: 'Basic Details',
                    children: [
                      _buildDetailRow(
                        'Sales Number:',
                        salesDetails.saleNumber ?? 'N/A',
                      ),
                      _buildDetailRow(
                        'Date:',
                        convertDateTimeToString(salesDetails.createdAt),
                      ),
                      _buildDetailRow(
                        'Payment Status:',
                        salesDetails.paymentStatus ?? 'N/A',
                      ),
                      if (salesDetails.remarks != null &&
                          salesDetails.remarks!.isNotEmpty)
                        _buildDetailRow('Remarks:', salesDetails.remarks ?? ''),
                    ],
                  ),

                  // Customer information
                  if (salesDetails.partyDetails != null)
                    _buildInfoSection(
                      title: 'Customer Details',
                      children: [
                        _buildDetailRow(
                          'Name:',
                          salesDetails.partyDetails?.name ?? 'N/A',
                        ),
                        _buildDetailRow(
                          'Phone:',
                          salesDetails.partyDetails?.phoneNumber ?? 'N/A',
                        ),
                        if (salesDetails.partyDetails?.panNumber != null)
                          _buildDetailRow(
                            'PAN:',
                            salesDetails.partyDetails?.panNumber ?? '',
                          ),
                        if (salesDetails.partyDetails?.gstNumber != null)
                          _buildDetailRow(
                            'GST:',
                            salesDetails.partyDetails?.gstNumber ?? '',
                          ),
                      ],
                    ),

                  // Item details
                  if (salesDetails.lineItems != null &&
                      salesDetails.lineItems!.isNotEmpty)
                    _buildInfoSection(
                      title: 'Item Details',
                      children: [
                        ...salesDetails.lineItems!.map(
                          (item) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Item: ${item.description ?? 'N/A'}',
                                fontWeight: FontWeight.w600,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  top: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(
                                      'Code:',
                                      item.code ?? 'N/A',
                                    ),
                                    _buildDetailRow(
                                      'Tag Number:',
                                      item.tag ?? 'N/A',
                                    ),
                                    _buildDetailRow(
                                      'Pieces:',
                                      '${item.finalPieces ?? item.taggingPieces ?? 'N/A'}',
                                    ),
                                    _buildDetailRow(
                                      'Net Weight:',
                                      item.finalNetWeight ??
                                          item.taggingNetWeight ??
                                          'N/A',
                                    ),
                                    _buildDetailRow(
                                      'Rate:',
                                      item.rate ?? 'N/A',
                                    ),
                                    _buildDetailRow(
                                      'Amount:',
                                      item.totalAmount ?? 'N/A',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),

                  // Payment details
                  // if (salesDetails.paymentDetails != null &&
                  //     salesDetails.paymentDetails!.isNotEmpty)
                  //   _buildInfoSection(
                  //     title: 'Payment Details',
                  //     children: [
                  //       _buildDetailRow(
                  //           'Total Amount:',
                  //           salesDetails.paymentDetails![0].finalAmount ??
                  //               'N/A'),
                  //       _buildDetailRow(
                  //           'Received:',
                  //           salesDetails.paymentDetails![0].receivedAmount ??
                  //               'N/A'),
                  //       _buildDetailRow(
                  //           'Balance:',
                  //           salesDetails.paymentDetails![0].balanceAmount ??
                  //               'N/A'),
                  //       if (salesDetails
                  //               .paymentDetails![0].paymentMethodDetails !=
                  //           null)
                  //         const Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             SizedBox(height: 8),
                  //             CustomText(
                  //               text: 'Payment Methods:',
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //             // ...salesDetails.paymentDetails![0].paymentMethodDetails!.map((payment) => Padding(
                  //             //   padding: const EdgeInsets.only(left: 16, top: 4),
                  //             //   child: CustomText(
                  //             //     text: '${payment.method}: ${payment.amount} (${convertDateToString(payment.date)})',
                  //             //   ),
                  //             // )).toList(),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
          const Divider(),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.12,
            child: CustomText(
              text: label,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Tooltip(
              message: value,
              child: CustomText(text: value, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(RepairStatusController controller) {
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
          Obx(
            () => InkWell(
              onTap:
                  controller.isLoading.value
                      ? null
                      : () {
                        final response =
                            controller.getSaleBySalesNumberResponse.value;
                        if (response.status == Status.COMPLETED &&
                            response.data != null) {
                          controller.updateStatusWithSalesId();
                        } else {
                          showErrorToast(
                            message: 'Please fetch valid sales details first',
                          );
                        }
                      },
              child: Container(
                width: 120,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child:
                      controller.isLoading.value
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
