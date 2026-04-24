import 'dart:convert';

class PostJournalEntryRequest {
  String? organizationId;
  DateTime? date;
  String? voucherNumber;
  String? reference;
  List<PostJournalEntryRequestLineItem>? lineItems;

  PostJournalEntryRequest({
    this.organizationId,
    this.date,
    this.voucherNumber,
    this.reference,
    this.lineItems,
  });

  factory PostJournalEntryRequest.fromRawJson(String str) =>
      PostJournalEntryRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostJournalEntryRequest.fromJson(Map<String, dynamic> json) =>
      PostJournalEntryRequest(
        organizationId: json["organization_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        voucherNumber: json["voucher_number"],
        reference: json["reference"],
        lineItems: json["line_items"] == null
            ? []
            : List<PostJournalEntryRequestLineItem>.from(json["line_items"]!
                .map((x) => PostJournalEntryRequestLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "voucher_number": voucherNumber,
        "reference": reference,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class PostJournalEntryRequestLineItem {
  String? journalId;
  String? accountCode;
  String? accountName;
  double? debit;
  double? credit;
  String? remarks;

  PostJournalEntryRequestLineItem({
    this.journalId,
    this.accountCode,
    this.accountName,
    this.debit,
    this.credit,
    this.remarks,
  });

  factory PostJournalEntryRequestLineItem.fromRawJson(String str) =>
      PostJournalEntryRequestLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostJournalEntryRequestLineItem.fromJson(Map<String, dynamic> json) =>
      PostJournalEntryRequestLineItem(
        journalId: json["journal_id"],
        accountCode: json["account_code"],
        accountName: json["account_name"],
        debit: json["debit"],
        credit: json["credit"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "journal_id": journalId,
        "account_code": accountCode,
        "account_name": accountName,
        "debit": debit,
        "credit": credit,
        "remarks": remarks,
      };
}
