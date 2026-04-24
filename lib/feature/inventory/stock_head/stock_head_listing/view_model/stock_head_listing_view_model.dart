import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock_head/edit_stock_head/view/edit_stock_head.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/add_stock_head_request.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/categories_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_metal_types_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

class StockHeadListingController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final SidebarController sidebarController = Get.find();

  final Rx<CategoriesResponse?> selectedCategories = Rx<CategoriesResponse?>(
    null,
  );
  final RxList<CategoriesResponse> categories = <CategoriesResponse>[].obs;

  final Rx<StockHeadMetalTypesResponse?> selectedStockHeadMetalType =
      Rx<StockHeadMetalTypesResponse?>(null);
  final RxList<StockHeadMetalTypesResponse> stockHeadMetalTypes =
      <StockHeadMetalTypesResponse>[].obs;

  final RxInt currentTabIndex = 0.obs;

  final RxString searchQuery = "".obs;
  final RxInt currentPage = 1.obs;
  final nextPage = Rxn<int?>(null);

  final RxBool hasMoreData = true.obs;

  final headers =
      [
        "Code",
        "Stock Head",
        "Category",
        "Weight Group",
        "Size Required",
        "",
      ].obs;

  final columnWidths = [0.45, 1.675, 0.45, 0.45, 0.45, 0.15, 0.1];

  final getStockHeadListingResponse = Rx<ApiResponse<StockHeadResponse>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    log("Stock Head initialized");
    getStockHeadMetalTypes();
    getStockHeadListingDetails();

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
              child: Tooltip(
                message: headers.elementAt(i),
                child: CustomText(
                  text: headers.elementAt(i),
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
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
      getStockHeadListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  List<String> popUpValues = ["Edit", "Delete"];

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final stockHeadDetail = getStockHeadListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${stockHeadDetail?.toJson()}");
    for (int i = 0; i < headers.length - 1; i++) {
      Widget cellWidget;
      switch (i) {
        case 0:
          cellWidget = Tooltip(
            message: stockHeadDetail?.code ?? "-",
            child: CustomText(
              text: stockHeadDetail?.code ?? "-",
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          );
          break;
        case 1:
          cellWidget = GestureDetector(
            onTap:
                () => onWeightGroupViewTapped(
                  stockHeadDetail?.id ?? "",
                  // stockHeadDetail?.id
                ),
            child: Tooltip(
              message: stockHeadDetail?.name ?? "-",
              child: CustomText(
                text: stockHeadDetail?.name ?? "-",
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          );
          break;
        case 2:
          cellWidget = Tooltip(
            message: stockHeadDetail?.category?.categoryName ?? "-",
            child: CustomText(
              text: stockHeadDetail?.category?.categoryName ?? "-",
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          );
          break;
        case 3:
          cellWidget = GestureDetector(
            onTap:
                () => onWeightGroupViewTapped(
                  stockHeadDetail?.id ?? "",
                  // stockHeadDetail?.id
                ),
            child: const Text(
              "View",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          );
          break;
        case 4:
          cellWidget = Tooltip(
            message: stockHeadDetail?.sizeRequired == true ? "Yes" : "No",
            child: CustomText(
              text: (stockHeadDetail?.sizeRequired ?? true) ? "Yes" : "No",
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color:
                  stockHeadDetail!.sizeRequired ?? true
                      ? totalGreenColor
                      : redTextColor,
            ),
          );
          break;
        default:
          cellWidget = const CustomText(
            text: "-",
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
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
                    child: cellWidget,
                  ),
                ),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }
    cells.add(_buildActionColumn(id: stockHeadDetail?.id ?? ""));
    return TableRow(children: cells);
  }

  Widget _buildActionColumn({String? id}) {
    return Column(
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
            icon: const Icon(Icons.more_vert_outlined, size: 20),
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  ...popUpValues.map((element) {
                    return PopupMenuItem<String>(
                      value: element,
                      height: 0,
                      child: SizedBox(
                        width: 88,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              element,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (element != popUpValues.last)
                              CustomDashedLineWidget(width: Get.width),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
            onSelected: (String value) {
              // Handle the selected option
              switch (value) {
                case 'Edit':
                  // Handle Edit
                  onWeightGroupViewTapped(id ?? "");
                  break;
                case 'Delete':
                  PermissionGuardUtil.withActionPermission(4204, () {
                    Get.dialog(
                      CancelPaymentDialog(
                        subtitle:
                            'Are you sure you want to delete this Stockhead?',
                        onYesPressed: () async {
                          await cancelOrnament(id ?? "");
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
    );
  }

  Future<void> cancelOrnament(String invoiceId) async {
    try {
      await inventoryRepository.deleteStockHead(invoiceId);
      // Refresh the list after successful cancellation
      await getStockHeadListingDetails();
      showSuccessToast(message: "stock head succeessfully deleted");
    } catch (e) {
      log("Error deleting ornament: $e");
      showErrorToast(message: 'Failed to delete ornament: ${e.toString()}');
    }
  }

  void onWeightGroupViewTapped(String stockHeadID) {
    if (stockHeadID.isNotEmpty) {
      log('Weight Group View tapped for Stock Head ID $stockHeadID');
      SidebarController sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: EditStockHead(stockHeadId: stockHeadID),
      );
    }
  }

  final Rx<ApiResponse<StockHeadResponse>> getStockHeadDetailsResponse =
      Rx<ApiResponse<StockHeadResponse>>(ApiResponse.initial("Initial"));

  Future<void> getStockHeadListingDetails({
    bool loadMore = false,
    String? stockHeadName,
  }) async {
    try {
      if (!loadMore) {
        getStockHeadListingResponse.value = ApiResponse.loading("Loading");
        currentPage.value = 1;
        nextPage.value = null;
      }

      final response = await inventoryRepository.getStockHeads(
        page: loadMore ? nextPage.value : null,
        limit: 10,
        query: stockHeadName ?? searchQuery.value,
        metal_type:
            selectedStockHeadMetalType.value?.id != null
                ? int.parse(selectedStockHeadMetalType.value!.id!)
                : null,
      );

      if (stockHeadName != null && response.values?.isNotEmpty == true) {
        // If we're querying for a specific stock head, update the details response
        getStockHeadDetailsResponse.value = ApiResponse.completed(
          StockHeadResponse(
            values: [response.values!.first],
            pagination: response.pagination,
          ),
        );
      } else {
        if (loadMore) {
          final currentData = getStockHeadListingResponse.value.data;
          if (currentData != null) {
            currentData.values?.addAll(response.values ?? []);
            getStockHeadListingResponse.value = ApiResponse.completed(
              currentData,
            );
          } else {
            getStockHeadListingResponse.value = ApiResponse.completed(response);
          }
        } else {
          getStockHeadListingResponse.value = ApiResponse.completed(response);
        }
      }

      nextPage.value = response.pagination?.nextPage;
      hasMoreData.value = response.pagination?.nextPage != null;
      currentPage.value++;
    } catch (e, stackTrace) {
      log('Error: $e');
      log('Stack trace: $stackTrace');
      getStockHeadListingResponse.value = ApiResponse.error(e.toString());
      if (stockHeadName != null) {
        getStockHeadDetailsResponse.value = ApiResponse.error(e.toString());
      }
    }
  }

  final getCategoriesResponse = Rx<ApiResponse<List<CategoriesResponse>>>(
    ApiResponse.initial("Initial"),
  );
  Future<void> getCategories() async {
    try {
      getCategoriesResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getCategories();
      getCategoriesResponse.value = ApiResponse.completed(response);
      categories.value = response;
      if (categories.isNotEmpty) {
        selectedCategories.value = categories.first;
      }
    } catch (e) {
      log('Error fetching categories: $e');
      getCategoriesResponse.value = ApiResponse.error(e.toString());
    }
  }

  final getStockHeadMetalTypeResponse =
      Rx<ApiResponse<List<StockHeadMetalTypesResponse>>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getStockHeadMetalTypes() async {
    try {
      getStockHeadMetalTypeResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStockHeadMetalTypes();
      stockHeadMetalTypes.value = response;

      if (stockHeadMetalTypes.isNotEmpty) {
        final tabIndex =
            currentTabIndex.value < stockHeadMetalTypes.length
                ? currentTabIndex.value
                : 0;
        selectedStockHeadMetalType.value = stockHeadMetalTypes[tabIndex];
      }
      getStockHeadMetalTypeResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error fetching stock head metal types: $e');
      getStockHeadMetalTypeResponse.value = ApiResponse.error(e.toString());
    }
  }

  void setSelectedStockHeadMetalType(StockHeadMetalTypesResponse? value) {
    selectedStockHeadMetalType.value = value;
    getStockHeadListingDetails();
  }

  final addStockHeadRequest = Rx<ApiResponse<AddStockHeadRequest>>(
    ApiResponse.initial("Initial"),
  );

  void setSelectedCategories(CategoriesResponse? value) {
    selectedCategories.value = value;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getStockHeadListingDetails();
  }

  Future<void> loadMoreData() async {
    if (hasMoreData.value) {
      await getStockHeadListingDetails(loadMore: true);
    }
  }
}
