import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/item_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/party_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/payment_details_widegt.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/vendor_bill_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view/view_estimate_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_details/view_model/invoice_deatils_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class InvoiceDetailsPage extends StatefulWidget {
  const InvoiceDetailsPage({super.key, required this.id});
  final String id;
  @override
  State<InvoiceDetailsPage> createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage>
    with SingleTickerProviderStateMixin {
  final InvoiceDeatilsController invoiceDetailsController = Get.put(
    InvoiceDeatilsController(),
  );
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                  header: 'Purchase',
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
                        child: PartyDetailsWidget(
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
                        child: VendorBillDetailsWidget(
                          invoiceNo: data.invoiceNumber ?? '',
                          vendorInvoiceNo: data.partyInvoiceNumber ?? '',
                          invoiceCreated: convertDateTimeToString(
                            data.invoiceCreateDate,
                          ),
                          invoiceReceived: convertDateTimeToString(
                            data.invoiceReceiveDate,
                          ),
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
                              Tab(text: 'View Estimate'),
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
                                ItemDetailsWidget(
                                  lineItems: data.lineItems ?? [],
                                ),
                                PurchasePaymentDetailsWidget(),
                                ViewEstimateWidget(),
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
