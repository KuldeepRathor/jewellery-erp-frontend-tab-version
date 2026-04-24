import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_report_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_stock_reports/model/daily_stock_save_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/daily_stock_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DailyStockReportViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  DailyStockReportRepository dailyStockReportRepository =
      DailyStockReportRepository();

  final dailyStockReportList = Rx<ApiResponse<List<DailyStockResponseModel>>>(
    ApiResponse.initial("INITIAL"),
  );

  RxBool isSubmitDailyStockLoading = false.obs;
  RxBool sunbmittedSuccess = false.obs;
  final RxBool hasMoreData = false.obs;
  final RxString searchQuery = ''.obs;
  final currentRowIndex = 0.obs;
  final currentColIndex = 0.obs;
  final headersDailyStock =
      ["S.no", "Counter Name", "Stockhead Count", " "].obs;

  List<double> get columnWidths => [0.30, 2.65, 0.60, 0.1];

  List<String> popUpValues = ["Edit"];

  final formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 1, vsync: this);
    _initializeData();
  }

  void _initializeData() async {
    await getStockHeadListingDetails();
  }

  Future<void> getStockHeadListingDetails() async {
    try {
      dailyStockReportList.value = ApiResponse.loading('');
      final data = await dailyStockReportRepository.getAllDailyReport();
      dailyStockReportList.value = ApiResponse.completed(
        data.cast<DailyStockResponseModel>(),
      );
      hasMoreData.value = false;
    } catch (e) {
      dailyStockReportList.value = ApiResponse.error(
        'Failed to fetch stock head listing details',
      );
    } finally {
      update();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getStockHeadListingDetails();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  final controllers = <DailyStockRowController>[].obs;

  void addRow(List<DailyStockResponseModelStockHead> stockHeads) {
    for (int i = 0; i < stockHeads.length; i++) {
      controllers.add(
        DailyStockRowController()
          ..counterNumber.text =
              stockHeads.elementAt(i).manualCount == null
                  ? "0"
                  : stockHeads.elementAt(i).manualCount.toString(),
      );
    }
    update();
  }

  final headersDailyStockDetails = ['Sn', ' Stockhead Name', '', ' Count', ''];

  final columnWidthsDailyStockDetails = [0.25, 0.45, 2.40, 0.25, 0.35].obs;

  void moveFocusToNextCell(int rowIndex, int colIndex) {
    final isLastColumn = colIndex == headersDailyStockDetails.length - 2;
    final isLastRow = rowIndex == controllers.length - 1;

    if (isLastColumn) {
      currentRowIndex.value = isLastRow ? controllers.length - 1 : rowIndex + 1;
      currentColIndex.value = 0;
    } else {
      currentColIndex.value = colIndex + 1;
    }

    final nextFocusNode = controllers[currentRowIndex.value].getFocusNode(
      currentColIndex.value,
    );
    nextFocusNode.requestFocus();
  }

  void submitDailyStock(DailyStockResponseModel model) async {
    isSubmitDailyStockLoading.value = true;
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (int i = 0; i < controllers.length; i++) {
        if (controllers[i].counterNumber.text.isEmpty) {
          throw Exception('Enter a count at position ${i + 1}.');
        }
      }

      final dailyStockSaveRequestModel = DailyStockSaveRequestModel(
        date: formattedDate,
        counterId: model.id,
        lineItems:
            model.stockHeads?.asMap().entries.map((entry) {
              final index = entry.key;
              final stockHead = entry.value;
              return LineItem(
                stockHeadId: stockHead.id,
                count: stockHead.count ?? 0,
                manualCount: int.tryParse(
                  controllers[index].counterNumber.text.trim(),
                ),
                // manualCount: stockHead.manualCount ?? 0,
              );
            }).toList(),
      );

      await dailyStockReportRepository.dailyReportSubmit(
        dailyStockSaveRequestModel,
      );
      sunbmittedSuccess.value = true;
      getStockHeadListingDetails();
    } catch (e) {
      showErrorToast(message: 'Error submitting daily stock: ${e.toString()}');
    } finally {
      isSubmitDailyStockLoading.value = false;
    }
  }
}

class DailyStockRowController {
  final TextEditingController counterNumber = TextEditingController();

  final List<FocusNode> tableFocusNodes = List.generate(1, (_) => FocusNode());

  dynamic getController(int colIndex) {
    return [counterNumber][colIndex];
  }

  FocusNode getFocusNode(int colIndex) {
    return tableFocusNodes[colIndex];
  }

  void dispose() {
    counterNumber.dispose();
    for (var focusNode in tableFocusNodes) {
      focusNode.dispose();
    }
  }
}

class StockHeadMetalType {
  final String? typeName;

  StockHeadMetalType({this.typeName});
}
