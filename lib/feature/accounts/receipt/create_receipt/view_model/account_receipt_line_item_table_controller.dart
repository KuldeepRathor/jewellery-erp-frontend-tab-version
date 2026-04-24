import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/payments/create_payments/models/get_party_details_by_ledger_id_response.dart';

class AccountsReceiptLineItemData {
  String? id;
  final String invoiceDate;
  final String invoiceAmount;
  final String invoiceNumber;
  final String balance;
  final String remarks;
  final String invoiceType;

  AccountsReceiptLineItemData({
    this.id,
    required this.invoiceDate,
    required this.invoiceAmount,
    required this.invoiceNumber,
    required this.balance,
    required this.remarks,
    required this.invoiceType,
  });

  // Factory constructor to create from GetPartyDetailsByLedgerResponseDetail
  factory AccountsReceiptLineItemData.fromPartyDetail(
    GetPartyDetailsByLedgerResponseDetail detail,
  ) {
    String formattedDate = '-';
    if (detail.invoiceDate != null) {
      formattedDate = DateFormat(
        'dd/MM/yyyy',
      ).format(detail.invoiceDate!.toLocal());
    }
    return AccountsReceiptLineItemData(
      id: detail.invoiceId,
      invoiceDate: formattedDate,
      invoiceAmount: detail.invoiceAmount ?? '0.00',
      invoiceNumber: detail.invoiceNumber ?? '-',
      balance: detail.balanceAmount ?? '0.00',
      remarks: detail.remarks ?? '-',
      invoiceType: detail.invoiceType ?? "",
    );
  }
}

class AccountsReceiptLineItemController extends GetxController {
  final headers = [
    'Sn',
    'Invoice Date',
    'Invoice Amount',
    'Invoice Number',
    'Balance',
    'Remarks',
  ];

  final columnWidths = [
    0.2, // Sn
    0.66, // Invoice Date
    0.66, // Invoice Amount
    0.66, // Invoice Number
    0.66, // Balance
    0.86, // Remarks
  ];

  final RxList<AccountsReceiptLineItemData> items =
      <AccountsReceiptLineItemData>[
        // AccountsPaymentLineItemData(
        //   invoiceDate: '2024-01-15',
        //   invoiceAmount: '5000.00',
        //   invoiceNumber: 'INV-0011',
        //   balance: '2000.00',
        //   remarks: 'Partial payment pending',
        // ),
      ].obs;

  final RxList<String> totalHeadersValue =
      <String>["Total", "", "", "", "", ""].obs;

  void updateItemsFromResponse(GetPartyDetailsByLedgerResponse response) {
    List<AccountsReceiptLineItemData> newItems = [];

    // Add purchase details
    if (response.purchaseReturnDetails != null) {
      newItems.addAll(
        response.purchaseReturnDetails!.map(
          (detail) => AccountsReceiptLineItemData.fromPartyDetail(detail),
        ),
      );
    }

    // Add sales return details
    if (response.salesDetails != null) {
      newItems.addAll(
        response.salesDetails!.map(
          (detail) => AccountsReceiptLineItemData.fromPartyDetail(detail),
        ),
      );
    }

    // Sort by invoice date
    newItems.sort((a, b) => a.invoiceDate.compareTo(b.invoiceDate));

    // Update the items list
    items.value = newItems;
    items.refresh();

    // Update totals after populating items
    updateTotals();
  }

  void updateTotals() {
    double totalInvoiceAmount = 0;
    double totalBalance = 0;

    for (var item in items) {
      totalInvoiceAmount += double.tryParse(item.invoiceAmount) ?? 0;
      totalBalance += double.tryParse(item.balance) ?? 0;
    }

    totalHeadersValue.value = [
      "Total",
      "",
      totalInvoiceAmount.toStringAsFixed(2),
      "",
      totalBalance.toStringAsFixed(2),
      "",
    ];
  }

  void clearItems() {
    items.clear();
    updateTotals();
  }
}
