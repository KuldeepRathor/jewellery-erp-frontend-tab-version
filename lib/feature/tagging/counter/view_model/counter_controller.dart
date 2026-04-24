import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/model/counter/counter_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_toast_widget.dart';
import 'package:toastification/toastification.dart';

class CounterController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  final counterCodeController = TextEditingController();
  final counterNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;
  final RxBool isDefault = false.obs;

  // final Rx<MetalTypeResponse?> selectedMetalType = Rx<MetalTypeResponse?>(null);

  // final RxList<MetalTypeResponse> metalTypes = <MetalTypeResponse>[].obs;

  void validateForm() {
    formKey.currentState!.validate();
  }

  void toggleIsDefault() {
    isDefault.value = !isDefault.value;
    log("isDefault toggled to: ${isDefault.value}");
  }

  final headers =
      [
        "Code",
        "Counter Name",
        "Counter Type",
        "Total items",
        "Total Weight(gms)",
        "",
      ].obs;
  final columnWidths = [0.4, 1.2, 0.4, 0.4, 0.4, 0.1];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getCounterResponse = Rx<ApiResponse<CounterResponse>>(
    ApiResponse.initial("Initial"),
  );

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    log("Counter Listing");
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
      getCounterResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final counterDetail = getCounterResponse.value.data?.values?.elementAt(
      index,
    );

    log("The value is : ${counterDetail?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String? cellContent = "-";
      switch (i) {
        case 0:
          cellContent = counterDetail?.code ?? "-";
          break;
        case 1:
          cellContent = counterDetail?.counterName ?? "-";
          break;
        case 2:
          cellContent = counterDetail?.isDefault == true ? "Default" : "-";
          break;
        case 3:
          cellContent = counterDetail?.totalItems.toString() ?? "-";
          break;
        case 4:
          cellContent = counterDetail?.totalWeight ?? "-";
          break;
        case 5:
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
                                      if (element != "Delete")
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
                            break;
                          case 'Delete':
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
      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(
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
                      ),
                    ),
                  ),
                ),
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

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getCounterListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getCounterResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await inventoryRepository.getCounterListing(
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getCounterResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getCounterResponse.value.data?.values ?? [];
        List<CounterValue> newData = [...currentData, ...response.values ?? []];
        response.values = newData;
        getCounterResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      getCounterResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  final addCounterResponse = Rx<ApiResponse<CounterValue>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> addCounter() async {
    try {
      addCounterResponse.value = ApiResponse.loading("Loading");

      final CounterValue addCounter = CounterValue(
        counterName: counterNameController.text,
        code: counterCodeController.text,
        isDefault: isDefault.value,
      );

      final response = await inventoryRepository.addCounter(addCounter);
      addCounterResponse.value = ApiResponse.completed(response);
      Get.back();
      resetFields();
      CustomToastWidget.show(
        message: "New Counter added successfully",
        type: ToastificationType.success,
      );
      await getCounterListingDetails(resetList: true);
    } catch (e) {
      log('Error adding Counter: $e');
      addCounterResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to add Counter");
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getCounterListingDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getCounterListingDetails();
    }
  }

  void resetFields() {
    counterNameController.clear();
    counterCodeController.clear();
    isDefault.value = false;
  }
}
