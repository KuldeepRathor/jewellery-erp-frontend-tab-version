import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/models/post_material_out_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_out_create/view_model/material_out_bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class MaterialOutViewModel extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  final materialOutResponse = Rx<ApiResponse<MaterialOutRequestModel>>(
    ApiResponse.initial('Empty data'),
  );

  ItemDetailsController itemDetailsController =
      Get.find<ItemDetailsController>();
  MaterialOutVendorBillDetailsController vendorBillDetailsController =
      Get.find<MaterialOutVendorBillDetailsController>();
  PartyDetailsController partyController = Get.put<PartyDetailsController>(
    PartyDetailsController(),
  );
  RemarksController remarksController = Get.find<RemarksController>();

  @override
  void onInit() {
    super.onInit();
    // Set up listener for party changes
    ever(partyController.selectedParty, (party) {
      if (party != null) {
        _updatePartyType(party);
      }
    });
  }

  // Update the party type when the party changes
  void _updatePartyType(dynamic party) {
    String partyType = "";
    if (party is CustomerSearchValue) {
      partyType = "customer";
    } else if (party is VendorSearchValue) {
      partyType = "vendor";
    }

    // Update the vendor bill details controller with the new party type
    if (partyType.isNotEmpty) {
      vendorBillDetailsController.setPartyType(partyType);
    }
  }

  Future<void> validateAndPostMaterialOut() async {
    // First validate the form
    if (!vendorBillDetailsController.validateBillDetails()) {
      showErrorToast(message: "Please fill all required bill details");
      return;
    }

    materialOutResponse.value = ApiResponse.loading("loading");
    MaterialOutRequestModel materialOutModel = getConvertedRequestModel();
    log(
      "The material Out details are: ${jsonEncode(materialOutModel.toJson())}",
    );

    try {
      final response = await inventoryRepository.addMaterialOut(
        materialOutModel,
      );
      clearAllControllers();
      showSuccessToast(message: 'Material Out added successfully!');
      vendorBillDetailsController.fetchNextInvoiceNumber();

      materialOutResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in validateAndPostMaterialOut: $e \n $s");

      final handledError = handleDTOResponseErrors(e);
      materialOutResponse.value = ApiResponse.error(handledError.message);
      showErrorToast(
        message: materialOutResponse.value.message ?? "Something went wrong",
      );
    }
  }

  MaterialOutRequestModel getConvertedRequestModel() {
    // Convert item details to line items
    List<LineItem> lineItems =
        itemDetailsController.controllers
            .map(
              (element) => LineItem(
                amount: element.amount.text.trim(),
                code: element.code.text.trim(),
                ornamentId: element.codeId,
                grossWeight: element.gwt.text.trim(),
                itemDescription: element.item_description.text.trim(),
                less:
                    element.less.text.trim().isEmpty
                        ? null
                        : element.less.text.trim(),
                mc:
                    element.mc.text.trim().isEmpty
                        ? null
                        : element.mc.text.trim(),
                netWeight: element.nwt.text.trim(),
                pieces: int.tryParse(element.pcs.text.trim()),
                rate: element.rate.text.trim(),
                stone:
                    element.stone.text.trim().isEmpty
                        ? null
                        : element.stone.text.trim(),
                va:
                    element.wst.text.trim().isEmpty
                        ? null
                        : element.wst.text.trim(),
              ),
            )
            .toList();

    String partyAddress = "";
    String partyCode = "";
    String? partyGst;
    String partyId = "";
    String partyName = "";
    String partyType = "";

    if (partyController.selectedParty.value is CustomerSearchValue) {
      final CustomerSearchValue customerDetails =
          partyController.selectedParty.value as CustomerSearchValue;

      partyAddress = customerDetails.address?.first.city ?? "";
      partyCode = ""; // Customers don't have codes in this system
      partyGst = customerDetails.gstNumber;
      partyId = customerDetails.id ?? '';
      partyName = customerDetails.name ?? "";
      partyType = "customer";
    } else if (partyController.selectedParty.value is VendorSearchValue) {
      final VendorSearchValue vendorDetails =
          partyController.selectedParty.value as VendorSearchValue;

      partyAddress =
          vendorDetails.address?.isNotEmpty ?? false
              ? vendorDetails.address?.first.city ?? ""
              : "";
      partyCode = vendorDetails.code ?? "";
      partyGst = vendorDetails.gstNumber;
      partyId = vendorDetails.id ?? '';
      partyName = vendorDetails.name ?? "";
      partyType = "vendor";
    }

    // Create the request model
    MaterialOutRequestModel materialOutModel = MaterialOutRequestModel(
      voucherType: vendorBillDetailsController.selectedSequence.value?.type,
      voucherSeriesId: vendorBillDetailsController.selectedSequence.value?.id,
      lineItems: lineItems,
      partyAddress: partyAddress,
      partyCode: partyCode,
      partyGst: partyGst,
      partyId: partyId,
      partyInvoiceNumber:
          vendorBillDetailsController.invoiceNoController.text.trim(),
      partyName: partyName,
      partyType: partyType,
      remark: remarksController.purchaseReturnRemarks.value,
    );
    log("Material Out Request Model: ${jsonEncode(materialOutModel.toJson())}");
    return materialOutModel;
  }

  void clearAllControllers() {
    itemDetailsController.clearControllers();
    vendorBillDetailsController.clearControllers();
    remarksController.purchaseReturnRemarks.value = "";
    partyController.selectedParty.value = null;
    partyController.searchController.value.text = "";
  }
}
