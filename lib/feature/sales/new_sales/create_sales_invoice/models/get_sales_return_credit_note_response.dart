import 'dart:convert';

class GetSalesReturnCreditNoteResponse {
  List<GetSalesReturnCreditNoteValue>? values;

  GetSalesReturnCreditNoteResponse({
    this.values,
  });

  factory GetSalesReturnCreditNoteResponse.fromRawJson(String str) =>
      GetSalesReturnCreditNoteResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnCreditNoteResponse.fromJson(
          Map<String, dynamic> json) =>
      GetSalesReturnCreditNoteResponse(
        values: json["values"] == null
            ? []
            : List<GetSalesReturnCreditNoteValue>.from(json["values"]!
                .map((x) => GetSalesReturnCreditNoteValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetSalesReturnCreditNoteValue {
  DateTime? createdAt;
  String? id;
  DateTime? invoiceCreateDate;
  String? saleReturnNumber;
  String? remarks;
  bool? isConsumed;
  String? balance;

  GetSalesReturnCreditNoteValue({
    this.createdAt,
    this.id,
    this.invoiceCreateDate,
    this.saleReturnNumber,
    this.remarks,
    this.isConsumed,
    this.balance,
  });

  factory GetSalesReturnCreditNoteValue.fromRawJson(String str) =>
      GetSalesReturnCreditNoteValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesReturnCreditNoteValue.fromJson(Map<String, dynamic> json) =>
      GetSalesReturnCreditNoteValue(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        invoiceCreateDate: json["invoice_create_date"] == null
            ? null
            : DateTime.parse(json["invoice_create_date"]),
        saleReturnNumber: json["sale_return_number"],
        remarks: json["remarks"],
        isConsumed: json["is_consumed"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "invoice_create_date":
            "${invoiceCreateDate!.year.toString().padLeft(4, '0')}-${invoiceCreateDate!.month.toString().padLeft(2, '0')}-${invoiceCreateDate!.day.toString().padLeft(2, '0')}",
        "sale_return_number": saleReturnNumber,
        "remarks": remarks,
        "is_consumed": isConsumed,
        "balance": balance,
      };
}
