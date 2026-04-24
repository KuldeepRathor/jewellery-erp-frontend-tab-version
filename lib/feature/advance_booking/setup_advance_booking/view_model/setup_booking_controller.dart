import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/setup_advance_booking/model/get_setup_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class SetupBookingController extends GetxController {
  final formRows = <FormRow>[].obs;

  final JewelleryPlanRepository _repository = JewelleryPlanRepository();
  final getAdvanceBookingSetupResponse =
      Rx<ApiResponse<GetAdvanceBookingSetupResponse>>(
        ApiResponse.initial("Initial"),
      );

  @override
  void onInit() {
    super.onInit();
    getAdvanceBookingSetup();
  }

  Future<void> getAdvanceBookingSetup() async {
    try {
      getAdvanceBookingSetupResponse.value = ApiResponse.loading("Loading");
      final response = await _repository.getAdvanceBookingSetup();
      getAdvanceBookingSetupResponse.value = ApiResponse.completed(response);

      if (response.setup != null && response.setup!.isNotEmpty) {
        formRows.clear();
        for (var setup in response.setup!) {
          formRows.add(
            FormRow(
              fromController: TextEditingController(text: setup.weightFrom),
              toController: TextEditingController(text: setup.weightTo),
              advanceController: TextEditingController(
                text: setup.advancePercentage?.toString(),
              ),
              redeemController: TextEditingController(
                text: setup.redeemDuration?.toString(),
              ),
            ),
          );
        }
      } else {
        formRows.add(FormRow());
      }
    } catch (e) {
      getAdvanceBookingSetupResponse.value = ApiResponse.error(e.toString());
    }
  }

  void addNewRow() {
    formRows.add(FormRow());
  }

  void removeRow(int index) {
    if (formRows.length > 1) {
      formRows.removeAt(index);
    }
  }

  Future<void> saveSetup() async {
    try {
      // ignore: unused_local_variable
      final List<Map<String, dynamic>> setupData =
          formRows
              .map(
                (row) => {
                  "weight_from": row.fromController.text,
                  "weight_to": row.toController.text,
                  "advance_percentage": int.parse(row.advanceController.text),
                  "redeem_duration": int.parse(row.redeemController.text),
                },
              )
              .toList();

      // Implement your save API call here
      // await _jewelleryPlanRepository.saveAdvanceBookingSetup(setupData);

      Get.back();
      showSuccessToast(message: "Setup saved successfully");
    } catch (e) {
      showErrorToast(message: e.toString());
    }
  }
}

class FormRow {
  final TextEditingController fromController;
  final TextEditingController toController;
  final TextEditingController advanceController;
  final TextEditingController redeemController;

  FormRow({
    TextEditingController? fromController,
    TextEditingController? toController,
    TextEditingController? advanceController,
    TextEditingController? redeemController,
  }) : fromController = fromController ?? TextEditingController(),
       toController = toController ?? TextEditingController(),
       advanceController = advanceController ?? TextEditingController(),
       redeemController = redeemController ?? TextEditingController();
}
