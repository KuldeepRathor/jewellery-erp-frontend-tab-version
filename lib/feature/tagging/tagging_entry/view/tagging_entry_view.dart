import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/gender_dailog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/metal_color_dailog.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view/tagging_item_details.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/lot_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/tagging_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/organization/employee/get_employees_response.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/intents.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/generic_autcomplete_dropdown_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_mult_select_dropdown_widget.dart';
import 'package:svg_flutter/svg.dart';

class TaggingNewEntryPage extends StatefulWidget {
  const TaggingNewEntryPage({super.key});

  @override
  State<TaggingNewEntryPage> createState() => _TaggingNewEntryPageState();
}

class _TaggingNewEntryPageState extends State<TaggingNewEntryPage> {
  final ScrollController _scrollController = ScrollController();
  final TaggingController _taggingController = Get.put(TaggingController());
  final TaggingItemDetailsController taggingItemDetailsController = Get.put(
    TaggingItemDetailsController(),
  );

  final LotController _lotController = Get.put(LotController());
  final GlobalSettingsViewModel _globalSettingsViewModel = Get.put(
    GlobalSettingsViewModel(),
  );
  bool showTwoButtons = false;
  bool showGenderButton = false;
  bool showMetalColorButton = false;

  @override
  void initState() {
    super.initState();
    _fetchGlobalSettingsAndInitialize();

    _taggingController.isFirstTime.value = true;
    _taggingController.isprintTag.value = true;
    _taggingController.isHuidRequired.value = false;
    _taggingController.isAutoWeightInput.value = true;

    _scrollController.addListener(_scrollListener);
    taggingItemDetailsController.addInitialRow();
    _taggingController.fetchAllRequiredApis();
    _taggingController.searchQcyEmployees("");
    _lotController.setInitialConditions(isSearch: false);
  }

