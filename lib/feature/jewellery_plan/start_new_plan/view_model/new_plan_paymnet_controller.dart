import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/get_accounts_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/create_subscription_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view/new_plan_paymnet_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/view_model/start_new_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class NewPlanPaymentDetailsController extends GetxController {
  final JewelleryPlanRepository _repository = JewelleryPlanRepository();
  // final PurchaseInvoiceRepository _purchaseInvoiceRepository = PurchaseInvoiceRepository();

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
  final controllers = <NewPlanPaymentDetailsTableData>[].obs;
  final methodList = ["Cheque", "Debit Card", "Cash", "RTGS/NEFT", "UPI"];
  final Map<String, String> methodToMode = {
    "UPI": "0",
    "Debit Card": "1",
    "RTGS/NEFT": "3",
    "Cheque": "6",
    "Cash": "7",
  };

  final installmentAmount = '0'.obs;
  StartNewPlanController startNewPlanController = Get.put(
    StartNewPlanController(),
  );

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final accountsResponse = Rx<ApiResponse<GetAccountsResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  @override
  void onInit() {
    super.onInit();
    getAccountsData();
  }

  List<String> get bankList => combinedBankList;

  List<String> get combinedBankList {
    final banks = accountsResponse.value.data?.bankAccounts ?? [];
    final pos = accountsResponse.value.data?.posAccounts ?? [];
    return [
      ...banks.map((account) => account.number ?? ""),
      ...pos.map((account) => account.number ?? ""),
    ];
  }

  int? getBankOrPosId(String accountNumber) {
    final bankAccounts = accountsResponse.value.data?.bankAccounts ?? [];
    final posAccounts = accountsResponse.value.data?.posAccounts ?? [];

    // First check bank accounts
    final bankAccount = bankAccounts.firstWhere(
      (bank) => bank.number == accountNumber,
      orElse: () => BankAccount(),
    );
    if (bankAccount.id != null) return bankAccount.id;

    // Then check POS accounts
    final posAccount = posAccounts.firstWhere(
      (pos) => pos.number == accountNumber,
      orElse: () => PosAccount(),
    );
    return posAccount.id;
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

  void initializeRow() {
    controllers.clear();
    addRow();
  }

  void clearTextController() {}

  void addRow() {
    controllers.add(
      NewPlanPaymentDetailsTableData(
        amount: TextEditingController(),
        method: TextEditingController(text: methodList.first),
        date: TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ),
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
      // Find and set the corresponding bank ID
      final bankId = getBankOrPosId(value);
      controllers[rowIndex].bankId = bankId;
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

  Future<bool> validateAndCreateSubscription() async {
    final PartyDetailsController partyDetailsController =
        Get.find<PartyDetailsController>();
    StartNewPlanController startNewPlanController =
        Get.find<StartNewPlanController>();

    if (!formKey.currentState!.validate()) return false;

    double total = 0;
    for (var element in controllers) {
      total += double.tryParse(element.amount.text) ?? 0;
    }

    String? phoneNumber;
    if (partyDetailsController.selectedParty.value is CustomerSearchValue) {
      phoneNumber =
          (partyDetailsController.selectedParty.value as CustomerSearchValue)
              .phoneNumber;
    }

    if (phoneNumber == null || phoneNumber.isEmpty) {
      showErrorToast(message: "Selected party must have a valid phone number");
      return false;
    }

    double targetAmount =
        double.tryParse(startNewPlanController.sipAmountController.text) ?? 0;
    if (total != targetAmount) {
      showErrorToast(
        message: "Total payment amount must match installment amount",
        alignment: Alignment.center,
      );
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final request = CreateSubscriptionRequest(
        phone: phoneNumber,
        planid: startNewPlanController.selectedPlanId.value ?? 0,
        amount: targetAmount.toInt(),
        paymentOption: [
          PaymentOption(
            type: controllers.first.method.text,
            mode: int.parse(methodToMode[controllers.first.method.text] ?? ""),
            options:
                controllers.map((controller) {
                  final selectedBank = accountsResponse.value.data?.bankAccounts
                      ?.firstWhere(
                        (bank) => bank.number == controller.pos_bank.text,
                        orElse: () => BankAccount(),
                      );

                  return Option(
                    amount: int.tryParse(controller.amount.text) ?? 0,
                    date: DateFormat('dd/MM/yyyy').parse(controller.date.text),
                    bank: selectedBank?.id?.toString(),
                    paymentInfo: controller.upi_utr_cn.text,
                  );
                }).toList(),
          ),
        ],
      );

      await _repository.createSubscription(request);
      showSuccessToast(message: 'Subscription created successfully!');
      clearAllControllers();
      Get.back();
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      showErrorToast(message: "Failed to create subscription: ${e.toString()}");
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
