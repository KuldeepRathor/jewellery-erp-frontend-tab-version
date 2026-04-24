import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_components/balance_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_components/bank_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view/add_vendor_components/gst_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/button_shortcut_widget.dart';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/view_model/add_vendor_tabbar_controller.dart';

class AddVendorDialog extends StatefulWidget {
  const AddVendorDialog({super.key, this.vendorId});
  final String? vendorId;

  @override
  State<AddVendorDialog> createState() => _AddVendorDialogState();
}

class _AddVendorDialogState extends State<AddVendorDialog> {
  final controller = Get.put<AddVendorTabController>(AddVendorTabController());
  @override
  void initState() {
    super.initState();
    if (widget.vendorId != null) {
      controller.getVendorById(widget.vendorId ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    // Get.create<AddVendorTabController>(() => AddVendorTabController());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: Get.height * .9,
        width: Get.width * .675,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller),
            Expanded(
              child:
                  widget.vendorId == null
                      ? getDialogStates()
                      : Obx(() => getDialogStates()),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDialogStates() {
    if (widget.vendorId == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  Obx(
                    () => GSTDetailsWidget(
                      formKey: controller.formKey,
                      gstKey: controller.gstFieldKey,
                      gstController: controller.gstController,
                      codeController: controller.codeController,
                      storeNameController: controller.storeNameController,
                      address1Controller: controller.address1Controller,
                      address2Controller: controller.address2Controller,
                      cityController: controller.cityController,
                      pinCodeController: controller.pinCodeController,
                      panController: controller.panController,
                      percentageController: controller.percentageController,
                      selectedVendorTypes: controller.selectedVendorTypes,
                      // selectedLedgers: controller.selectedLedgers.value,
                      selectedDeduction: controller.selectedDeduction.value,
                      deductionItems: controller.deductionItems,
                      onVendorTypeChanged: controller.updateSelectedVendorTypes,
                      onLedgerChanged: controller.onLedgerChanged,
                      onDeductionChanged: controller.onDeductionChanged,
                      isLoading: controller.isLoading.value,
                      detailsFetched: controller.detailsFetched.value,
                      fetchGSTDetails: controller.fetchGSTDetails,
                      ledgerController: controller.ledgerController,
                    ),
                  ),
                  BalanceDetailsWidget(
                    formKey: controller.balanceFormKey,
                    openingBalanceCreditController:
                        controller.openingBalanceCreditController,
                    openingBalanceDebitController:
                        controller.openingBalanceDebitController,
                    openingWeightCreditController:
                        controller.openingWeightCreditController,
                    openingWeightDebitController:
                        controller.openingWeightDebitController,
                    closingBalanceCreditController:
                        controller.closingBalanceCreditController,
                    closingWeightDebitController:
                        controller.closingWeightDebitController,
                  ),
                  BankDetailsWidget(
                    formKey: controller.bankFormKey,
                    accountNameController: controller.accountNameController,
                    accountNumberController: controller.accountNumberController,
                    ifscController: controller.ifscController,
                    vendorId: widget.vendorId,
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(controller),
        ],
      );
    } else {
      if (controller.getVendorResponseById.value.status == Status.COMPLETED) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    Obx(
                      () => GSTDetailsWidget(
                        formKey: controller.formKey,
                        gstKey: controller.gstFieldKey,
                        gstController: controller.gstController,
                        codeController: controller.codeController,
                        storeNameController: controller.storeNameController,
                        address1Controller: controller.address1Controller,
                        address2Controller: controller.address2Controller,
                        cityController: controller.cityController,
                        pinCodeController: controller.pinCodeController,
                        panController: controller.panController,
                        percentageController: controller.percentageController,
                        selectedVendorTypes: controller.selectedVendorTypes,
                        // selectedLedgers: controller.selectedLedgers.value,
                        selectedDeduction: controller.selectedDeduction.value,
                        deductionItems: controller.deductionItems,
                        onVendorTypeChanged:
                            controller.updateSelectedVendorTypes,
                        onLedgerChanged: controller.onLedgerChanged,
                        onDeductionChanged: controller.onDeductionChanged,
                        isLoading: controller.isLoading.value,
                        detailsFetched: controller.detailsFetched.value,
                        fetchGSTDetails: controller.fetchGSTDetails,
                        vendorId: widget.vendorId,
                        ledgerController: controller.ledgerController,
                      ),
                    ),
                    BalanceDetailsWidget(
                      formKey: controller.balanceFormKey,
                      openingBalanceCreditController:
                          controller.openingBalanceCreditController,
                      openingBalanceDebitController:
                          controller.openingBalanceDebitController,
                      openingWeightCreditController:
                          controller.openingWeightCreditController,
                      openingWeightDebitController:
                          controller.openingWeightDebitController,
                      closingBalanceCreditController:
                          controller.closingBalanceCreditController,
                      closingWeightDebitController:
                          controller.closingWeightDebitController,
                    ),
                    BankDetailsWidget(
                      formKey: controller.bankFormKey,
                      accountNameController: controller.accountNameController,
                      accountNumberController:
                          controller.accountNumberController,
                      ifscController: controller.ifscController,
                      vendorId: widget.vendorId,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(controller),
          ],
        );
      } else if (controller.getVendorResponseById.value.status ==
          Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.getVendorResponseById.value.status ==
          Status.ERROR) {
        return Center(
          child: Text(
            controller.getVendorResponseById.value.message ??
                "Something went wrong",
          ),
        );
      } else {
        return Container(height: 10, width: 10, color: Colors.red);
      }
    }
  }

  Widget _buildHeader(AddVendorTabController controller) {
    return Container(
      height: 100,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Add Vendor',
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
          TabBar(
            controller: controller.tabController,
            isScrollable: true,
            labelColor: primaryColor,
            tabAlignment: TabAlignment.start,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            onTap: (value) => controller.tabController.index = value,
            tabs: [
              _buildTab("GST Details", 0, controller),
              _buildTab("Balance Details", 1, controller),
              _buildTab("Bank Details", 2, controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index, AddVendorTabController controller) {
    return Obx(
      () => Tab(
        child: CustomText(
          text: text,
          fontWeight: FontWeight.w400,
          color: controller.currentIndex.value == index ? primaryColor : null,
        ),
      ),
    );
  }

  Widget _buildFooter(AddVendorTabController controller) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            spreadRadius: 0.5,
            offset: Offset(0, 1.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.nextTab(widget.vendorId),
              borderRadius: BorderRadius.circular(8),
              child: Ink(
                // color: primaryColor,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 38,
                width: 140,
                child: Center(
                  child: Obx(
                    () =>
                        controller.addVendorResponse.value.status ==
                                Status.LOADING
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : ButtonShortcutWidget(
                              buttonName:
                                  controller.currentIndex.value == 2
                                      ? "Save"
                                      : "Next",
                              shortcut: "Ctrl + S",
                              buttonsize: 16,
                              color: whiteColor,
                              shortcutButtonColor: primaryColor,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
