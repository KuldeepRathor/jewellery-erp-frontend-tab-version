import 'dart:convert';

class ApprovalIssueRecordRequest {
  String? id;
  String? partyId;
  String? partyType;
  String? approverId;
  DateTime? approvalDate;
  String? approvalIssueNumber;
  dynamic receiptDate;
  String? remarks;
  List<LineItem>? lineItems;

  ApprovalIssueRecordRequest({
    this.id,
    this.partyId,
    this.partyType,
    this.approverId,
    this.approvalDate,
    this.approvalIssueNumber,
    this.receiptDate,
    this.remarks,
    this.lineItems,
  });

  factory ApprovalIssueRecordRequest.fromRawJson(String str) =>
      ApprovalIssueRecordRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApprovalIssueRecordRequest.fromJson(Map<String, dynamic> json) =>
      ApprovalIssueRecordRequest(
        id: json["id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        approverId: json["approver_id"],
        approvalDate: json["approval_date"] == null
            ? null
            : DateTime.parse(json["approval_date"]),
        approvalIssueNumber: json["approval_issue_number"],
        receiptDate: json["receipt_date"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "party_id": partyId,
        "party_type": partyType,
        "approver_id": approverId,
        "approval_date":
            "${approvalDate!.year.toString().padLeft(4, '0')}-${approvalDate!.month.toString().padLeft(2, '0')}-${approvalDate!.day.toString().padLeft(2, '0')}",
        "approval_issue_number": approvalIssueNumber,
        "receipt_date": receiptDate,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? id;
  String? approvalRecordId;
  dynamic approvalReceiptId;
  String? code;
  String? status;
  String? taggingId;
  String? tag;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? taggingVa;
  String? finalVa;
  String? taggingMc;
  String? finalMc;
  String? stoneCost;
  String? hallMark;
  String? discount;
  String? salesAmount;
  String? totalAmount;

  LineItem({
    this.id,
    this.approvalRecordId,
    this.approvalReceiptId,
    this.code,
    this.status,
    this.taggingId,
    this.tag,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.taggingVa,
    this.finalVa,
    this.taggingMc,
    this.finalMc,
    this.stoneCost,
    this.hallMark,
    this.discount,
    this.salesAmount,
    this.totalAmount,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        approvalRecordId: json["approval_record_id"],
        approvalReceiptId: json["approval_receipt_id"],
        code: json["code"],
        status: json["status"],
        taggingId: json["tagging_id"],
        tag: json["tag"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        taggingVa: json["tagging_va"],
        finalVa: json["final_va"],
        taggingMc: json["tagging_mc"],
        finalMc: json["final_mc"],
        stoneCost: json["stone_cost"],
        hallMark: json["hall_mark"],
        discount: json["discount"],
        salesAmount: json["sales_amount"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "approval_record_id": approvalRecordId,
        "approval_receipt_id": approvalReceiptId,
        "code": code,
        "status": status,
        "tagging_id": taggingId,
        "tag": tag,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "tagging_va": taggingVa,
        "final_va": finalVa,
        "tagging_mc": taggingMc,
        "final_mc": finalMc,
        "stone_cost": stoneCost,
        "hall_mark": hallMark,
        "discount": discount,
        "sales_amount": salesAmount,
        "total_amount": totalAmount,
      };
}
