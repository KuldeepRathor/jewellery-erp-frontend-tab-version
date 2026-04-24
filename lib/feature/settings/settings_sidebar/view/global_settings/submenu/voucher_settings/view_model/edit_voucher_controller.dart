import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/delete_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/edit_sequence_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_ornament_dropdown_voucher_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_sequence_listing_grouped_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_sequences_listing_grouped_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_sections_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/get_voucher_types_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/model/update_sequence_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view/global_settings/submenu/voucher_settings/view_model/voucher_settings_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/settings_sidebar/view_model/settings/settings_sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toggle_switch_widget.dart';

//Row model
class VoucherRow {
  String? sequenceId;
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

class EditVoucherController extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();

  // Store raw IDs for update API
  final _editingVoucherSeriesType = Rx<String?>(null);
  final _editingVoucherSeriesCommodity = Rx<String?>(null);

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

  void setDefaultRow(int index) {
    for (int i = 0; i < rows.length; i++) {
      rows[i].isDefault.value = (i == index);
    }
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
    void Function(bool)? onToggle, // ← add this
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
      onTap: () => _handleDeleteRow(index),
      child: const Center(child: Icon(Icons.delete_outline, color: Colors.red)),
    );
  }

  Future<void> _handleDeleteRow(int index) async {
    final row = rows[index];

    // If no sequenceId, this is a locally-added (unsaved) row — just remove it
    if (row.sequenceId == null) {
      _disposeAndRemoveRow(index);
      return;
    }

    final voucherSeriesType = int.tryParse(
      _editingVoucherSeriesType.value ?? '',
    );
    if (voucherSeriesType == null) {
      showErrorToast(message: 'Invalid voucher series type');
      return;
    }

    try {
      final request = DeleteSequenceRequest(
        sequenceId: row.sequenceId,
        voucherSeriesType: voucherSeriesType,
      );

      final response = await _aggregateRepository.deleteSequence(
        deleteSequenceRequest: request,
      );

      if (response.status == Status.COMPLETED) {
        _disposeAndRemoveRow(index);
        showSuccessToast(message: 'Row deleted successfully');
      } else {
        // Parse the {"detail": "..."} error format
        final detail = _extractDetail(response.message);
        showErrorToast(message: detail);
      }
    } catch (e) {
      showErrorToast(message: 'Failed to delete row');
    }
  }

  void _disposeAndRemoveRow(int index) {
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
  }

  String _extractDetail(String? raw) {
    return raw ?? 'Failed to delete row';
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

  // Edit voucher state
  final isUpdatingVoucher = false.obs;

  final editSequenceResponse = Rx<ApiResponse<List<EditSequenceResponse>>>(
    ApiResponse.initial("INITIAL"),
  );

  final editingSequenceId = Rx<String?>(null);

  final isSuffixFieldEnabled = true.obs;

  // Get Sequence By Id
  final getSequenceByIdResponse = Rx<ApiResponse<List<EditSequenceResponse>>>(
    ApiResponse.initial("Initial"),
  );

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
    log("Edit Voucher Controller initiated");

    // ✅ ensure at least one row exists (like your working code)
    if (rows.isEmpty) {
      rows.add(VoucherRow());
    }
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

  Future<void> loadSequenceForEdit({
    required String voucherSeriesType,
    required String voucherSeriesCommodity,
    required String typeName,
    required String commodityName,
  }) async {
    try {
      _editingVoucherSeriesType.value = voucherSeriesType;
      _editingVoucherSeriesCommodity.value = voucherSeriesCommodity;

      editSequenceResponse.value = ApiResponse.loading("Loading sequence...");

      // Load dropdowns in parallel with sequence fetch
      await _loadDropdownData();

      final request = GetSequencesListingGroupedRequest(
        voucherSeriesType: voucherSeriesType,
        voucherSeriesCommodity: voucherSeriesCommodity,
      );

      final rawResponse = await _aggregateRepository.getSequencesListingGrouped(
        request: request,
      );

      // rawResponse is List<GetSequencesListingGroupedResponse>
      // We expect exactly 1 group back since we filtered by type+commodity
      if (rawResponse.isEmpty) {
        editSequenceResponse.value = ApiResponse.error("No data found");
        return;
      }

      final group = rawResponse.first;

      // Prefill dropdowns using the names passed in (IDs may not match dropdown list)
      _prefillDropdowns(
        voucherSeriesType: voucherSeriesType,
        voucherSeriesCommodity: voucherSeriesCommodity,
        typeName: typeName,
        commodityName: commodityName,
      );

      // Prefill rows from sequenceLineItems
      _prefillRowsFromGrouped(group);

      editSequenceResponse.value = ApiResponse.completed([]);
    } catch (e) {
      log("loadSequenceForEdit error: $e");
      editSequenceResponse.value = ApiResponse.error(e.toString());
    }
  }

  void _prefillDropdowns({
    required String voucherSeriesType,
    required String voucherSeriesCommodity,
    required String typeName,
    required String commodityName,
  }) {
    // Match by ID in loaded dropdown lists
    final vt = voucherTypes.firstWhereOrNull(
      (e) => e.id?.toString() == voucherSeriesType,
    );
    if (vt != null) {
      selectedVoucherType.value = vt;
      voucherTypeController.text = vt.name ?? '';
    } else {
      // Fallback: just show the name even if not in list
      voucherTypeController.text = typeName;
    }

    final vs = voucherSections.firstWhereOrNull(
      (e) => e.id?.toString() == voucherSeriesCommodity,
    );
    if (vs != null) {
      selectedVoucherSection.value = vs;
      voucherSectionController.text = vs.name ?? '';
    } else {
      voucherSectionController.text = commodityName;
    }
  }

  void _prefillRowsFromGrouped(GetSequencesListingGroupedResponse group) {
    // Dispose old rows
    for (final row in rows) {
      row.prefixController.dispose();
      row.startFromController.dispose();
      row.suffixController.dispose();
      row.prefixFocus.dispose();
      row.startFromFocus.dispose();
      row.suffixFocus.dispose();
      row.restartFocus.dispose();
      row.defaultFocus.dispose();
      row.enableFocus.dispose();
    }
    rows.clear();

    for (final item in group.sequenceLineItems ?? []) {
      final row = VoucherRow();
      row.sequenceId = item.id;
      row.prefixController.text = item.prefix ?? '';
      row.suffixController.text = item.suffix ?? '';
      row.startFromController.text = item.startFrom ?? '';
      row.restart.value = item.restartEveryYr ?? false;
      row.isDefault.value = item.isDefault ?? false;
      row.isEnabled.value = true;
      rows.add(row);
    }

    rows.refresh();
    log(" ${rows.length} rows from grouped response");
  }

  Future<void> updateVoucher() async {
    try {
      isUpdatingVoucher.value = true;

      final request = UpdateSequenceRequest(
        voucherSeriesType: _editingVoucherSeriesType.value,
        voucherSeriesCommodity: _editingVoucherSeriesCommodity.value,
        sequenceLines:
            rows
                .map(
                  (row) => SequenceLine(
                    sequenceId: row.sequenceId,
                    prefix: row.prefixController.text.trim(),
                    suffix: row.suffixController.text.trim(),
                    startFrom: row.startFromController.text.trim(),
                    restartFromNewFinancialYear: row.restart.value,
                    isDefault: row.isDefault.value,
                    isEnabled: row.isEnabled.value,
                  ),
                )
                .toList(),
      );

      final response = await _aggregateRepository.updateSequence(
        updateSequenceRequest: request,
      );

      if (response.status == Status.COMPLETED) {
        showSuccessToast(message: 'Voucher updated successfully');
        _goBack();
      } else {
        showErrorToast(message: response.message ?? 'Failed to update voucher');
      }
    } catch (e) {
      showErrorToast(message: 'Failed to update voucher');
    } finally {
      isUpdatingVoucher.value = false;
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
    _goBack();
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
