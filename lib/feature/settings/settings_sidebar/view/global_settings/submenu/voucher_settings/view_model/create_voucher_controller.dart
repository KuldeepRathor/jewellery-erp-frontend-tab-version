import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/create_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_ornament_dropdown_voucher_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_sections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/view_model/voucher_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

//Row model
class VoucherRow {
  // controllers
  final prefixController = TextEditingController();
  final startFromController = TextEditingController();
  final suffixController = TextEditingController();

  // focusNodes
  final prefixFocus = FocusNode();
  final startFromFocus = FocusNode();
  final suffixFocus = FocusNode();
  final restartFocus = FocusNode();
  final defaultFocus = FocusNode();
  final enableFocus = FocusNode();

  // switch states
  final restart = false.obs;
  final isDefault = false.obs;
  final isEnabled = true.obs;
}

class CreateVoucherController extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();

  final rows = <VoucherRow>[].obs;

  void addNewRow() {
    final row = VoucherRow();

    row.startFromController.text = "1";

    rows.add(row);

    // focus prefix of new row after UI builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      row.prefixFocus.requestFocus();
    });
  }

  final headers =
      [
        'Prefix',
        'Start From',
        'Suffix',
        'Restart every FY',
        'Default',
        'Enable/Disable',
        '',
      ].obs;

  final columnWidths =
      [
        0.4, // Prefix
        0.4, // Start From
        0.4, // Suffix
        0.4, // Restart every FY
        0.4, // Default
        0.4, // Enable/Disable
        0.1,
      ].obs;

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      rows.length, // number of rows
      (index) => buildTableRow(context, index),
    );
  }

  TableRow buildTableRow(BuildContext context, int index) {
    final row = rows[index];
    return TableRow(
      children: [
        _middle(
          _textField(
            "1",
            controller: row.prefixController,
            focusNode: row.prefixFocus,
            nextFocus: row.startFromFocus,
          ),
        ),
        _middle(
          _textField(
            "001",
            controller: row.startFromController,
            focusNode: row.startFromFocus,
            nextFocus: row.suffixFocus,
          ),
        ),
        _middle(
          _textField(
            "24-25",
            controller: row.suffixController,
            focusNode: row.suffixFocus,
            nextFocus: row.restartFocus,
          ),
        ),
        _middle(
          _switch(
            row.restart,
            focusNode: row.restartFocus,
            nextFocus: row.defaultFocus,
          ),
        ),
        _middle(
          _switch(
            row.isDefault,
            activeColor: Colors.red,
            focusNode: row.defaultFocus,
            nextFocus: row.enableFocus,
            onToggle: (val) {
              if (val) {
                setDefaultRow(index);
              } else {
                row.isDefault.value = false;
              }
            },
          ),
        ),
        _middle(
          _switch(
            row.isEnabled,
            focusNode: row.enableFocus,
            onEnter: () {
              addNewRow();
            },
            onToggle: (val) {
              if (!val && row.isDefault.value) {
                showErrorToast(message: "Cannot disable the default sequence.");
                return;
              }
              row.isEnabled.value = val;
            },
          ),
        ),
        _middle(_deleteIcon(index)),
      ],
    );
  }

  Widget _middle(Widget child) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: child,
      ),
    );
  }

  Widget _textField(
    String value, {
    required TextEditingController controller,
    FocusNode? focusNode,
    FocusNode? nextFocus,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CustomTextField(
        focusNode: focusNode,
        controller: controller,
        onEditingComplete: () {
          if (nextFocus != null && nextFocus.canRequestFocus) {
            nextFocus.requestFocus();
          } else {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
      ),
    );
  }

  Widget _switch(
    RxBool value, {
    VoidCallback? onEnter,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    Color? activeColor,
    void Function(bool)? onToggle,
  }) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            final newVal = !value.value;
            if (onToggle != null) {
              onToggle(newVal);
            } else {
              value.toggle();
            }
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            if (onEnter != null) {
              onEnter();
            } else if (nextFocus != null) {
              nextFocus.requestFocus();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Center(
        child: Obx(
          () => CustomToggleSwitch(
            onChanged: (val) {
              if (onToggle != null) {
                onToggle(val);
              } else {
                value.value = val;
              }
            },
            value: value.value,
          ),
        ),
      ),
    );
  }

  Widget _deleteIcon(int index) {
    return InkWell(
      onTap: () {
        final row = rows[index];

        row.prefixController.dispose();
        row.startFromController.dispose();
        row.suffixController.dispose();

        row.prefixFocus.dispose();
        row.startFromFocus.dispose();
        row.suffixFocus.dispose();
        row.restartFocus.dispose();
        row.defaultFocus.dispose();
        row.enableFocus.dispose();

        rows.removeAt(index);
      },
      child: const Center(child: Icon(Icons.delete_outline, color: Colors.red)),
    );
  }

  // Form controllers
  final voucherNameController = TextEditingController();
  final voucherTypeController = TextEditingController();
  final voucherSectionController = TextEditingController();
  final ornamentTypeController = TextEditingController();
  final prefixController = TextEditingController();
  final startingFromController = TextEditingController();
  final suffixController = TextEditingController();

  // Focus nodes
  final voucherNameFocusNode = FocusNode();
  final voucherTypeFocusNode = FocusNode();
  final voucherSectionFocusNode = FocusNode();
  final ornamentTypeFocusNode = FocusNode();
  final prefixFocusNode = FocusNode();
  final startingFromFocusNode = FocusNode();
  final suffixFocusNode = FocusNode();

  // Create voucher state
  final isCreatingVoucher = false.obs;
  final createVoucherResponse = Rx<ApiResponse<dynamic>>(
    ApiResponse.initial("INITIAL"),
  );

  final isSuffixFieldEnabled = true.obs;

  // Voucher example state
  final isLoadingVoucherExample = false.obs;
  final voucherExampleResponse = Rx<ApiResponse<String>>(
    ApiResponse.initial("INITIAL"),
  );
  final voucherExampleText = "Demo Display".obs;

  // API response states
  final voucherTypesResponse = Rx<ApiResponse<List<GetVoucherTypeResponse>>>(
    ApiResponse.initial("INITIAL"),
  );
  final voucherSectionsResponse =
      Rx<ApiResponse<List<GetVoucherSectionResponse>>>(
        ApiResponse.initial("INITIAL"),
      );
  final ornamentTypesResponse =
      Rx<ApiResponse<List<GetOrnamentTypeDropdownVoucherResponse>>>(
        ApiResponse.initial("INITIAL"),
      );

  // Dropdown data
  final voucherTypes = <GetVoucherTypeResponse>[].obs;
  final voucherSections = <GetVoucherSectionResponse>[].obs;
  final ornamentTypes = <GetOrnamentTypeDropdownVoucherResponse>[].obs;

  // Selected values
  final selectedVoucherType = Rx<GetVoucherTypeResponse?>(null);
  final selectedVoucherSection = Rx<GetVoucherSectionResponse?>(null);
  final selectedOrnamentTypes = <GetOrnamentTypeDropdownVoucherResponse>[].obs;

  final restartFromNewFinancialYear = false.obs;
  final selectedFinancialYear = Rx<String?>(null);
  final financialYears = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    addNewRow();
    log("Create Voucher Controller initiated");

    // Load dropdown data
    _loadDropdownData();

    // Focus on first field when controller is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (voucherNameFocusNode.canRequestFocus) {
        voucherTypeFocusNode.requestFocus();
      }
    });
  }

  void toggleRestartFromNewFinancialYear(bool value) {
    restartFromNewFinancialYear.value = value;
    if (!value) {
      selectedFinancialYear.value = null;
      // Re-enable the suffix field when checkbox is unchecked
      isSuffixFieldEnabled.value = true;
    } else {
      // Clear and disable the suffix text field when checkbox is selected
      suffixController.clear();
      isSuffixFieldEnabled.value = false;

      // Set default financial year when checkbox is enabled
      final currentYear = DateTime.now().year;
      selectedFinancialYear.value =
          '$currentYear-${(currentYear + 1).toString().substring(2)}';
    }
  }

  @override
  void onClose() {
    log("Create Voucher Controller Deleted");

    // Dispose text controllers
    voucherNameController.dispose();
    voucherTypeController.dispose();
    voucherSectionController.dispose();
    ornamentTypeController.dispose();
    prefixController.dispose();
    startingFromController.dispose();
    suffixController.dispose();

    // Dispose focus nodes
    voucherNameFocusNode.dispose();
    voucherTypeFocusNode.dispose();
    voucherSectionFocusNode.dispose();
    ornamentTypeFocusNode.dispose();
    prefixFocusNode.dispose();
    startingFromFocusNode.dispose();
    suffixFocusNode.dispose();

    super.onClose();
  }

  // Load all dropdown data
  Future<void> _loadDropdownData() async {
    await Future.wait([
      _loadVoucherTypes(),
      _loadVoucherSections(),
      _loadOrnamentTypes(),
    ]);
  }

  // Load voucher types
  Future<void> _loadVoucherTypes() async {
    try {
      voucherTypesResponse.value = ApiResponse.loading(
        "Loading voucher types...",
      );

      final response = await _aggregateRepository.getVoucherTypes();

      if (response.status == Status.COMPLETED) {
        voucherTypes.assignAll(response.data ?? []);
        voucherTypesResponse.value = ApiResponse.completed(response.data ?? []);
      } else {
        voucherTypesResponse.value = ApiResponse.error(
          response.message ?? 'Failed to load voucher types',
        );
      }
    } catch (e) {
      log('Error loading voucher types: $e');
      voucherTypesResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Load voucher sections
  Future<void> _loadVoucherSections() async {
    try {
      voucherSectionsResponse.value = ApiResponse.loading(
        "Loading voucher sections...",
      );

      final response = await _aggregateRepository.getVoucherSections();

      if (response.status == Status.COMPLETED) {
        voucherSections.assignAll(response.data ?? []);
        voucherSectionsResponse.value = ApiResponse.completed(
          response.data ?? [],
        );
      } else {
        voucherSectionsResponse.value = ApiResponse.error(
          response.message ?? 'Failed to load voucher sections',
        );
      }
    } catch (e) {
      log('Error loading voucher sections: $e');
      voucherSectionsResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Load ornament types
  Future<void> _loadOrnamentTypes() async {
    try {
      ornamentTypesResponse.value = ApiResponse.loading(
        "Loading ornament types...",
      );

      final response =
          await _aggregateRepository.getOrnamentTypeDropdownVoucher();

      if (response.status == Status.COMPLETED) {
        ornamentTypes.assignAll(response.data ?? []);
        ornamentTypesResponse.value = ApiResponse.completed(
          response.data ?? [],
        );
      } else {
        ornamentTypesResponse.value = ApiResponse.error(
          response.message ?? 'Failed to load ornament types',
        );
      }
    } catch (e) {
      log('Error loading ornament types: $e');
      ornamentTypesResponse.value = ApiResponse.error(e.toString());
    }
  }

  // Selection methods
  void setSelectedVoucherType(GetVoucherTypeResponse voucherType) {
    selectedVoucherType.value = voucherType;
    voucherTypeController.text = voucherType.name ?? '';
  }

  void setSelectedVoucherSection(GetVoucherSectionResponse voucherSection) {
    selectedVoucherSection.value = voucherSection;
    voucherSectionController.text = voucherSection.name ?? '';
  }

  void setSelectedOrnamentTypes(
    List<GetOrnamentTypeDropdownVoucherResponse> ornamentTypes,
  ) {
    selectedOrnamentTypes.assignAll(ornamentTypes);
    // Update the controller text to show selected items
    ornamentTypeController.text = ornamentTypes
        .map((type) => type.typeName ?? '')
        .join(', ');
  }

  void resetForm() {
    // Clear controllers
    voucherNameController.clear();
    voucherTypeController.clear();
    voucherSectionController.clear();
    ornamentTypeController.clear();
    prefixController.clear();
    startingFromController.clear();
    suffixController.clear();

    // Clear selections
    selectedVoucherType.value = null;
    selectedVoucherSection.value = null;
    selectedOrnamentTypes.clear(); // Updated this line
    restartFromNewFinancialYear.value = false;
    selectedFinancialYear.value = null;

    // Reset suffix field state
    isSuffixFieldEnabled.value = true;

    // Reset API states
    isCreatingVoucher.value = false;
    createVoucherResponse.value = ApiResponse.initial("INITIAL");

    // Reset voucher example state
    isLoadingVoucherExample.value = false;
    voucherExampleResponse.value = ApiResponse.initial("INITIAL");
    voucherExampleText.value = "Demo Display";
  }

  // Validation methods
  String? validateVoucherType(String? value) {
    if (selectedVoucherType.value == null || (value?.trim().isEmpty ?? true)) {
      return 'Voucher Type is required';
    }
    return null;
  }

  String? validateVoucherSection(String? value) {
    if (selectedVoucherSection.value == null ||
        (value?.trim().isEmpty ?? true)) {
      return 'Voucher Section is required';
    }
    return null;
  }

  String? validateOrnamentType(
    List<GetOrnamentTypeDropdownVoucherResponse>? values,
  ) {
    if (values == null || values.isEmpty) {
      return 'Metal/Service Type is required';
    }
    return null;
  }

  String? validateVoucherName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Voucher Name is required';
    }
    return null;
  }

  String? validatePrefix(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Prefix is required';
    }
    return null;
  }

  String? validateStartingFrom(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Starting Number is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateSuffix(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Suffix is required';
    }
    return null;
  }

  Future<void> createVoucher() async {
    try {
      if (selectedVoucherType.value == null) {
        showErrorToast(message: 'Please select voucher type');
        return;
      }

      if (selectedVoucherSection.value == null) {
        showErrorToast(message: 'Please select voucher section');
        return;
      }

      if (rows.isEmpty) {
        showErrorToast(message: 'Please add at least one row');
        return;
      }
      isCreatingVoucher.value = true;
      createVoucherResponse.value = ApiResponse.loading("Creating voucher...");

      final createSequenceRequest = CreateSequenceRequest(
        voucherSeriesType: int.tryParse(selectedVoucherType.value?.id ?? ''),
        voucherSeriesCommodity: int.tryParse(
          selectedVoucherSection.value?.id ?? '',
        ),
        sequenceLines:
            rows.map((row) {
              return SequenceLine(
                prefix: row.prefixController.text.trim(),
                suffix:
                    row.suffixController.text.trim().isEmpty
                        ? null
                        : row.suffixController.text.trim(),
                startFrom: row.startFromController.text.trim(),
                restartFromNewFinancialYear: row.restart.value,
                isDefault: row.isDefault.value,
                isEnabled: row.isEnabled.value,
              );
            }).toList(),
      );

      final response = await _aggregateRepository.createSequence(
        createSequenceRequest: createSequenceRequest,
      );

      if (response.status == Status.COMPLETED) {
        showSuccessToast(message: 'Voucher updated successfully');
        _goBack();
      }
    } catch (e) {
      log('Error creating voucher: $e');
      createVoucherResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to create voucher: ${e.toString()}');
    } finally {
      isCreatingVoucher.value = false;
    }
  }

  void _goBack() {
    final sidebarController = Get.find<SettingsSidebarController>(
      tag: 'globalSettings',
    );
    sidebarController.popBackToVoucherSettings();

    if (Get.isRegistered<VoucherSettingsController>()) {
      final voucherController = Get.find<VoucherSettingsController>();
      voucherController.getVoucherSequencesList();
    }
  }

  void goBack() {
    resetForm();
    _goBack();
  }

  void setDefaultRow(int index) {
    for (int i = 0; i < rows.length; i++) {
      rows[i].isDefault.value = (i == index);
    }
  }

  void removeLastRow() {
    if (rows.length > 1) {
      final row = rows.last;
      row.prefixController.dispose();
      row.startFromController.dispose();
      row.suffixController.dispose();
      row.prefixFocus.dispose();
      row.startFromFocus.dispose();
      row.suffixFocus.dispose();
      row.restartFocus.dispose();
      row.defaultFocus.dispose();
      row.enableFocus.dispose();
      rows.removeLast();
    } else {
      showErrorToast(message: "Cannot remove the last row.");
    }
  }
}
