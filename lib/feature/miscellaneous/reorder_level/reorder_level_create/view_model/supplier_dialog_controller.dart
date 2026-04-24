import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/party_details_repository.dart';

class SupplierDialogController extends GetxController {
  final PartyDetailsRepository _repository = PartyDetailsRepository();
  final TextEditingController supplierController = TextEditingController();
  final FocusNode supplierFocusNode = FocusNode();
  final RxBool isLoading = false.obs;
  final RxString currentSupplier = ''.obs;

  final vendors = <VendorSearchValue>[].obs;
  final Function(VendorSearchValue) onApplySingle;
  final Function(VendorSearchValue) onApplyAll;
  VendorSearchValue? selectedVendor;

  SupplierDialogController({
    required this.onApplySingle,
    required this.onApplyAll,
  });

  @override
  void onClose() {
    supplierController.dispose();
    supplierFocusNode.dispose();
    super.onClose();
  }

  Future<Iterable<VendorSearchValue>> searchVendors(String query) async {
    if (query.isEmpty) return const [];

    try {
      isLoading.value = true;
      final result = await _repository.searchVendor(query);
      return result.values ?? [];
    } catch (e) {
      log('Error searching vendors: $e');
      return const [];
    } finally {
      isLoading.value = false;
    }
  }

  void onVendorSelected(VendorSearchValue vendor) {
    selectedVendor = vendor;
    supplierController.text = vendor.name ?? '';
    currentSupplier.value = vendor.code ?? '';
  }

  void applySingle() {
    if (selectedVendor != null) {
      onApplySingle(selectedVendor!);
      Get.back();
    }
  }

  void applyAll() {
    if (selectedVendor != null) {
      onApplyAll(selectedVendor!);
      Get.back();
    }
  }
}
