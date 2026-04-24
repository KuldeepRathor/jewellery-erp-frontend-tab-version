import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/controllers/user_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_dashboard/view/customer_dashboard_view.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view/header_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_order_item_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/model/get_webstore_order_detail_by_id.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view/widgets/order_details_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/web_store/web_store_orders/view_model/webstore_orders_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/action_scope_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/linewise_custom_table_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_button2.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';
import 'package:printing/printing.dart';
import 'package:svg_flutter/svg_flutter.dart';

class WebStoreOrdersPage extends StatefulWidget {
  const WebStoreOrdersPage({super.key});

  @override
  State<WebStoreOrdersPage> createState() => _WebStoreOrdersPageState();
}

class _WebStoreOrdersPageState extends State<WebStoreOrdersPage> {
  final controller = Get.put<WebStoreOrdersViewModel>(
    WebStoreOrdersViewModel(),
  );
  final SidebarController sidebarController = Get.find<SidebarController>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.setInitialConditions(isSearch: false);
    controller.getWebStoreOrderListing(resetList: true);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controllerCreation =
    //     Get.create<WebstoreOrdersViewModel>(() => WebstoreOrdersViewModel());
    // final controller = Get.find<WebstoreOrdersViewModel>();

    return Scaffold(
      backgroundColor: grey1,
      body: ActionScopeWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(header: 'Orders'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildActionBar(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Stack(
                        children: [
                          _buildVendorTable(controller),
                          Obx(
                            () => AnimatedPositioned(
                              right:
                                  controller.isDrawerVisible.value
                                      ? 0
                                      : (MediaQuery.of(context).size.width *
                                              0.26) *
                                          -1,
                              top: 0,
                              bottom: 0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInCubic,
                              child: const OrderDetailsScreen(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/filter.svg',
          buttonName: 'Filter',
        ),
        const SizedBox(width: 16),
        CustomButton2(
          onTap: () {},
          image: 'assets/svgs/download.svg',
          buttonName: 'Download',
        ),
        const Spacer(),
        // CustomButton2(
        //   onTap: () {
        //     Get.dialog(
        //       const AddVendorDialog(),
        //     );
        //   },
        //   image: 'assets/svgs/add.svg',
        //   buttonName: 'Add New Vendor',
        // ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        autofocus: true,
        onChanged: controller.setSeachQuery,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(color: greyTextColor),
          suffixIcon: Icon(Icons.search, size: 16),
        ),
      ),
    );
  }

  Widget _buildVendorTable(WebStoreOrdersViewModel controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Orders Listing",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final apiStatus =
                    controller.getWebStoreListingResponse.value.status;

                if (apiStatus == Status.COMPLETED) {
                  final data = controller.getWebStoreListingResponse.value.data;
                  if (data?.values?.isEmpty ?? true) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: LineWiseCustomTable(
                            headers: controller.headers.toList(),
                            columnWidths: controller.columnWidths.toList(),
                            itemCount: 0,
                            buildRow:
                                (context, index, totalWidth) =>
                                    const SizedBox(),
                            isLoadingMore: false,
                            addBottomSpace: false,
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/svgs/error/no_records_found.svg',
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return LineWiseCustomTable(
                    headers: controller.headers.toList(),
                    columnWidths: controller.columnWidths.toList(),
                    itemCount: data?.values?.length ?? 0,
                    controller: _scrollController,
                    isLoadingMore: controller.isLoadingMore.value,
                    buildRow: (context, index, totalWidth) {
                      final headerValue = data?.values?.elementAt(index);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          focusColor: greyTextColor,
                          onTap: () {
                            controller.showItemDetails(
                              index: headerValue?.id ?? "",
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: List.generate(controller.headers.length, (
                                cellIndex,
                              ) {
                                String cellContent = "-";
                                switch (cellIndex) {
                                  case 0:
                                    cellContent = "${index + 1}";
                                    break;
                                  case 1:
                                    cellContent = convertDateTimeToString(
                                      headerValue?.date ?? DateTime.now(),
                                    );
                                    break;
                                  case 2:
                                    cellContent =
                                        headerValue?.orderNumber ?? "-";
                                    return InkWell(
                                      onTap: () async {
                                        await controller.showItemDetails(
                                          index: headerValue?.id ?? "",
                                        );
                                        setState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: getColumnWidthForSingleTableCell(
                                          totalWidth: totalWidth,
                                          columnWidth:
                                              controller
                                                  .columnWidths[cellIndex],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: CustomText(
                                            text: cellContent,
                                            fontSize: 16,
                                            color: secondaryColor,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );

                                  case 3:
                                    cellContent =
                                        headerValue?.customerName ?? "";
                                    return InkWell(
                                      onTap: () {
                                        SidebarController sidebarController =
                                            Get.find();
                                        sidebarController.navigateToWidget(
                                          newChild: CustomerDashboardView(
                                            customerId:
                                                headerValue?.customerId ?? "",
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: getColumnWidthForSingleTableCell(
                                          totalWidth: totalWidth,
                                          columnWidth:
                                              controller
                                                  .columnWidths[cellIndex],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: CustomText(
                                            text: cellContent,
                                            fontSize: 16,
                                            color: secondaryColor,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );

                                  case 4:
                                    cellContent =
                                        "${headerValue?.shippingAddress?.city ?? "-"},"
                                        " ${headerValue?.shippingAddress?.state ?? ""},"
                                        " ${headerValue?.shippingAddress?.pincode ?? ""}";
                                    break;
                                  case 5:
                                    cellContent =
                                        headerValue?.totalWeight ??
                                        "-"; // Credit
                                    break;
                                  case 6:
                                    cellContent =
                                        headerValue?.paidAmount ?? "-"; // Debit
                                    break;

                                  case 7:
                                    cellContent =
                                        headerValue?.status ??
                                        "-"; // Material In
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomText(
                                          text: cellContent,
                                          fontSize: 16,
                                          color:
                                              headerValue?.status == "Delivered"
                                                  ? greenColor
                                                  : headerValue?.status ==
                                                      "In Progress"
                                                  ? primaryColor
                                                  : headerValue?.status ==
                                                      "Shipped"
                                                  ? secondaryColor
                                                  : headerValue?.status ==
                                                      "Cancelled"
                                                  ? tertiaryColor
                                                  : headerValue?.status ==
                                                      "Returned"
                                                  ? redTextColor
                                                  : secondaryColor,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  case 8:
                                    cellContent = headerValue?.invoiceNo ?? "-";
                                    return InkWell(
                                      onTap: () async {
                                        await controller.getWebStoreInvoicePdf(
                                          headerValue?.invoiceId ?? "",
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: getColumnWidthForSingleTableCell(
                                          totalWidth: totalWidth,
                                          columnWidth:
                                              controller
                                                  .columnWidths[cellIndex],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          child: CustomText(
                                            text: cellContent,
                                            fontSize: 16,
                                            color: secondaryColor,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  case 9:
                                    return InkWell(
                                      onTap: () async {
                                        if (headerValue != null) {
                                          commonMethodToGeneratePdf(
                                            headerValue,
                                          );
                                        }
                                      },
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.print,
                                          color: secondaryColor,
                                        ),
                                      ),
                                    );

                                  case 10:
                                    return _buildActionMenu(headerValue);
                                  default:
                                    cellContent = "-";
                                }

                                return SizedBox(
                                  width: getColumnWidthForSingleTableCell(
                                    totalWidth: totalWidth,
                                    columnWidth:
                                        controller.columnWidths[cellIndex],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: Tooltip(
                                      message: cellContent,
                                      child: CustomText(
                                        text: cellContent,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (apiStatus == Status.LOADING) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: LineWiseCustomTable(
                          headers: controller.headers.toList(),
                          columnWidths: controller.columnWidths.toList(),
                          itemCount: 0,
                          buildRow:
                              (context, index, totalWidth) => const SizedBox(),
                          addBottomSpace: false,
                        ),
                      ),
                      const Expanded(
                        flex: 14,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  );
                } else if (apiStatus == Status.ERROR) {
                  return Column(
                    children: [
                      Expanded(
                        child: LineWiseCustomTable(
                          headers: controller.headers.toList(),
                          columnWidths: controller.columnWidths.toList(),
                          itemCount: 0,
                          buildRow:
                              (context, index, totalWidth) => const SizedBox(),
                          addBottomSpace: false,
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Center(
                          child: Text(
                            controller
                                    .getWebStoreListingResponse
                                    .value
                                    .message ??
                                "Something went wrong",
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              }),
            ),
          ),
        ],
      ),
    );
  }

  void commonMethodToGeneratePdf(
    GetWebStoreOrdersListResponse headerValue,
  ) async {
    await controller.getWebStoreOrderDetail(headerValue.id ?? "");

    ApiResponse<WebStoreOrderDetailByIdResponse> pdfDataToShow =
        controller.getWebStoreOrderResponseById.value;

    final UserController userController = Get.find<UserController>();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Top Row: Sender + Logo
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Sender:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          userController.userData.value?.organizationName ?? "",
                        ),
                        pw.Text(
                          userController.userData.value?.branchAddressLine1 ??
                              "",
                        ),
                        pw.Text(
                          userController.userData.value?.branchAddressLine2 ??
                              "",
                        ),
                        pw.Text(
                          userController.userData.value?.branchCity ?? "",
                        ),
                        pw.Text(
                          userController.userData.value?.branchCountry ?? "",
                        ),
                        pw.Text(
                          'Tel. ${pdfDataToShow.data?.shippingAddress?.phoneCountryCode ?? ""} ${pdfDataToShow.data?.shippingAddress?.phoneNumber ?? ""}',
                        ),
                      ],
                    ),
                    pw.Container(
                      width: 60,
                      height: 60,
                      child: pw.Center(
                        child: pw.Text(
                          'LOGO',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 16),
                pw.Divider(),

                pw.SizedBox(height: 16),
                // Receiver Address
                pw.Text(
                  '${headerValue.shippingAddress?.firstName ?? "-"} ${headerValue.shippingAddress?.lastName ?? ""}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(headerValue.shippingAddress?.addressLine1 ?? ""),
                pw.Text(headerValue.shippingAddress?.addressLine2 ?? ""),
                pw.Text(headerValue.shippingAddress?.city ?? ""),
                pw.Text(headerValue.shippingAddress?.state ?? ""),
                pw.Text(headerValue.shippingAddress?.country ?? ""),

                pw.SizedBox(height: 24),
                pw.Divider(),

                pw.SizedBox(height: 8),
                // Order Details Row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Order No:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text('${pdfDataToShow.data?.webstoreOrderNumber}'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Item Name:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '${pdfDataToShow.data?.lineItem?.itemDescription}',
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Weight:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text('${pdfDataToShow.data?.lineItem?.grossWeight}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Widget _buildActionMenu(GetWebStoreOrdersListResponse? headerValue) {
    return Theme(
      data: ThemeData(
        focusColor: greyTextColor,
        tooltipTheme: const TooltipThemeData(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
      child: CustomPopupMenuButtonWidget<String>(
        icon: const Icon(Icons.more_vert),
        itemBuilder:
            (BuildContext context) =>
                headerValue!.statusDropdown!.map((element) {
                  return PopupMenuItem<String>(
                    value: element.status ?? "",
                    height: 0,
                    child: SizedBox(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            element.status ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // ignore: unrelated_type_equality_checks
                          if (element !=
                              controller
                                  .getStatusListingForWebStoreItemResponse
                                  .value
                                  .data
                                  ?.last)
                            CustomDashedLineWidget(width: Get.width),
                        ],
                      ),
                    ),
                  );
                }).toList(),
        onSelected: (String value) {
          switch (value) {
            case 'Ship':
              controller.markAsShipped(headerValue!);

              break;
            case 'Return':
              controller.onReturnTapped(headerValue!);
              break;
            case 'Deliver':
              controller.onDeliveryTapped(headerValue!);
              break;
            case 'Cancel':
              controller.onCancelTapped(headerValue!);
              break;
          }
        },
      ),
    );
  }
}