  Future<void> _fetchGlobalSettingsAndInitialize() async {
    await _globalSettingsViewModel.getGlobalSettings();
    // This will trigger the lot dialog if needed
    _taggingController.checkLotBasedTaggingSetting();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _taggingController.resetFields();
    taggingItemDetailsController.clearControllers();
    Get.delete<LotController>();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SaveTaggingEntry(),
          LogicalKeySet(LogicalKeyboardKey.f2): const ChangeVendorIntent(),
          LogicalKeySet(LogicalKeyboardKey.f3): const ChangeDesignIntent(),
          LogicalKeySet(LogicalKeyboardKey.f4): const ChangeSizeIntent(),
          LogicalKeySet(LogicalKeyboardKey.f5): const ChangePurityIntent(),
          LogicalKeySet(LogicalKeyboardKey.f7):
              const OpenTaggingSettingsIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyL):
              const OpenLotEntryDialogIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyD):
              const DiscardIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveTaggingEntry: CallbackAction<SaveTaggingEntry>(
              onInvoke: (intent) {
                // _taggingController.submitTaggingRecord();
                // bool isLoading =
                //     _taggingController.postDesignResponse.value.status == Status.LOADING;
                // if (isLoading == false) {
                //   _handleSaveOrUpdate();
                // }
                // actions.;
                _taggingController.resetFields();
                _taggingController.isFirstTime.value = true;
                _taggingController.searchQcyEmployees("");
                return;
              },
            ),
            ChangeVendorIntent: CallbackAction<ChangeVendorIntent>(
              onInvoke: (intent) => _taggingController.openVendorDialog(),
            ),
            ChangeDesignIntent: CallbackAction<ChangeDesignIntent>(
              onInvoke: (intent) => _taggingController.openDesignDialog(),
            ),
            ChangeSizeIntent: CallbackAction<ChangeSizeIntent>(
              onInvoke: (intent) => _taggingController.openSizeDialog(),
            ),
            ChangePurityIntent: CallbackAction<ChangePurityIntent>(
              onInvoke: (intent) => _taggingController.openPurityDialog(),
            ),
            OpenTaggingSettingsIntent:
                CallbackAction<OpenTaggingSettingsIntent>(
                  onInvoke: (intent) => _taggingController.openSettingsDialog(),
                ),
            OpenLotEntryDialogIntent: CallbackAction<OpenLotEntryDialogIntent>(
              onInvoke: (intent) => _taggingController.openLotDialog(),
            ),
            DiscardIntent: CallbackAction<DiscardIntent>(
              onInvoke: (intent) async {
                await Get.dialog<bool>(
                  CancelPaymentDialog(
                    subtitle:
                        'Are you sure you want to discard all changes? This action cannot be undone.',
                    onYesPressed: () async {
                      // Return true to indicate deletion should proceed
                      await taggingItemDetailsController.discardController();
                      _taggingController.isFirstTime.value = true;
                      return Future.value();
                    },
                  ),
                );
                return;
              },
            ),
          },
          child: FocusScope(
            autofocus: true,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    "assets/svgs/auth/background.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(header: 'Tagging'),
                    _buildTopBarWidget(),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [Expanded(child: TaggingItemDetails())],
                        ),
                      ),
                    ),
                    FooterWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTopBarWidget() {
    return Container(
      // height: 62,
      width: double.infinity,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Receipt No:',
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => CustomText(
                    text: _taggingController.taggingRecordNumber.value,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Lot No: (Ctrl+L)',
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    _taggingController.openLotDialog();
                  },
                  child: Obx(
                    () => CustomText(
                      text:
                          _taggingController
                              .selectedLotNumber
                              .value
                              ?.lotEntryNumber ??
                          "-",
                      fontSize: 16,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Tagged By:',
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                Obx(() {
                  return SizedBox(
                    width: 200,
                    child: GenericAutocompleteDropdown<GetEmployeesValue>(
                      controller:
                          _taggingController.employeeSearchController.value,
                      focusNode: _taggingController.employeeFocusNode,
                      items: const [],
                      getDisplayValue:
                          (employee) =>
                              '${employee.firstName ?? ''} ${employee.lastName ?? ''}',
                      onSelected: (value) async {
                        await _taggingController.setSelectedEmployee(value);
                      },
                      customOptionsBuilder: (textEditingValue) async {
                        await _taggingController.searchEmployees(
                          textEditingValue.text,
                        );
                        return _taggingController.employeeOptions.toList();
                      },
                      borderColor: secondaryColor,
                      isLastRow: true,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(width: 32),
            Obx(() {
              final employees = _taggingController.qcyEmployeeOptions;
              final selectedEmployees = _taggingController.selectedQcyEmployees;
              return CustomMultiSelectDropdown<GetEmployeesValue>(
                name: 'QCY',
                width: 200,
                items: employees.toList(),
                selectedItems: selectedEmployees.toList(),
                focusNode: _taggingController.qcyFocusNode,
                onChanged: (newSelection) {
                  /// only sync selection
                  for (final emp in newSelection) {
                    if (!selectedEmployees.any((e) => e.id == emp.id)) {
                      _taggingController.addQcyEmployee(emp);
                    }
                  }

                  final toRemove =
                      selectedEmployees
                          .where((e) => !newSelection.any((n) => n.id == e.id))
                          .toList();

                  for (final emp in toRemove) {
                    _taggingController.removeQcyEmployee(emp);
                  }
                },
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Select QCY Employee";
                  }
                  return null;
                },
                displayStringForOption:
                    (emp) =>
                        '${emp.firstName ?? ''} ${emp.lastName ?? ''}'.trim(),
              );
            }),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _taggingController.openVendorDialog();
                      },
                      child: Container(
                        height: 38,
                        width: 140,
                        decoration: BoxDecoration(
                          color: grey1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: CustomText(
                            text: "Add Vendor (F2)",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        _taggingController.openDesignDialog();
                      },
                      child: Container(
                        height: 38,
                        width: 140,
                        decoration: BoxDecoration(
                          color: grey1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: CustomText(
                            text: "Add Design (F3)",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        if (_taggingController.selectedDesign.value != null) {
                          _taggingController.openSizeDialog();
                        } else {
                          Get.snackbar('Error', 'Please select a design first');
                        }
                      },
                      child: Container(
                        height: 38,
                        width: 140,
                        decoration: BoxDecoration(
                          color: grey1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: CustomText(
                            text: "Add Size (F4)",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        _taggingController.openPurityDialog();
                      },
                      child: Container(
                        height: 38,
                        width: 140,
                        decoration: BoxDecoration(
                          color: grey1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: CustomText(
                            text: "Add Purity (F5)",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _taggingController.openSettingsDialog();
                      },
                      child: Container(
                        height: 38,
                        width: 140,
                        decoration: BoxDecoration(
                          color: grey1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Center(
                          child: CustomText(
                            text: "Settings (F7)",
                            fontSize: 16,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // showTwoButtons
                    //     ?
                    Row(
                      children: [
                        if (showGenderButton)
                          InkWell(
                            onTap: () {
                              Get.dialog(
                                GenderDialog(
                                  onGenderSelected: (value) {
                                    _taggingController.selectedGender.value =
                                        value;
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 38,
                              width: 180,
                              decoration: BoxDecoration(
                                color: grey1,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CustomText(
                                    text: "Add Gender (F6)",
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showGenderButton = false;
                                        if (!showMetalColorButton) {
                                          showTwoButtons = false;
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: redTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (showGenderButton && showMetalColorButton)
                          const SizedBox(width: 16),
                        if (showMetalColorButton)
                          InkWell(
                            onTap: () {
                              Get.dialog(
                                MetalColorDailog(
                                  onMetalColorSelected: (value) {
                                    _taggingController
                                        .selectedMetalColor
                                        .value = value;
                                  },
                                ),
                              );
                            },
                            child: Container(
                              height: 38,
                              width: 220,
                              decoration: BoxDecoration(
                                color: grey1,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CustomText(
                                    text: "Add Metal Color (F8)",
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showMetalColorButton = false;
                                        if (!showGenderButton) {
                                          showTwoButtons = false;
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: redTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!showTwoButtons)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              showTwoButtons = true;
                              showGenderButton = true;
                              showMetalColorButton = true;
                            });
                          },
                          child: Ink(
                            height: 38,
                            width: 100,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Center(
                              child: CustomText(
                                text: "+ Other",
                                fontSize: 16,
                                color: whiteColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  final TaggingItemDetailsController taggingItemDetailsController = Get.find();
  final TaggingController taggingController = Get.find();
  final SidebarController sidebarController = Get.find();

  FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.01,
              vertical: Get.height * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Vendor:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(
                      () => CustomText(
                        text: taggingController.selectedVendorCode.value ?? "-",
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Design:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(
                      () => CustomText(
                        text:
                            taggingController.selectedDesign.value?.name ?? "-",
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Size:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(
                      () => CustomText(
                        text: taggingController.selectedSizeName.value ?? "-",
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Purity:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(
                      () => CustomText(
                        text: taggingController.selectedPurity.value ?? "-",
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Counter:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(() {
                      if (taggingController.isCounterDefault.value) {
                        return const CustomText(
                          text: "Default",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        );
                      } else {
                        return CustomText(
                          text:
                              taggingController
                                  .selectedCounter
                                  .value
                                  ?.counterName ??
                              "-",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Gender:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(() {
                      if (taggingController.isCounterDefault.value) {
                        return const CustomText(
                          text: "Default",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        );
                      } else {
                        return CustomText(
                          text:
                              taggingController.selectedGender.value == null
                                  ? "-"
                                  : taggingController
                                          .selectedGender
                                          .value
                                          ?.label ??
                                      "-",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        );
                      }
                    }),
                  ],
                ),
                SizedBox(width: Get.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Metal Color:',
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    Obx(() {
                      if (taggingController.isCounterDefault.value) {
                        return const CustomText(
                          text: "Default",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        );
                      } else {
                        return CustomText(
                          text:
                              taggingController.selectedMetalColor.value == null
                                  ? "-"
                                  : taggingController
                                          .selectedMetalColor
                                          .value
                                          ?.colourName ??
                                      "-",
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        );
                      }
                    }),
                  ],
                ),
                const Spacer(),
                SizedBox(width: Get.width * 0.02),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await Get.dialog<bool>(
                            CancelPaymentDialog(
                              subtitle:
                                  'Are you sure you want to discard all changes? This action cannot be undone.',
                              onYesPressed: () async {
                                // Return true to indicate deletion should proceed
                                await taggingItemDetailsController
                                    .discardController();
                                taggingController.isFirstTime.value = true;
                                return Future.value();
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 38,
                          width: 140,
                          decoration: BoxDecoration(
                            color: grey1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: CustomText(
                              text: "Discard",
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Get.width * 0.01),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            taggingController.resetFields();
                            taggingController.isFirstTime.value = true;
                            taggingController.searchQcyEmployees("");
                          },
                          child: Ink(
                            height: 38,
                            width: 140,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "Save",
                                  fontSize: 16,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                CustomText(
                                  text: " (ctrl + s)",
                                  fontSize: 16,
                                  color: whiteColor,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
