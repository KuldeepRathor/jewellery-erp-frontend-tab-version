import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/journal_entry/models/get_account_mapping_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class AccountTableData {
  String? id;
  TextEditingController acCode;
  TextEditingController accountName;
  TextEditingController remarks;
  TextEditingController debit;
  TextEditingController credit;
  List<FocusNode> tableFocusNodes = List.generate(5, (index) => FocusNode());

  AccountTableData({
    this.id,
    required this.acCode,
    required this.accountName,
    required this.remarks,
    required this.debit,
    required this.credit,
  });

  Map<String, dynamic> toJsonValue() {
    return {
      "id": id,
      "acCode": acCode.text,
      "accountName": accountName.text,
      "remarks": remarks.text,
      "debit": debit.text,
      "credit": credit.text,
    };
  }
}

class AccountTableController extends GetxController {
  final PurchaseRepository _purchaseRepository = PurchaseRepository();
  final accountHeaders = [
    'Sn',
    'A/C Code',
    'Account Name',
    'Remarks',
    'Debit',
    'Credit',
    'Action',
  ];

  final accountColumnWidths = [
    0.2, // Sn
    0.66, // A/C Code
    0.66, // Account Name
    0.66, // Remarks
    0.66, // Debit
    0.66, // Credit
    0.2, // Action
  ];

  final RxList<AccountTableData> controllers = <AccountTableData>[].obs;
  final ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<String> totalHeadersValue =
      <String>["Total", "", "", "", "0.00", "0.00", ""].obs;

  // Add this method to calculate totals
  void updateTotals() {
    double totalDebit = 0;
    double totalCredit = 0;

    for (var row in controllers) {
      totalDebit += double.tryParse(row.debit.text) ?? 0;
      totalCredit += double.tryParse(row.credit.text) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      "",
      "",
      "",
      totalDebit.toStringAsFixed(2),
      totalCredit.toStringAsFixed(2),
      "",
    ];
    totalHeadersValue.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    addRow();
    updateTotals();
  }

  void initializeController() {
    if (controllers.isEmpty) {
      addRow();
    }
  }

  void addRow() {
    controllers.add(
      AccountTableData(
        acCode: TextEditingController(),
        accountName: TextEditingController(),
        remarks: TextEditingController(),
        debit: TextEditingController(),
        credit: TextEditingController(),
      ),
    );
    controllers.refresh();
  }

