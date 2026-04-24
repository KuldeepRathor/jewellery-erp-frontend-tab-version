// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_in_request_model.dart'
    as BranchIn;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_by_no_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/base_branch_transfer_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BranchInTransferViewModel extends BaseBranchTransferViewModel {
  TextEditingController branchOutDataFetchController = TextEditingController();
  BranchOutByNoResponseModel? branchOutByNoResponseModel;

  @override
  Future<void> submit() async {
    await submitBranchIn();
  }

  Future<void> submitBranchIn() async {
    try {
      if (branchOutByNoResponseModel == null ||
          branchOutByNoResponseModel?.values == null ||
          branchOutByNoResponseModel!.values!.isEmpty) {
        throw Exception(
          'Please fetch Branch Out data first using the Branch Out No.',
        );
      }

      if (branchTransferToUUID.isEmpty) {
        throw Exception(
          'Transfer from branch (shop_id) information is missing.',
        );
      }
      if (branchTransferByUUID.isEmpty) {
        throw Exception('Employee information is missing.');
      }

      if (branchOutDataFetchController.text.isEmpty) {
        throw Exception('Please enter Branch Out Number.');
      }

      final lineItems =
          controllers.map((controller) {
            if (controller.counterId.text.isEmpty) {
              throw Exception('Please enter a Counter Number for all items.');
            }
            if (controller.description.text.isEmpty) {
              throw Exception('Please provide a Description for all items.');
            }
            if (controller.grossWt.text.isEmpty) {
              throw Exception('Please enter Gross Weight for all items.');
            }
            if (controller.netWt.text.isEmpty) {
              throw Exception('Please enter Net Weight for all items.');
            }
            if (controller.stoneCost.text.isEmpty) {
              throw Exception('Please enter Stone Cost for all items.');
            }
            if (controller.totalCost.text.isEmpty) {
              throw Exception('Please enter Total Cost for all items.');
            }

            final matchingItem = branchOutByNoResponseModel?.values
                ?.firstWhereOrNull(
                  (item) =>
                      item.description == controller.extistingTagNumber.text,
                );

            final taggingId =
                matchingItem?.itemId ??
                matchingItem?.itemId ??
                controller.extistingTagNumber.text;

            return BranchIn.LineItem(
              taggingId: taggingId,
              counter: BranchIn.Counter(id: controller.counterId.text),
              description: controller.description.text,
              grossWeight: controller.grossWt.text,
              netWeight: controller.netWt.text,
              stoneCost: controller.stoneCost.text,
              totalCost: controller.totalCost.text,
            );
          }).toList();

      final branchInRequest = BranchIn.BranchInRequestModel(
        transferFromBranch: branchTransferToUUID,
        employeeId: branchTransferByUUID,
        lineItems: lineItems,
        branchTransferNumber: branchOutDataFetchController.text,
      );

      await branchReportServices.branchInSubmit(branchInRequest);

      // Clear data after successful submission
      controllers.clear();
      branchOutByNoResponseModel = null;
      branchOutDataFetchController.clear();
      branchTransferFrom.clear();
      branchTransferBy.clear();
      branchTransferToUUID = '';
      branchTransferByUUID = '';

      onInit();
      showSuccessToast(message: 'Branch In record submitted successfully');
    } catch (e) {
      showErrorToast(message: e.toString().replaceAll('Exception: ', ''));
    } finally {
      Get.back();
    }
  }

  Future<void> fetchBranchOutByNumber() async {
    final branchOutNumber = branchOutDataFetchController.text;
    if (branchOutNumber.isNotEmpty) {
      try {
        branchOutByNoResponseModel = await branchReportServices
            .fetchBranchOutByNumber(branchOutNumber);
        if (branchOutByNoResponseModel?.values != null) {
          controllers.clear();
          for (
            int index = 0;
            index < branchOutByNoResponseModel!.values!.length;
            index++
          ) {
            branchTransferFrom.text =
                transferToDroopDownList.value.data?.values
                    ?.firstWhereOrNull(
                      (item) =>
                          item.id ==
                          branchOutByNoResponseModel!.values![index].shopId,
                    )
                    ?.branchName ??
                '';
            branchTransferToUUID =
                branchOutByNoResponseModel!.values!.first.shopId ?? '';

            branchTransferBy.text =
                transferByDroopDownList.value.data?.values
                    ?.firstWhereOrNull(
                      (item) =>
                          item.id ==
                          branchOutByNoResponseModel!.values![index].employeeId,
                    )
                    ?.firstName ??
                '';
            branchTransferByUUID =
                branchOutByNoResponseModel!.values!.first.employeeId ?? '';

            controllers.insert(index, RowController());
            controllers[index].snController.text = '${index + 1}';
            controllers[index].extistingTagNumber.text =
                '${branchOutByNoResponseModel!.values![index].description}';
            controllers[index].counterId.text = defaultCounter?.id ?? "";
            controllers[index].description.text =
                '${branchOutByNoResponseModel!.values![index].description}';
            controllers[index].grossWt.text =
                '${branchOutByNoResponseModel!.values![index].grossWeight}';
            controllers[index].netWt.text =
                '${branchOutByNoResponseModel!.values![index].netWeight}';
            controllers[index].stoneCost.text =
                '${branchOutByNoResponseModel!.values![index].stoneCost}';
            controllers[index].totalCost.text =
                '${branchOutByNoResponseModel!.values![index].totalCost}';
          }
        }
        currentItemDetails.value = branchOutByNoResponseModel?.values?.first;
        selectedLineItems.clear();
        selectedLineItems.addAll(branchOutByNoResponseModel?.values ?? []);
        showItemPreview.value = true;
        updateTotals();
        update();
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch Branch Out details');
        showItemPreview.value = false;
        currentItemDetails.value = null;
        selectedLineItems.clear();
      }
    }
  }
}
