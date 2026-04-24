import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/add_advance_booking/model/add_advance_booking_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/advance_booking/booking_listing/view_model/booking_listing_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/model/get_accounts_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/view_model/add_installment_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/model/get_jewellery_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/payment_details_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AddAdvancePaymentDetailsController extends GetxController {
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
  final Map<String, String> methodToCode = {
    "UPI": "0",
    "Debit Card": "1",
    "RTGS/NEFT": "3",
    "Cheque": "6",
    "Cash": "7",
  };
  // final bankList = ["SBI", "Paytm"];

  String installmentAmountController = "";

  final String bookingId;
  AddAdvancePaymentDetailsController({required this.bookingId});

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
    installmentAmountController = "0";
    getAccountsData();
    ever(jewelleryPlanResponse, (response) {
      if (response.data?.results?.isNotEmpty ?? false) {
        final planData = response.data?.results?.first;
        if (planData?.cost != null) {
          log("Setting amount: ${planData?.cost}");
          installmentAmountController = planData!.cost!.toString();
          update();
        }
      }
    });
  }

  @override
  void onClose() {
    // installmentAmountController.dispose();
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
  AddInstallmentViewModel addInstallmentViewModel = Get.put(
    AddInstallmentViewModel(),
  );

  Future<bool> validateAndCreateSubscription() async {
    try {
      if (!formKey.currentState!.validate()) return false;

      // Validate total payment amount
      // double total = 0;
      for (var element in controllers) {
        if (element.amount.text.isEmpty ||
            element.date.text.isEmpty ||
            element.method.text.isEmpty ||
            element.pos_bank.text.isEmpty) {
          showErrorToast(message: 'Please fill all payment details');
          return false;
        }
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Create payment options from the table data
      final paymentOptions =
          controllers.map((payment) {
            DateTime? parsedDate;
            try {
              parsedDate = DateFormat('dd/MM/yyyy').parse(payment.date.text);
            } catch (e) {
              log("Date parsing error: $e for date: ${payment.date.text}");
              throw Exception("Invalid date format in payment details");
            }

            // Find bank ID from the selected bank number
            final selectedBank = accountsResponse.value.data?.bankAccounts
                ?.firstWhere((bank) => bank.number == payment.pos_bank.text);

            String methodCode = methodToCode[payment.method.text] ?? "7";

            return PaymentOption(
              mode: methodCode,
              amount: payment.amount.text,
              date: parsedDate,
              bank: selectedBank?.id,
              paymentInfo: payment.upi_utr_cn.text,
            );
          }).toList();

      // Create the request
      final request = AddAdvanceBookingRequest(
        bookingId: int.parse(bookingId),
        paymentOptions: paymentOptions,
      );

      log("Request payload: ${request.toJson()}");

      // Make API call
      await _repository.addAdvanceBooking(request);

      // Refresh the booking listing
      final bookingListingController = Get.find<BookingListingViewModel>();
      await bookingListingController.getCustomerListingDetails(resetList: true);

      showSuccessToast(message: 'Advance payment added successfully');
      Get.back();
      return true;
    } catch (e) {
      log("Failed to add advance payment: $e");
      errorMessage.value = e.toString();
      showErrorToast(message: "Failed to add advance payment: ${e.toString()}");
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
