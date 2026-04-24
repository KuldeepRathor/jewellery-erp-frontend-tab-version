import 'dart:convert';

class GetPurchaseRecordDropdownResponse {
  List<GetPurchaseRecordDropdownValue>? values;

  GetPurchaseRecordDropdownResponse({
    this.values,
  });

  factory GetPurchaseRecordDropdownResponse.fromRawJson(String str) =>
      GetPurchaseRecordDropdownResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseRecordDropdownResponse.fromJson(
          Map<String, dynamic> json) =>
      GetPurchaseRecordDropdownResponse(
        values: json["values"] == null
            ? []
            : List<GetPurchaseRecordDropdownValue>.from(json["values"]!
                .map((x) => GetPurchaseRecordDropdownValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetPurchaseRecordDropdownValue {
  String? id;
  String? partyType;
  String? partyId;
  String? partyName;
  String? invoiceNumber;

  GetPurchaseRecordDropdownValue({
    this.id,
    this.partyType,
    this.partyId,
    this.partyName,
    this.invoiceNumber,
  });

  factory GetPurchaseRecordDropdownValue.fromRawJson(String str) =>
      GetPurchaseRecordDropdownValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPurchaseRecordDropdownValue.fromJson(Map<String, dynamic> json) =>
      GetPurchaseRecordDropdownValue(
        id: json["id"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        invoiceNumber: json["invoice_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "party_type": partyType,
        "party_id": partyId,
        "party_name": partyName,
        "invoice_number": invoiceNumber,
      };
}
