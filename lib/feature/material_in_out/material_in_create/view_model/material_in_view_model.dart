import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_create/models/post_material_in_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/material_in_out/material_in_create/view_model/material_in_bill_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/item_details_widget_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/remarks_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class MaterialInViewModel extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();

  final materialInResponse = Rx<ApiResponse<MaterialInRequestModel>>(
    ApiResponse.initial('Empty data'),
  );
  MaterailInVendorBillDetailsController vendorBillDetailsController =
      Get.find<MaterailInVendorBillDetailsController>();

  Future<void> validateAndPostMaterialIn() async {
    materialInResponse.value = ApiResponse.loading("loading");
    MaterialInRequestModel materialInModel = getConvertedRequestModel();
    log("The material in details are: ${jsonEncode(materialInModel.toJson())}");

    try {
      final response = await inventoryRepository.addMaterialIn(materialInModel);
      clearAllControllers();
      showSuccessToast(message: 'Material In added successfully!');
      vendorBillDetailsController.fetchNextInvoiceNumber(
        invoiceType: 'material_in_number_vendor',
      );

      materialInResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in validateAndPostMaterialIn: $e \n $s");

      final handledError = handleDTOResponseErrors(e);
      materialInResponse.value = ApiResponse.error(handledError.message);
      showErrorToast(
        message: materialInResponse.value.message ?? "Something went wrong",
      );
    }
  }

  MaterialInRequestModel getConvertedRequestModel() {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();

    PartyDetailsController partyController = Get.find<PartyDetailsController>();
    RemarksController remarksController = Get.find<RemarksController>();

    // Convert item details to line items
    List<LineItem> lineItems =
        itemDetailsController.controllers
            .map(
              (element) => LineItem(
                amount: element.amount.text.trim(),
                code: element.code.text.trim(),
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
                ornamentId: element.codeId,
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
    MaterialInRequestModel materialInModel = MaterialInRequestModel(
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
      invoiceCreateDate: convertStringToDateTime(
        vendorBillDetailsController.invoiceCreatedController.text.trim(),
        formatSent: DateFormat('dd-MM-yyyy'),
      ),
      invoiceReceiveDate: convertStringToDateTime(
        vendorBillDetailsController.invoiceReceivedController.text.trim(),
        formatSent: DateFormat('dd-MM-yyyy'),
      ),
    );
    log("Material In Request Model: ${jsonEncode(materialInModel.toJson())}");
    return materialInModel;
  }

  void clearAllControllers() {
    ItemDetailsController itemDetailsController =
        Get.find<ItemDetailsController>();
    MaterailInVendorBillDetailsController vendorBillDetailsController =
        Get.find<MaterailInVendorBillDetailsController>();
    PartyDetailsController partyController = Get.find<PartyDetailsController>();
    RemarksController remarksController = Get.find<RemarksController>();

    itemDetailsController.clearControllers();
    vendorBillDetailsController.clearControllers();

    remarksController.purchaseReturnRemarks.value = "";

    partyController.selectedParty.value = null;
    partyController.searchController.value.text = "";
  }
}
