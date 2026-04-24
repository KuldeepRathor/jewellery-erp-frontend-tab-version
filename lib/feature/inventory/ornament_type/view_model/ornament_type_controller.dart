import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/ornament_type/view/add_ornament_type_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/get_ornament_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/ornamnet_type/metal_type_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/get_purity_response_v2.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toast_widget.dart';
import 'package:toastification/toastification.dart';

class OrnamentTypeController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final ornamentCodeController = TextEditingController();
  final ornamentNameController = TextEditingController();
  final hsnCodeController = TextEditingController();
  final gstPercentController = TextEditingController();
  final openingWeightController = TextEditingController();
  final openingAmountController = TextEditingController();
  final openingQuantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;

  // final Rx<MetalTypeResponse?> selectedMetalType = Rx<MetalTypeResponse?>(null);

  final RxList<MetalTypeResponse> metalTypes = <MetalTypeResponse>[].obs;

  final Rx<MetalTypeResponse?> selectedMetalType = Rx<MetalTypeResponse?>(null);
  final RxString currentCodeType = RxString('HSN/SAC');
  final getOrnamentTypeByIdResponse = Rx<ApiResponse<OrnamnetTypeValues>>(
    ApiResponse.initial("Initial"),
  );

  bool get isPurityRequired => !isStone.value && !isService.value;

  void validateForm() {
    formKey.currentState!.validate();
  }

  void setSelectedMetalType(MetalTypeResponse? value) {
    selectedMetalType.value = value;
    if (value != null && value.codeType != null) {
      currentCodeType.value = value.codeType!;
    } else {
      currentCodeType.value = 'HSN/SAC';
    }
  }

  final headers =
      [
        "Sn",
        "Code",
        "Ornament Name",
        "HSN/SAC Code",
        "Metal /Services Type",
        "Purity",
        "Opening Weight",
        "Opening Amount",
        "",
      ].obs;
  final columnWidths = [
    0.1, // Sn
    0.4, // Code
    0.775, // Ornament Name
    0.45, // HSN/SAC Code
    0.45, // Metal Type
    0.45, // Purity
    0.45, // Opening Weight
    0.45, // Opening Amount
    0.1, // Actions
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getOrnamentTypeListingResponse = Rx<ApiResponse<OrnamentTypeResponse>>(
    ApiResponse.initial("Initial"),
  );
  Uint8List? pdf;

  final searchQuery = ''.obs;
  @override
  void onInit() {
    log("Ornamnet Type Listing");
    getMetalTypes();
    getSelectedPurity();
    super.onInit();
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      // String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            // if (header != "Sn")
            //   const SizedBox(
            //     width: 4,
            //   ),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      getOrnamentTypeListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];
  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final ornamentDetail = getOrnamentTypeListingResponse.value.data?.values
        ?.elementAt(index);

    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      Color textColor = Colors.black;
      TextDecoration? textDecoration;
      VoidCallback? onTapFunction;

      switch (i) {
        case 0: // Sn
          cellContent = (index + 1).toString();
          break;
        case 1: // Code
          cellContent = ornamentDetail?.code ?? "-";
          // Make ornament code blue and underlined
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          // Make it clickable to edit ornament
          onTapFunction = () {
            log("Edit ornament type");
            if (ornamentDetail?.id != null) {
              Get.dialog(
                AddNewOrnamentTypeDialog(ornamentId: ornamentDetail!.id),
              );
            }
          };
          break;
        case 2: // Ornament Name
          cellContent = ornamentDetail?.name ?? "-";
          break;
        case 3: // HSN/SAC Code
          cellContent = ornamentDetail?.hsnSac ?? "-";
          break;
        case 4: // Metal Type
          cellContent = ornamentDetail?.metalType?.typeName ?? "-";
          break;
        case 5: // Purity
          cellContent = ornamentDetail?.purity ?? "-";
          break;
        case 6: // Opening Weight
          cellContent = ornamentDetail?.openingWeight ?? "-";
          break;
        case 7: // Opening Amount
          cellContent = ornamentDetail?.openingAmount ?? "-";
          break;
        case 8: // Actions column
          return TableRow(
            children: [
              ...cells,
              Column(
                children: [
                  const SizedBox(height: 8),
                  Theme(
                    data: ThemeData(
                      focusColor: greyTextColor,
                      tooltipTheme: const TooltipThemeData(
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),
                    ),
                    child: CustomPopupMenuButtonWidget<String>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            ...popUpValues.map((element) {
                              return PopupMenuItem<String>(
                                value: element,
                                height: 0,
                                child: SizedBox(
                                  width: 88,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        element,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (element != popUpValues.last)
                                        CustomDashedLineWidget(
                                          width: Get.width,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'Edit':
                            if (ornamentDetail?.id != null) {
                              Get.dialog(
                                AddNewOrnamentTypeDialog(
                                  ornamentId: ornamentDetail!.id,
                                ),
                              );
                            }
                            break;
                          case 'Delete':
                            PermissionGuardUtil.withActionPermission(4354, () {
                              Get.dialog(
                                CancelPaymentDialog(
                                  subtitle:
                                      'Are you sure you want to delete this Ornament/Service Type?',
                                  onYesPressed: () async {
                                    await cancelOrnament(
                                      ornamentDetail?.id ?? "",
                                    );
                                  },
                                ),
                              );
                            });
                            break;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 7),
                  CustomDashedLineWidget(width: Get.width),
                ],
              ),
            ],
          );
      }

      // Create the cell widget with proper structure
      Widget cellWidget;

      if (onTapFunction != null) {
        // For clickable cells (like ornament code)
        cellWidget = GestureDetector(
          onTap: onTapFunction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Tooltip(
              message: cellContent,
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: textColor,
                decoration: textDecoration,
              ),
            ),
          ),
        );
      } else {
        // For non-clickable cells
        cellWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Tooltip(
            message: cellContent,
            child: CustomText(
              text: cellContent,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color: textColor,
              decoration: textDecoration,
            ),
          ),
        );
      }

      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(child: cellWidget),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  void checkCodeAvailability(String code, String model) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }
    isCheckingCode.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await inventoryRepository.validateCode(code, model);
        isCodeAvailable.value = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code Availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  Future<void> cancelOrnament(String invoiceId) async {
    try {
      await inventoryRepository.deleteOrnament(invoiceId);
      // Refresh the list after successful cancellation
      await getOrnamentsTypeListingDetails();
    } catch (e) {
      log("Error deleting ornament: $e");
      showErrorToast(message: 'Failed to delete ornament: ${e.toString()}');
    }
  }

  Future<void> getOrnamentsTypeListingDetails() async {
    try {
      // await Future.delayed(Durations.extralong4);
      final response = await inventoryRepository.getOrnamentType();
      getOrnamentTypeListingResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getOrnamentTypeListingResponse.value = ApiResponse.error(e.toString());
    }
  }

  Future<void> getOrnamentTypeById(String ornamentId) async {
    try {
      getOrnamentTypeByIdResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getOrnamentTypeById(
        ornamentId,
      );
      setOrnamentTypeData(response);

      getOrnamentTypeByIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error getting ornament type: $e');
      getOrnamentTypeByIdResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load ornament type");
    }
  }

  void setOrnamentTypeData(OrnamnetTypeValues ornamentData) {
    ornamentCodeController.text = ornamentData.code ?? "";
    ornamentNameController.text = ornamentData.name ?? "";
    hsnCodeController.text = ornamentData.hsnSac ?? "";
    gstPercentController.text = ornamentData.gst ?? "";
    openingWeightController.text = ornamentData.openingWeight ?? "";
    openingAmountController.text = ornamentData.openingAmount ?? "";
    openingQuantityController.text =
        (ornamentData.openingQuantity ?? 0).toString();
    isStone.value = ornamentData.isStone ?? false;
    isOldGold.value = ornamentData.isOldGold ?? false;
    isService.value = ornamentData.isService ?? false;

    if (ornamentData.metalType != null) {
      final metalType = metalTypes.firstWhereOrNull(
        (element) => element.id == ornamentData.metalType?.id,
      );
      if (metalType != null) {
        setSelectedMetalType(metalType);
      }
    }

    // Updated purity handling - find matching purity by purity_type
    if (ornamentData.purity != null &&
        getPurityResponse.value.data?.values != null) {
      final matchingPurity = getPurityResponse.value.data!.values!
          .firstWhereOrNull(
            (purityValue) => purityValue.purityType == ornamentData.purity,
          );
      if (matchingPurity != null) {
        selectedPurity.value = matchingPurity;
      }
    }
  }

  Future<void> submitOrnamentType(String? ornamentId) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Check code availability for new ornaments
      if (ornamentId == null && !isCodeAvailable.value) {
        showErrorToast(message: "Select valid code");
        return;
      }

      // Create ornament type values object
      final ornamentTypeValues = OrnamnetTypeValues(
        name: ornamentNameController.text,
        code: ornamentCodeController.text,
        hsnSac: hsnCodeController.text,
        gst: gstPercentController.text,
        openingWeight:
            openingWeightController.text.isEmpty
                ? "0"
                : openingWeightController.text,
        openingAmount:
            openingAmountController.text.isEmpty
                ? "0"
                : openingAmountController.text,
        metalType: MetalTypeResponse(id: selectedMetalType.value!.id),
        openingQuantity: int.tryParse(openingQuantityController.text) ?? 0,
        isStone: isStone.value,
        isOldGold: isOldGold.value,
        isService: isService.value,
        // Only included purity if it's required and selected
        purity:
            isPurityRequired && selectedPurity.value != null
                ? selectedPurity.value!.purityType
                : null,
      );
      addOrnamentTypeResponse.value = ApiResponse.loading("Loading");
      // Submit to appropriate endpoint
      final response =
          ornamentId == null
              ? await inventoryRepository.addOrnamnetType(ornamentTypeValues)
              : await inventoryRepository.editOrnament(
                ornamentId,
                ornamentTypeValues,
              );

      addOrnamentTypeResponse.value = ApiResponse.completed(response);
      Get.back(result: response);

      resetFields();

      // Show success toast
      String msg =
          ornamentId == null
              ? 'Ornament type added successfully'
              : 'Ornament type updated successfully';
      showSuccessToast(message: msg);

      await getOrnamentsTypeListingDetails();
    } catch (e) {
      log('Error submitting ornament type: $e');
      addOrnamentTypeResponse.value = ApiResponse.error(e.toString());
      showErrorToast(
        message:
            ornamentId == null
                ? "Failed to add ornament"
                : "Failed to update ornament",
      );
    }
  }

  final addOrnamentTypeResponse = Rx<ApiResponse<OrnamnetTypeValues>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> addOrnamentType({bool isSearch = false}) async {
    try {
      addOrnamentTypeResponse.value = ApiResponse.loading("Loading");

      final OrnamnetTypeValues ornamentTypeValues = OrnamnetTypeValues(
        name: ornamentNameController.text,
        code: ornamentCodeController.text,
        hsnSac: hsnCodeController.text,
        gst: gstPercentController.text,
        openingWeight: openingWeightController.text,
        openingAmount: openingAmountController.text,
        metalType: MetalTypeResponse(id: selectedMetalType.value!.id),
        openingQuantity: 0,

        // organizationI/d: "3f93a0c7-0a37-447a-8bb5-6dadb385244a",
      );

      final response = await inventoryRepository.addOrnamnetType(
        ornamentTypeValues,
      );
      addOrnamentTypeResponse.value = ApiResponse.completed(response);
      Get.back();
      resetFields();
      CustomToastWidget.show(
        message: "New ornament type added successfully",
        type: ToastificationType.success,
      );
      await getOrnamentsTypeListingDetails();
    } catch (e) {
      log('Error adding ornament type: $e');

      addOrnamentTypeResponse.value = ApiResponse.error(e.toString());
      // Get.snackbar('Error', 'Failed to add ornament');
      showErrorToast(message: "Failed to add ornament");
    }
  }

  final getMetalTypesResponse = Rx<ApiResponse<List<MetalTypeResponse>>>(
    ApiResponse.initial("Initial"),
  );

  Future<void> getMetalTypes() async {
    try {
      getMetalTypesResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getMetalTypes();
      getMetalTypesResponse.value = ApiResponse.completed(response);
      metalTypes.assignAll(response);
    } catch (e) {
      getMetalTypesResponse.value = ApiResponse.error(e.toString());
      log('Error fetching metal types: $e');
    }
  }

  // void setSelectedMetalType(MetalTypeResponse? value) {
  //   selectedMetalType.value = value;
  // }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getOrnamentsTypeListingDetails();
    });
  }

  final getPurityResponse = Rx<ApiResponse<GetPurityResponseV2>>(
    ApiResponse.initial("Initial"),
  );
  final Rxn<GetPurityValue?> selectedPurity = Rxn<GetPurityValue?>(null);

  Future<void> getSelectedPurity() async {
    try {
      getPurityResponse.value = ApiResponse.loading("Loading");
      final response =
          await inventoryRepository.getSelectedPurityv2(); // Changed to v2
      getPurityResponse.value = ApiResponse.completed(response);
    } catch (e) {
      getPurityResponse.value = ApiResponse.error(e.toString());
      log('Error fetching purity types: $e');
    }
  }

  void setSelectedPurity({required GetPurityValue value}) {
    selectedPurity.value = value;
  }

  void resetFields() {
    ornamentNameController.clear();
    ornamentCodeController.clear();
    hsnCodeController.clear();
    gstPercentController.clear();
    openingWeightController.clear();
    openingAmountController.clear();
    openingQuantityController.clear();
    selectedMetalType.value = null;
    currentCodeType.value = 'HSN/SAC';
    getOrnamentTypeByIdResponse.value = ApiResponse.initial("Initial");
    isStone.value = false;
    isOldGold.value = false;
    isService.value = false;

    isCodeAvailable.value = true;
    isCheckingCode.value = false;
    // getPurityResponse.value = ApiResponse.initial("Initial");
    selectedPurity.value = null;
  }

  final RxBool isStone = false.obs;
  final RxBool isOldGold = false.obs;
  final RxBool isService = false.obs;
}
