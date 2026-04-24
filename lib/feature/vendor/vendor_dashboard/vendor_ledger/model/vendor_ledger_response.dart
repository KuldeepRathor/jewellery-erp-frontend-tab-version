import 'dart:convert';

class VendorLedgerResponse {
  List<VendorLedgerResponseValue>? values;

  VendorLedgerResponse({
    this.values,
  });

  factory VendorLedgerResponse.fromRawJson(String str) =>
      VendorLedgerResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VendorLedgerResponse.fromJson(Map<String, dynamic> json) =>
      VendorLedgerResponse(
        values: json["values"] == null
            ? []
            : List<VendorLedgerResponseValue>.from(json["values"]!
                .map((x) => VendorLedgerResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class VendorLedgerResponseValue {
  String? id;
  DateTime? invoiceDate;
  String? type;
  String? description;
  String? weight;
  String? invoiceNumber;
  String? sgst;
  String? cgst;
  String? igst;
  String? tds;
  String? tcs;
  String? dr;
  String? cr;
  String? balanceAmount;

  VendorLedgerResponseValue({
    this.id,
    this.invoiceDate,
    this.type,
    this.description,
    this.weight,
    this.invoiceNumber,
    this.sgst,
    this.cgst,
    this.igst,
    this.tds,
    this.tcs,
    this.dr,
    this.cr,
    this.balanceAmount,
  });

  factory VendorLedgerResponseValue.fromRawJson(String str) =>
      VendorLedgerResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VendorLedgerResponseValue.fromJson(Map<String, dynamic> json) =>
      VendorLedgerResponseValue(
        id: json["id"],
        invoiceDate: json["invoice_date"] == null
            ? null
            : DateTime.parse(json["invoice_date"]),
        type: json["type"],
        description: json["description"],
        weight: json["weight"],
        invoiceNumber: json["invoice_number"],
        sgst: json["sgst"],
        cgst: json["cgst"],
        igst: json["igst"],
        tds: json["tds"],
        tcs: json["tcs"],
        dr: json["Dr"],
        cr: json["Cr"],
        balanceAmount: json["balance_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_date":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "type": type,
        "description": description,
        "weight": weight,
        "invoice_number": invoiceNumber,
        "sgst": sgst,
        "cgst": cgst,
        "igst": igst,
        "tds": tds,
        "tcs": tcs,
        "Dr": dr,
        "Cr": cr,
        "balance_amount": balanceAmount,
      };
}
