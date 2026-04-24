import 'dart:convert';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_dio_client.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_in_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_transfer/model/branch_out_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/app_url/app_url.dart';

class BranchReportServices {
  final HttpDioClient _apiService = Get.find();

  //Stock head services
  Future<void> cancelBranchInRecord(
    String branchInNumber,
    String branchTransferFrom,
  ) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-branch-in-record/$branchInNumber',
        queryParameters: {'branch_transfer_from': branchTransferFrom},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getBranchInList({
    String? offsetId,
    int limit = 100,
    String query = '',
    int? metal_type,
  }) async {
    String path;
    if (offsetId != null) {
      path = '?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(
        AppUrl.branchInReportListBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getBranchOutList({
    String? offsetId,
    int limit = 100,
    String query = '',
    int? metal_type,
  }) async {
    String path;
    if (offsetId != null) {
      path = '?query=$query&limit=$limit&offset_id=$offsetId';
    } else {
      path = '?query=$query&limit=$limit';
    }
    try {
      final response = await _apiService.get(
        AppUrl.branchOutReportListBaseUrl,
        path,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future branchInSubmit(BranchInRequestModel branchInRequestModel) async {
    try {
      final body = branchInRequestModel.toJson();
      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/branch-in",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future branchOutSubmit(BranchOutRequestModel branchOutRequestModel) async {
    try {
      final body = branchOutRequestModel.toJson();

      final response = await _apiService.post(
        AppUrl.inventoryBaseUrl,
        "/branch-out",
        data: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBranchOutRecord(String recordId) async {
    try {
      await _apiService.delete(
        AppUrl.inventoryBaseUrl,
        '/cancel-branch-out-record/$recordId',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future getAllTransferBy() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/employees',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getAllTransferTo() async {
    try {
      final response = await _apiService.get(
        AppUrl.organizationBaseUrl,
        '/branches',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getByExistingTag(String tag) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/tagging-line-item-by-barcode-number?tag_barcode=$tag',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getCounterList() async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/counters',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchBranchOutByNumber(String branchOutNumber) async {
    try {
      final response = await _apiService.get(
        AppUrl.inventoryBaseUrl,
        '/branch-out-by-transfer-number/$branchOutNumber',
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
