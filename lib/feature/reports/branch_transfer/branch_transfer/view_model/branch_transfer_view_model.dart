// ignore_for_file: library_prefixes

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_in_request_model.dart'
    as BranchIn;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_by_no_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_request_model.dart'
    as BranchOut;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/counter_drop_down_model.dart'
    as Counter;
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_by_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/branch_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BranchTransferItemDetailsController extends GetxController {
  int tabControllerIndex = 0;
  BranchTransferItemDetailsController({required this.tabControllerIndex});
  final BranchReportRepository branchReportServices = BranchReportRepository();
  final formKey = GlobalKey<FormState>();
  final _debouncer = CustomDebouncer(milliseconds: 500);
  final headers = [
    'Sn',
    'Existing Tag Number',
    'Counter Number',
    'Description',
    'Gross Wt (gm)',
    'Net Wt (gm)',
    'Stone Cost(₹)',
    'Total Cost (₹)',
    ' ',
  ];

  final columnWidths = [0.2, 0.5, 0.5, 0.7, 0.5, 0.5, 0.44, 0.4, 0.2].obs;

  final controllers = <RowController>[].obs;

  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;

  final RxList<String> totalHeadersValue = <String>[].obs;

  String branchTransferToUUID = '';
  String branchTransferByUUID = '';

  TextEditingController branchTransferFrom = TextEditingController();
  TextEditingController branchTransferBy = TextEditingController();
  final Rx<ApiResponse<TransferToDropDownModel>> transferToDroopDownList = Rx(
    ApiResponse.initial("initial"),
  );

  final Rx<ApiResponse<TransferByDropDownModel>> transferByDroopDownList = Rx(
    ApiResponse.initial("initial"),
  );

  final Rx<ApiResponse<TransferByDropDownModel>> counterListDropdown = Rx(
    ApiResponse.initial("initial"),
  );
  final RxList<Counter.Value> counterList = <Counter.Value>[].obs;

  Counter.Value? defaultCounter;
  TextEditingController branchOutDataFetchController = TextEditingController();

  GetTaggingLineItemCodeTagResponse? getTaggingLineItemCodeTagResponse;
  BranchOutByNoResponseModel? branchOutByNoResponseModel;

  final RxBool showItemPreview = false.obs;
  final Rx<dynamic> currentItemDetails = Rx<dynamic>(null);

  final RxList<dynamic> selectedLineItems = RxList<dynamic>([]);

  @override
  void onInit() {
    initializeData();
    super.onInit();
  }

  void initializeData() {
    fetchDropDownData();
    addRow();
  }

  void fetchDropDownData() async {
    await Future.wait([
      getCounterList(),
      getAllTransferBy(),
      getAllTransferTo(),
    ]);
  }

  void addRow() {
    controllers.add(RowController());

    if (defaultCounter != null) {
      controllers.last.counterId.text = defaultCounter!.id ?? '';
    }
    updateTotals();
    update();
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    }
  }

  void removeCurrentRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      updateTotals();
      update();
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    }
  }

  void updateTotals() {
    try {
      double totalGWt = 0.0;
      double totalNWt = 0.0;
      double totalStoneCost = 0.0;
      double totalCost = 0.0;

      for (var row in controllers) {
        // Parse values safely with null checks and error handling
        totalGWt += double.tryParse(row.grossWt.text.trim()) ?? 0.0;
        totalNWt += double.tryParse(row.netWt.text.trim()) ?? 0.0;
        totalStoneCost += double.tryParse(row.stoneCost.text.trim()) ?? 0.0;
        totalCost += double.tryParse(row.totalCost.text.trim()) ?? 0.0;
      }

      // Update the totalHeadersValue with formatted values
      totalHeadersValue.value = [
        "Total",
        "", // Empty for existing tag number
        "", // Empty for counter number
        "", // Empty for description
        totalGWt.toStringAsFixed(3),
        totalNWt.toStringAsFixed(3),
        totalStoneCost.toStringAsFixed(2),
        totalCost.toStringAsFixed(2),
        "", // Empty for action column
      ];
    } catch (e) {
      log("Error updating totals: $e");
      // Set default values in case of error
      totalHeadersValue.value = [
        "Total",
        "",
        "",
        "",
        "0.000",
        "0.000",
        "0.00",
        "0.00",
        "",
      ];
    }
    update();
  }

  void moveFocusToNextCell(int rowIndex, int colIndex) {
    final isLastColumn = colIndex == headers.length - 2;
    final isLastRow = rowIndex == controllers.length - 1;

    if (isLastColumn) {
      if (isLastRow) {
        addRow();
      }
      currentRowIndex.value = isLastRow ? controllers.length - 1 : rowIndex + 1;
      currentColIndex.value = 0;
    } else {
      currentColIndex.value = colIndex + 1;
    }

    final nextFocusNode = controllers[currentRowIndex.value].getFocusNode(
      currentColIndex.value,
    );
    nextFocusNode.requestFocus();
  }

  KeyEventResult handleTableKeyEvent(
    FocusNode node,
    KeyEvent event,
    int rowIndex,
    int colIndex,
  ) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      moveFocusToNextCell(rowIndex, colIndex);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
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

  Future<void> submitBranchIn() async {
    try {
      // Validate that branch out data has been fetched
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
            // Validate all fields
            // if (controller.extistingTagNumber.text.isEmpty) {
            //   throw Exception('Please enter an existing Tag Number for all items.');
            // }
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

            // Find matching item from branchOutByNoResponseModel
            final matchingItem = branchOutByNoResponseModel?.values
                ?.firstWhereOrNull(
                  (item) =>
                      item.description == controller.extistingTagNumber.text,
                );

            // Get tagging ID - try itemId first, then id, then use description as fallback
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

  Future<void> getAllTransferTo() async {
    try {
      transferToDroopDownList.value = ApiResponse.loading("loading");
      final response = await branchReportServices.getAllTransferTo();
      transferToDroopDownList.value = ApiResponse.completed(response);
      update();
    } catch (e) {
      transferToDroopDownList.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getAllTransferBy() async {
    try {
      transferByDroopDownList.value = ApiResponse.loading("loading");
      final response = await branchReportServices.getAllTransferBy();
      transferByDroopDownList.value = ApiResponse.completed(response);
      update();
    } catch (e) {
      transferByDroopDownList.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getCounterList() async {
    try {
      final response = await branchReportServices.getCounterList();
      counterList.assignAll(response.values ?? []);

      defaultCounter = counterList.firstWhereOrNull(
        (counter) => counter.isDefault == true,
      );
    } catch (e) {
      log('Error fetching counter List: $e');
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
        Get.snackbar('Error', 'Failed to fetch Branch Out details');
        showItemPreview.value = false;
        currentItemDetails.value = null;
        selectedLineItems.clear();
      }
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

  List<dynamic> getPreviewItems() {
    return selectedLineItems;
  }

  void clearItemPreview() {
    showItemPreview.value = false;
    currentItemDetails.value = null;
    selectedLineItems.clear();
    update();
  }

  @override
  void onClose() {
    clearItemPreview();
    super.onClose();
  }
}

class RowController {
  final TextEditingController snController = TextEditingController();
  final TextEditingController extistingTagNumber = TextEditingController();
  final TextEditingController counterId = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController grossWt = TextEditingController();
  final TextEditingController netWt = TextEditingController();
  final TextEditingController stoneCost = TextEditingController();
  final TextEditingController totalCost = TextEditingController();
  final TextEditingController action = TextEditingController();

  final List<FocusNode> tableFocusNodes = List.generate(9, (_) => FocusNode());

  TextEditingController getController(int colIndex) {
    return [
      snController,
      extistingTagNumber,
      counterId,
      description,
      grossWt,
      netWt,
      stoneCost,
      totalCost,
      action,
    ][colIndex];
  }

  FocusNode getFocusNode(int colIndex) {
    return tableFocusNodes[colIndex];
  }

  void dispose() {
    snController.clear();
    extistingTagNumber.dispose();
    counterId.dispose();
    description.dispose();
    grossWt.dispose();
    netWt.dispose();
    stoneCost.dispose();
    totalCost.dispose();
    for (var focusNode in tableFocusNodes) {
      focusNode.dispose();
    }
  }
}
