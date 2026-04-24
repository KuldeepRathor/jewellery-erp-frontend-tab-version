import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/add_installment_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/get_accounts_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/view_model/add_installment_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/model/get_jewellery_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddInstallmentPaymentDetailsController extends GetxController {
  final JewelleryPlanRepository _repository = JewelleryPlanRepository();

  final paymentHeaders = [
    'Sn',
    'Amount (₹)',
    'Method',
    'Date',
    'POS/Bank',
    'UPI/UTR/Cn.',
    '',
  ];
  final paymentColumnWidths = [0.1, 0.28, 0.28, 0.28, 0.28, 0.28, 0.2];
  final controllers = <PaymentDetailsTableData>[].obs;
  final methodList = ["Cheque", "Debit Card", "Cash", "RTGS/NEFT", "UPI"];
  final Map<String, String> methodToMode = {
    "UPI": "0",
    "Debit Card": "1",
    "RTGS/NEFT": "3",
    "Cheque": "6",
    "Cash": "7",
  };

  final installmentAmountController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final accountsResponse = Rx<ApiResponse<GetAccountsResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  List<String> get bankList {
    final accounts = accountsResponse.value.data?.bankAccounts ?? [];
    return accounts.map((account) => account.number ?? "").toList();
  }

  List<String> get posList {
    final accounts = accountsResponse.value.data?.posAccounts ?? [];
    return accounts.map((account) => account.number ?? "").toList();
  }

  void initializeRow() {
    controllers.clear();
    addRow();
  }

  @override
  void onInit() {
    super.onInit();
    installmentAmountController.text = "0";
    getAccountsData();
    ever(jewelleryPlanResponse, (response) {
      if (response.data?.results?.isNotEmpty ?? false) {
        final planData = response.data?.results?.first;
        if (planData?.cost != null) {
          log("Setting amount: ${planData?.cost}");
          installmentAmountController.text = planData!.cost!.toString();
          update();
        }
      }
    });
  }

  @override
  void onClose() {
    installmentAmountController.dispose();
    for (var controller in controllers) {
      controller.amount.dispose();
      controller.method.dispose();
      controller.date.dispose();
      controller.pos_bank.dispose();
      controller.upi_utr_cn.dispose();
    }
    super.onClose();
  }

  void addRow() {
    log("Adding row");
    controllers.add(
      PaymentDetailsTableData(
        amount: TextEditingController(),
        method: TextEditingController(text: methodList.first),
        date: TextEditingController(),
        pos_bank: TextEditingController(
          text: bankList.isNotEmpty ? bankList.first : '',
        ),
        upi_utr_cn: TextEditingController(),
      ),
    );
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
    } else {
      // Get.snackbar(
      //   'Cannot Remove',
      //   'Cannot remove the last row.',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      showErrorToast(message: "Cannot remove the last row.");
    }
  }

  void validateAndAddRow() {
    if (formKey.currentState!.validate()) {
      addRow();
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

  void setSelectedMethod(String? value, int rowIndex) {
    if (value != null) {
      controllers[rowIndex].method.text = value;
    }
  }

  void setSelectedBank(String? value, int rowIndex) {
    if (value != null) {
      controllers[rowIndex].pos_bank.text = value;
      // Find the corresponding account ID
      // final bankAccount = accountsResponse.value.data?.bankAccounts?.firstWhere(
      //     (account) => account.number == value,
      //     orElse: () => BankAccount());
      // Store the account ID if needed
      // controllers[rowIndex].bankId = bankAccount?.id;
    }
  }

  Future<void> selectDate(BuildContext context, int rowIndex) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      log("Setting date $picked");
      controllers[rowIndex].date.text = DateFormat('dd/MM/yyyy').format(picked);
      controllers.refresh();
    }
  }

  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;
  void movePreviousFocus(FocusNode removeButtonFocusNode) {
    if (currentColIndex.value > 0) {
      currentColIndex.value--;

      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex.value > 0) {
      currentRowIndex.value--;
      currentColIndex.value =
          controllers[currentRowIndex.value].tableFocusNodes.length - 1;

      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      // We're at the first field of the first row
      removeButtonFocusNode.requestFocus();
    }

    log(
      "moving focus movePreviousFocus to $currentRowIndex : $currentColIndex",
    );
  }

  void moveNextFocus() {
    log(
      "The values are ${controllers[currentRowIndex.value].tableFocusNodes.length} $currentColIndex",
    );
    if (currentColIndex <
        controllers[currentRowIndex.value].tableFocusNodes.length - 1) {
      currentColIndex.value++;

      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else if (currentRowIndex < controllers.length - 1) {
      currentRowIndex.value++;
      currentColIndex.value = 0;

      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      validateAndAddRow();
    }
    log("moving focus moveNextFocusto $currentRowIndex : $currentColIndex");
  }

  KeyEventResult moveFocus(
    KeyEventResult result,
    LogicalKeyboardKey keyboard, {
    required FocusNode previousFocusNode,
    required FocusNode nextFocusNode,
  }) {
    if (keyboard == LogicalKeyboardKey.arrowUp) {
      if (currentRowIndex > 0) {
        currentRowIndex.value--;
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
      } else {
        log("inside else");
        previousFocusNode.requestFocus();
        // node.previousFocus();
        log("moving focus move focus to $currentRowIndex : $currentColIndex");
        return KeyEventResult.handled;
      }
    } else if (keyboard == LogicalKeyboardKey.arrowDown) {
      if (currentRowIndex.value < controllers.length - 1) {
        currentRowIndex.value++;
      } else {
        nextFocusNode.requestFocus();
        // node.nextFocus();
        return KeyEventResult.handled;
      }
    }
    controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
        .requestFocus();
    log("moving focus move focus to $currentRowIndex : $currentColIndex");
    return result;
  }

  void removeCurrentRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      // updateTotals();
      if (index == 0) {
        currentRowIndex.value = 0;
      } else {
        currentRowIndex.value = currentRowIndex.value - 1;
      }
      controllers[currentRowIndex.value].tableFocusNodes[currentColIndex.value]
          .requestFocus();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
    controllers.refresh();
  }

  Future<void> getAccountsData() async {
    try {
      accountsResponse.value = ApiResponse.loading("Loading accounts");
      final response = await _repository.getAccounts();
      accountsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      accountsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Error fetching accounts");
      log("Error fetching accounts: $e");
    }
  }

  final jewelleryPlanResponse = Rx<ApiResponse<GetJewelleryPlanResponseModel>>(
    ApiResponse.initial("INITIAL"),
  );
  AddInstallmentViewModel addInstallmentViewModel = Get.find();
  // Future<bool> validateAndAddInstallment() async {

  Future<bool> validateAndCreateSubscription() async {
    try {
      if (!formKey.currentState!.validate()) return false;

      final viewModel = Get.find<AddInstallmentViewModel>();
      log("InstallmentDate: ${viewModel.installmentDateController.text}");
      log("PlanId: ${viewModel.planIdController.text}");
      log("RateGms: ${viewModel.rateGmsController.text}");

      // Validate payment rows
      double total = 0;
      for (var element in controllers) {
        if (element.amount.text.isEmpty ||
            element.date.text.isEmpty ||
            element.method.text.isEmpty ||
            element.pos_bank.text.isEmpty) {
          showErrorToast(message: 'Please fill all payment details');
          return false;
        }
        total += double.tryParse(element.amount.text) ?? 0;
      }

      double targetAmount =
          double.tryParse(installmentAmountController.text) ?? 0;
      log("Target Amount: $targetAmount, Total: $total");

      if (total != targetAmount) {
        showErrorToast(
          message: "Total payment amount must match installment amount",
          alignment: Alignment.center,
        );
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      if (viewModel.installmentDateController.text.isEmpty) {
        showErrorToast(message: "Please select installment date");
        return false;
      }

      if (viewModel.planIdController.text.isEmpty) {
        showErrorToast(message: "Plan ID is required");
        return false;
      }

      final planData = jewelleryPlanResponse.value.data?.results?.firstOrNull;
      log("Plan Data: ${planData?.toJson()}");

      if (planData == null) {
        showErrorToast(message: "Plan details not found");
        return false;
      }

      // Create payment options safely
      final paymentOptions =
          controllers.map((payment) {
            DateTime? parsedDate;
            try {
              parsedDate = DateFormat('dd/MM/yyyy').parse(payment.date.text);
              log("Parsed date successfully: ${payment.date.text}");
            } catch (e) {
              log("Date parsing error: $e for date: ${payment.date.text}");
              throw Exception("Invalid date format in payment details");
            }

            return Option(
              amount: payment.amount.text,
              date: parsedDate,
              bank: payment.pos_bank.text,
              paymentInfo: payment.upi_utr_cn.text,
            );
          }).toList();

      // Create installment data safely
      DateTime? installmentDate;
      try {
        installmentDate = DateFormat(
          'dd-MM-yyyy',
        ).parse(viewModel.installmentDateController.text);
        log(
          "Parsed installment date successfully: ${viewModel.installmentDateController.text}",
        );
      } catch (e) {
        log("Installment date parsing error: $e");
        showErrorToast(message: "Invalid installment date format");
        return false;
      }

      final request = AddInstallmentRequest(
        installmentData: InstallmentData(
          planId: viewModel.planIdController.text,
          date: installmentDate,
          amount: targetAmount.toString(),
          customerName: planData.customerName,
          phone: planData.phone,
          rate: int.tryParse(viewModel.rateGmsController.text),
          planType: planData.planType,
        ),
        paymentOption: [
          PaymentOption(type: "PAYMENT", options: paymentOptions, mode: 1),
        ],
        subscriptionId: planData.id,
      );

      log("Request payload: ${request.toJson()}");

      await _repository.addInstallment(request);
      showSuccessToast(message: 'Installment added successfully');
      clearAllControllers();
      Get.back();
      return true;
    } catch (e, stackTrace) {
      log("Failed to add installment: $e");
      log("Stack trace: $stackTrace");
      errorMessage.value = e.toString();
      showErrorToast(message: "Failed to add installment: ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearAllControllers() {
    final PartyDetailsController partyDetailsController =
        Get.find<PartyDetailsController>();
    partyDetailsController.selectedParty.value = null;
    partyDetailsController.searchController.value.text = "";
  }
}