  void removeRow(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      controllers.refresh();
    }
  }

  void removeLastRow() {
    if (controllers.length > 1) {
      controllers.removeLast();
      controllers.refresh();
    }
  }

  void moveNextFocus() {
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
  }

  void movePreviousFocus(FocusNode node) {
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

  // Handle table key events
  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event, int rowIndex) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          return KeyEventResult.ignored;
        } else {
          moveNextFocus();
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.tab &&
          HardwareKeyboard.instance.isShiftPressed) {
        movePreviousFocus(node);
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        moveNextFocus();
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape &&
          HardwareKeyboard.instance.isShiftPressed) {
        removeRow(rowIndex);
      }
    }
    return KeyEventResult.ignored;
  }

  // Validation functions
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid number';
    }
    return null;
  }

  void clearControllers() {
    controllers.clear();
    currentColIndex.value = 0;
    currentRowIndex.value = 0;
    totalHeadersValue.value = ["Total", "", "", "", "0.00", "0.00", ""];
    controllers.refresh();
  }

  final getAccountMappingsResponse = Rx<ApiResponse<GetAccountMappingResponse>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> fetchAccountMappings() async {
    try {
      getAccountMappingsResponse.value = ApiResponse.loading("Loading");
      final response = await _purchaseRepository.getAccountMappings();
      getAccountMappingsResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getAccountMappingsResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to load account mappings');
    }
  }

  // Set account name when code is selected
  void setAccountName(int index, String code) {
    final account = getAccountMappingsResponse.value.data?.values
        ?.firstWhereOrNull((element) => element.id.toString() == code);
    if (account != null) {
      controllers[index].accountName.text = account.groupName ?? "";
      controllers.refresh();
    }
  }

  // Set account code when name is selected
  void setAccountCode(int index, String name) {
    final account = getAccountMappingsResponse.value.data?.values
        ?.firstWhereOrNull((element) => element.groupName == name);
    if (account != null) {
      controllers[index].acCode.text = account.id.toString();
      controllers.refresh();
    }
  }

  // Get list of account codes for dropdown
  List<String> getAccountCodes() {
    return getAccountMappingsResponse.value.data?.values
            ?.map((account) => account.id.toString())
            .toList() ??
        [];
  }

  // Get list of account names for dropdown
  List<String> getAccountNames() {
    return getAccountMappingsResponse.value.data?.values
            ?.map((account) => account.groupName ?? "-")
            .toList() ??
        [];
  }

  // Modify validateRequiredFields to include credit/debit validation
  bool validateRequiredFields() {
    bool isValid = true;
    String errorMessage = '';

    final accountMappings = getAccountMappingsResponse.value.data?.values ?? [];
    double totalDebit = 0;
    double totalCredit = 0;

    for (int i = 0; i < controllers.length; i++) {
      final row = controllers[i];

      // Existing validations
      final codeExists = accountMappings.any(
        (account) => account.id.toString() == row.acCode.text.trim(),
      );
      if (!codeExists) {
        isValid = false;
        errorMessage += 'Row ${i + 1}: Invalid A/C Code\n';
      }

      final nameExists = accountMappings.any(
        (account) => account.groupName == row.accountName.text.trim(),
      );
      if (!nameExists) {
        isValid = false;
        errorMessage += 'Row ${i + 1}: Invalid Account Name\n';
      }

      final account = accountMappings.firstWhereOrNull(
        (account) =>
            account.id.toString() == row.acCode.text.trim() &&
            account.groupName == row.accountName.text.trim(),
      );
      if (account == null &&
          row.acCode.text.isNotEmpty &&
          row.accountName.text.isNotEmpty) {
        isValid = false;
        errorMessage +=
            'Row ${i + 1}: A/C Code and Account Name do not match\n';
      }

      // // Credit/Debit validations
      // final hasCredit = double.tryParse(row.credit.text) ?? 0 > 0;
      // final hasDebit = double.tryParse(row.debit.text) ?? 0 > 0;

      // if (!hasCredit && !hasDebit) {
      //   isValid = false;
      //   errorMessage += 'Row ${i + 1}: Enter either Credit or Debit amount\n';
      // }

      // if (hasCredit && hasDebit) {
      //   isValid = false;
      //   errorMessage += 'Row ${i + 1}: Cannot enter both Credit and Debit\n';
      // }

      totalDebit += double.tryParse(row.debit.text) ?? 0;
      totalCredit += double.tryParse(row.credit.text) ?? 0;
    }

    // Validate total credit equals total debit
    if (totalCredit != totalDebit) {
      isValid = false;
      errorMessage +=
          'Total Credit (${totalCredit.toStringAsFixed(2)}) must equal Total Debit (${totalDebit.toStringAsFixed(2)})\n';
    }

    if (!isValid) {
      showErrorToast(message: errorMessage);
    }

    return isValid;
  }

  // Add credit/debit field change handler
  void onCreditDebitChanged(int index) {
    final row = controllers[index];
    final creditValue = double.tryParse(row.credit.text) ?? 0;
    final debitValue = double.tryParse(row.debit.text) ?? 0;

    // If credit is entered, clear debit and vice versa

    if (creditValue > 0 && debitValue > 0) {
      if (row.credit.text.length > row.debit.text.length) {
        row.debit.text = "0";
      } else {
        row.credit.text = "0";
      }
    } else {}

    updateTotals();
    controllers.refresh();
  }
}
