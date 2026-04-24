import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view/add_stone_rates_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class StoneRatesListController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final headers =
      [
        "Stone Code",
        "Stone Name",
        "Ornament Code",
        "Rate",
        "Color",
        "Cut",
        "Clarity",
        "Buyback %",
        "",
      ].obs;

  final columnWidths = [0.4, 0.7, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.1];
  final List<String> popUpValues = ["Edit", "Deactivate"];

  final getStoneRatesResponse = Rx<ApiResponse<GetStoneRatesResponse>>(
    ApiResponse.initial("Initial"),
  );

  final searchQuery = ''.obs;
  int? nextPage;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;

  @override
  void onInit() {
    log("Stone Rates Listing");
    super.onInit();
  }

  TableRow buildTableHeaders() {
    return TableRow(
      children:
          headers
              .map(
                (header) => Row(
                  children: [
                    Flexible(
                      child: CustomText(
                        text: header,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      getStoneRatesResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final stoneRatesDetail = getStoneRatesResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${stoneRatesDetail?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      Color textColor = Colors.black;
      TextDecoration? textDecoration;
      VoidCallback? onTapFunction;

      switch (i) {
        case 0:
          cellContent = stoneRatesDetail?.code ?? "-";
          // Make stone code blue and underlined
          textColor = Colors.blue;
          textDecoration = TextDecoration.underline;
          // Make it clickable to edit stone rates
          onTapFunction = () async {
            log("Edit stone rates");
            await PermissionGuardUtil.withActionPermissionAsync(4303, () async {
              if (stoneRatesDetail?.id != null) {
                await Get.dialog(
                  AddStoneRatesDialog(stoneRateId: stoneRatesDetail!.id),
                );
                getStoneRatesDetails(resetList: true);
              }
            });
          };
          break;
        case 1:
          cellContent = stoneRatesDetail?.name ?? "-";
          break;
        case 2:
          cellContent = stoneRatesDetail?.ornament?.code ?? "-";
          break;
        case 3:
          cellContent =
              "${stoneRatesDetail?.rate ?? "-"} / ${stoneRatesDetail?.rateType ?? "-"}";
          break;
        case 4:
          cellContent = stoneRatesDetail?.color ?? "-";
          break;
        case 5:
          cellContent = stoneRatesDetail?.cut ?? "-";
          break;
        case 6:
          cellContent = stoneRatesDetail?.clarity ?? "-";
          break;
        case 7:
          cellContent = stoneRatesDetail?.buyBackPercentage ?? "-";
          break;
        case 8:
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
                      onSelected: (String value) async {
                        switch (value) {
                          case 'Edit':
                            await PermissionGuardUtil.withActionPermissionAsync(
                              4303,
                              () async {
                                if (stoneRatesDetail?.id != null) {
                                  await Get.dialog(
                                    AddStoneRatesDialog(
                                      stoneRateId: stoneRatesDetail!.id,
                                    ),
                                  );
                                  getStoneRatesDetails(resetList: true);
                                }
                              },
                            );
                            break;
                          case 'Deactivate':
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
        // For clickable cells (like stone code)
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

  void setInitialConditions({required bool isSearch}) {
    nextPage = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getStoneRatesDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getStoneRatesResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await inventoryRepository.getStoneRates(
        nextPage: nextPage,
        limit: itemsPerPage,
        query: searchQuery.value,
      );

      if (resetList) {
        getStoneRatesResponse.value = ApiResponse.completed(response);
      } else {
        final List<GetStoneRatesValue> currentData =
            getStoneRatesResponse.value.data?.values ?? [];
        final List<GetStoneRatesValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getStoneRatesResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.nextPage != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        nextPage = response.pagination?.nextPage;
      }
    } catch (e) {
      getStoneRatesResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getStoneRatesDetails(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    log("Load more stones ${hasMorePages.value} ${isLoadingMore.value}");

    if (!isLoadingMore.value && hasMorePages.value) {
      await getStoneRatesDetails();
    }
  }
}
