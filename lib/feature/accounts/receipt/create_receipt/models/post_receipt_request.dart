import 'dart:convert';

class PostReceiptRequest {
  String? organizationId;
  String? shopId;
  String? paymentReceiptNumber;
  DateTime? date;
  double? amount;
  double? roundOff;
  double? bankCharges;
  double? total;
  double? tcs;
  double? tds;
  double? nett;
  String? partyId;
  String? partyType;
  List<PostReceiptRequestLineItem>? lineItems;

  PostReceiptRequest({
    this.organizationId,
    this.shopId,
    this.paymentReceiptNumber,
    this.date,
    this.amount,
    this.roundOff,
    this.bankCharges,
    this.total,
    this.tcs,
    this.tds,
    this.nett,
    this.partyId,
    this.partyType,
    this.lineItems,
  });

  factory PostReceiptRequest.fromRawJson(String str) =>
      PostReceiptRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostReceiptRequest.fromJson(Map<String, dynamic> json) =>
      PostReceiptRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        paymentReceiptNumber: json["payment_receipt_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        roundOff: json["round_off"],
        bankCharges: json["bank_charges"],
        total: json["total"],
        tcs: json["tcs"],
        tds: json["tds"],
        nett: json["nett"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        lineItems: json["line_items"] == null
            ? []
            : List<PostReceiptRequestLineItem>.from(json["line_items"]!
                .map((x) => PostReceiptRequestLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "payment_receipt_number": paymentReceiptNumber,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "round_off": roundOff,
        "bank_charges": bankCharges,
        "total": total,
        "tcs": tcs,
        "tds": tds,
        "nett": nett,
        "party_id": partyId,
        "party_type": partyType,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class PostReceiptRequestLineItem {
  double? amount;
  String? method;
  DateTime? date;
  String? transactionType;
  String? transactionCode;
  String? invoiceNumber;
  String? invoiceType;
  String? invoiceId;
  String? remarks;
  String? saleReturnId;
  String? posAccountId;

  PostReceiptRequestLineItem({
    this.amount,
    this.method,
    this.date,
    this.transactionType,
    this.transactionCode,
    this.invoiceNumber,
    this.invoiceType,
    this.invoiceId,
    this.remarks,
    this.saleReturnId,
    this.posAccountId,
  });

  factory PostReceiptRequestLineItem.fromRawJson(String str) =>
      PostReceiptRequestLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostReceiptRequestLineItem.fromJson(Map<String, dynamic> json) =>
      PostReceiptRequestLineItem(
        amount: json["amount"],
        method: json["method"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        transactionType: json["transaction_type"],
        transactionCode: json["transaction_code"],
        invoiceNumber: json["invoice_number"],
        invoiceType: json["invoice_type"],
        invoiceId: json["invoice_id"],
        remarks: json["remarks"],
        saleReturnId: json["sale_return_id"],
        posAccountId: json["pos_account_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "method": method,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "transaction_type": transactionType,
        "transaction_code": transactionCode,
        "invoice_number": invoiceNumber,
        "invoice_type": invoiceType,
        "invoice_id": invoiceId,
        "remarks": remarks,
        "sale_return_id": saleReturnId,
        "pos_account_id": posAccountId,
      };
}
