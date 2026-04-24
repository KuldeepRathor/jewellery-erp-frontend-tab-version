import 'dart:convert';

class GetPurchaseReturnDebitNoteResponse {
  List<GetPurchaseReturnDebitNoteValue>? values;

  GetPurchaseReturnDebitNoteResponse({
    this.values,
  });

  factory GetPurchaseReturnDebitNoteResponse.fromRawJson(String str) =>
      GetPurchaseReturnDebitNoteResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReturnDebitNoteResponse.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseReturnDebitNoteResponse(
        values: json["values"] == null
            ? []
            : List<GetPurchaseReturnDebitNoteValue>.from(json["values"]!
                .map((x) => GetPurchaseReturnDebitNoteValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetPurchaseReturnDebitNoteValue {
  DateTime? createdAt;
  String? id;
  DateTime? invoiceCreateDate;
  String? returnInvoiceNumber;
  String? remarks;
  bool? isConsumed;
  String? balance;

  GetPurchaseReturnDebitNoteValue({
    this.createdAt,
    this.id,
    this.invoiceCreateDate,
    this.returnInvoiceNumber,
    this.remarks,
    this.isConsumed,
    this.balance,
  });

  factory GetPurchaseReturnDebitNoteValue.fromRawJson(String str) =>
      GetPurchaseReturnDebitNoteValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseReturnDebitNoteValue.fromJson(Map<String, dynamic> json) =>
      GetPurchaseReturnDebitNoteValue(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        invoiceCreateDate: json["invoice_create_date"] == null
            ? null
            : DateTime.parse(json["invoice_create_date"]),
        returnInvoiceNumber: json["return_invoice_number"],
        remarks: json["remarks"],
        isConsumed: json["is_consumed"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "invoice_create_date":
            "${invoiceCreateDate!.year.toString().padLeft(4, '0')}-${invoiceCreateDate!.month.toString().padLeft(2, '0')}-${invoiceCreateDate!.day.toString().padLeft(2, '0')}",
        "return_invoice_number": returnInvoiceNumber,
        "remarks": remarks,
        "is_consumed": isConsumed,
        "balance": balance,
      };
}
