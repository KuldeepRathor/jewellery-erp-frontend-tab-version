import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_invoice_vendor_bill_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view/purchase_return_payment_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_details/view_model/purchase_return_invoice_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class PurchaseReturnInvoiceDetailsScreen extends StatefulWidget {
  const PurchaseReturnInvoiceDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<PurchaseReturnInvoiceDetailsScreen> createState() =>
      _PurchaseReturnInvoiceDetailsScreenState();
}

class _PurchaseReturnInvoiceDetailsScreenState
    extends State<PurchaseReturnInvoiceDetailsScreen>
    with SingleTickerProviderStateMixin {
  final PurchaseReturnInvoiceInvoiceDeatilsController invoiceDetailsController =
      Get.put(PurchaseReturnInvoiceInvoiceDeatilsController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    invoiceDetailsController.getInvoiceDetailsById(id: widget.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: grey1,
        child: Obx(() {
          final response =
              invoiceDetailsController.getInvoiceDetailsResponse.value;
          if (response.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          } else if (response.status == Status.ERROR) {
            return Center(child: Text('Error: ${response.message}'));
          } else if (response.status == Status.COMPLETED &&
              response.data != null) {
            final data = response.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  header: 'Purchase Return',
                  wantBackButton: true,
                  onBackButtonTap: () {
                    SidebarController sidebarController = Get.find();
                    log("Popping values from ");
                    sidebarController.popBackSelectedWidget();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: PurchaseReturnInvoicePartyDetailsWidget(
                          partyDetails: {
                            'name': data.partyName ?? '',
                            'gstNumber': data.partyGst ?? '',
                            'addressLine1': data.partyAddress ?? '',
                            'type': data.partyType ?? '',
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: PurchaseReturnInvoiceVendorBillDetailsWidget(
                          invoiceNo: data.returnInvoiceNumber ?? '',
                          vendorInvoiceNo: data.returnInvoiceNumber ?? '',
                          invoiceCreated: convertDateTimeToString(
                            data.returnCreateDate,
                          ),
                          invoiceReceived: convertDateTimeToString(
                            data.returnReceiveDate,
                          ),
                          isVendor: data.partyType == "vendor",
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: primaryColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: primaryColor,
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: const [
                              Tab(text: 'Item Details'),
                              Tab(text: 'Payments'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                PurchaseReturnInvoiceItemDetailsWidget(
                                  lineItems: data.lineItems ?? [],
                                ),
                                PurchaseReturnPaymentDetailsWidget(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        }),
      ),
    );
  }
}
