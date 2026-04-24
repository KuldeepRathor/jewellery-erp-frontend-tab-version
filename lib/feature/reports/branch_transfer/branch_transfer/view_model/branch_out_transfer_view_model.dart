import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_request_model.dart'
    // ignore: library_prefixes
    as BranchOut;

import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/view_model/base_branch_transfer_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BranchOutTransferViewModel extends BaseBranchTransferViewModel {
  final _debouncer = CustomDebouncer(milliseconds: 500);

  @override
  Future<void> submit() async {
    await submitBranchOut();
  }

  Future<void> submitBranchOut() async {
    try {
      if (branchTransferToUUID.isEmpty) {
        throw Exception('Please select transfer to');
      }
      if (branchTransferByUUID.isEmpty) {
        throw Exception('Please select an employee.');
      }

      final lineItems =
          controllers.map((controller) {
            if (controller.extistingTagNumber.text.isEmpty) {
              throw Exception(
                'Please enter an existing Tag Number for all items.',
              );
            }
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

            return BranchOut.LineItem(
              taggingId: getTaggingLineItemCodeTagResponse?.id,
              counter: BranchOut.Counter(id: controller.counterId.text),
              description: controller.description.text,
              grossWeight: controller.grossWt.text,
              netWeight: controller.netWt.text,
              stoneCost: controller.stoneCost.text,
              totalCost: controller.totalCost.text,
              pieces: int.parse(controller.pieces.text),
            );
          }).toList();

      final branchOutRequestData = BranchOut.BranchOutRequestModel(
        transferToBranch: branchTransferToUUID,
        employeeId: branchTransferByUUID,
        lineItems: lineItems,
      );

      await branchReportServices.branchOutSubmit(branchOutRequestData);
      controllers.clear();
      onInit();
      showSuccessToast(message: 'Branch out record submitted successfully');
    } catch (e) {
      showErrorToast(message: e.toString());
    } finally {
      Get.back();
    }
  }

  Future<void> fetchByExistingTag(int index) async {
    final extistingTagNumber = controllers[index].extistingTagNumber.text;
    if (extistingTagNumber.isNotEmpty) {
      try {
        _debouncer.run(() async {
          getTaggingLineItemCodeTagResponse = await branchReportServices
              .getByExistingTag(extistingTagNumber);
          controllers[index].snController.text = '${index + 1}';
          controllers[index].extistingTagNumber.text =
              '${getTaggingLineItemCodeTagResponse?.tagBarcode}';
          controllers[index].counterId.text =
              '${getTaggingLineItemCodeTagResponse?.counter?.id}';
          controllers[index].description.text =
              '${getTaggingLineItemCodeTagResponse?.design?.name}';
          controllers[index].grossWt.text =
              '${getTaggingLineItemCodeTagResponse?.grossWeight}';
          controllers[index].netWt.text =
              '${getTaggingLineItemCodeTagResponse?.netWeight}';
          controllers[index].stoneCost.text = '32.0';
          controllers[index].totalCost.text = '50.0';
          controllers[index].pieces.text =
              '${getTaggingLineItemCodeTagResponse?.pieces}';

          currentItemDetails.value = getTaggingLineItemCodeTagResponse;
          selectedLineItems.clear();
          selectedLineItems.add(getTaggingLineItemCodeTagResponse);
          showItemPreview.value = true;
          updateTotals();
          if (index == controllers.length - 1) {
            addRow();
            Future.delayed(const Duration(milliseconds: 100), () {
              if (controllers.length > index + 1) {
                controllers[index + 1].getFocusNode(1).requestFocus();
              }
            });
          }
          update();
        });
      } catch (e) {
        Get.snackbar('Error', 'Failed to fetch tag details');
        showItemPreview.value = false;
        currentItemDetails.value = null;
        selectedLineItems.clear();
      }
    }
  }
}
