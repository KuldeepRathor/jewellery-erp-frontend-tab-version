import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_in_listing/model/branch_in_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_in_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_by_no_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/model/branch_out_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/counter_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_by_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/transfer_to_drop_down_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/services/branch_report_services.dart';

class BranchReportRepository {
  final BranchReportServices branchReportServices = BranchReportServices();
  Future<void> cancelBranchInRecord(
    String branchInNumber,
    String branchTransferFrom,
  ) async {
    try {
      await branchReportServices.cancelBranchInRecord(
        branchInNumber,
        branchTransferFrom,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<BranchInReportResponse> getBranchInList({
    String? offsetId,
    int limit = 100,
    String query = '',
    int? metal_type,
  }) async {
    final response = await branchReportServices.getBranchInList(
      offsetId: offsetId,
      limit: limit,
      query: query,
      metal_type: metal_type,
    );
    final data = BranchInReportResponse.fromJson(response);
    return data;
  }

  Future<BranchOutReportResponse> getBranchOutList({
    String? offsetId,
    int limit = 100,
    String query = '',
    int? metal_type,
  }) async {
    final response = await branchReportServices.getBranchOutList(
      offsetId: offsetId,
      limit: limit,
      query: query,
      metal_type: metal_type,
    );
    final data = BranchOutReportResponse.fromJson(response);
    return data;
  }

  Future<BranchInRequestModel> branchInSubmit(
    BranchInRequestModel branchInRequestModel,
  ) async {
    final response = await branchReportServices.branchInSubmit(
      branchInRequestModel,
    );
    return BranchInRequestModel.fromJson(response);
  }

  Future<BranchOutRequestModel> branchOutSubmit(
    BranchOutRequestModel branchOutRequestModel,
  ) async {
    final response = await branchReportServices.branchOutSubmit(
      branchOutRequestModel,
    );
    return BranchOutRequestModel.fromJson(response);
  }

  Future<void> cancelBranchOutRecord(String recordId) async {
    try {
      await branchReportServices.cancelBranchOutRecord(recordId);
    } catch (e) {
      rethrow;
    }
  }

  Future<TransferByDropDownModel> getAllTransferBy() async {
    final response = await branchReportServices.getAllTransferBy();

    return TransferByDropDownModel.fromJson(response);
  }

  Future<TransferToDropDownModel> getAllTransferTo() async {
    final response = await branchReportServices.getAllTransferTo();

    return TransferToDropDownModel.fromJson(response);
  }

  Future<GetTaggingLineItemCodeTagResponse> getByExistingTag(String tag) async {
    final response = await branchReportServices.getByExistingTag(tag);

    return GetTaggingLineItemCodeTagResponse.fromJson(response);
  }

  Future<CounterDropDownModel> getCounterList() async {
    final response = await branchReportServices.getCounterList();

    return CounterDropDownModel.fromJson(response);
  }

  Future<BranchOutByNoResponseModel> fetchBranchOutByNumber(
    String branchOutNumber,
  ) async {
    final response = await branchReportServices.fetchBranchOutByNumber(
      branchOutNumber,
    );

    return BranchOutByNoResponseModel.fromJson(response);
  }
}
