import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_address_model.dart';

class GetApprovalRecordByApprovalNumberResponse {
  String? id;
  String? partyId;
  String? partyType;
  PartyDetails? partyDetails;
  String? approverId;
  DateTime? approvalDate;
  String? approvalIssueNumber;
  dynamic receiptDate;
  String? remarks;
  List<GetApprovalRecordByApprovalNumberLineItem>? lineItems;

  GetApprovalRecordByApprovalNumberResponse({
    this.id,
    this.partyId,
    this.partyType,
    this.partyDetails,
    this.approverId,
    this.approvalDate,
    this.approvalIssueNumber,
    this.receiptDate,
    this.remarks,
    this.lineItems,
  });

  factory GetApprovalRecordByApprovalNumberResponse.fromRawJson(String str) =>
      GetApprovalRecordByApprovalNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalRecordByApprovalNumberResponse.fromJson(
    Map<String, dynamic> json,
  ) => GetApprovalRecordByApprovalNumberResponse(
    id: json["id"],
    partyId: json["party_id"],
    partyType: json["party_type"],
    partyDetails:
        json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
    approverId: json["approver_id"],
    approvalDate:
        json["approval_date"] == null
            ? null
            : DateTime.parse(json["approval_date"]),
    approvalIssueNumber: json["approval_issue_number"],
    receiptDate: json["receipt_date"],
    remarks: json["remarks"],
    lineItems:
        json["line_items"] == null
            ? []
            : List<GetApprovalRecordByApprovalNumberLineItem>.from(
              json["line_items"]!.map(
                (x) => GetApprovalRecordByApprovalNumberLineItem.fromJson(x),
              ),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "party_id": partyId,
    "party_type": partyType,
    "party_details": partyDetails?.toJson(),
    "approver_id": approverId,
    "approval_date":
        "${approvalDate!.year.toString().padLeft(4, '0')}-${approvalDate!.month.toString().padLeft(2, '0')}-${approvalDate!.day.toString().padLeft(2, '0')}",
    "approval_issue_number": approvalIssueNumber,
    "receipt_date": receiptDate,
    "remarks": remarks,
    "line_items":
        lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
  };
}

class GetApprovalRecordByApprovalNumberLineItem {
  String? id;
  String? approvalRecordId;
  dynamic ornamentId;
  dynamic approvalReceiptId;
  String? counter;
  String? stockHead;
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

  GetApprovalRecordByApprovalNumberLineItem({
    this.id,
    this.approvalRecordId,
    this.ornamentId,
    this.approvalReceiptId,
    this.counter,
    this.stockHead,
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

  factory GetApprovalRecordByApprovalNumberLineItem.fromRawJson(String str) =>
      GetApprovalRecordByApprovalNumberLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalRecordByApprovalNumberLineItem.fromJson(
    Map<String, dynamic> json,
  ) => GetApprovalRecordByApprovalNumberLineItem(
    id: json["id"],
    approvalRecordId: json["approval_record_id"],
    ornamentId: json["ornament_id"],
    approvalReceiptId: json["approval_receipt_id"],
    counter: json["counter"],
    stockHead: json["stock_head"],
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
    "ornament_id": ornamentId,
    "approval_receipt_id": approvalReceiptId,
    "counter": counter,
    "stock_head": stockHead,
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

class PartyDetails {
  String? id;
  String? syncId;
  String? readableId;
  String? phoneNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  dynamic aadhaarNumber;
  String? gstNumber;
  dynamic deductionType;
  dynamic deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  dynamic ledger;
  List<dynamic>? nominees;
  List<Address>? address;

  PartyDetails({
    this.id,
    this.syncId,
    this.readableId,
    this.phoneNumber,
    this.name,
    this.dateOfBirth,
    this.panNumber,
    this.aadhaarNumber,
    this.gstNumber,
    this.deductionType,
    this.deductionPercent,
    this.organizationId,
    this.addressUuid,
    this.gender,
    this.ledger,
    this.nominees,
    this.address,
  });

  factory PartyDetails.fromRawJson(String str) =>
      PartyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PartyDetails.fromJson(Map<String, dynamic> json) => PartyDetails(
    id: json["id"],
    syncId: json["sync_id"],
    readableId: json["readable_id"],
    phoneNumber: json["phone_number"],
    name: json["name"],
    dateOfBirth:
        json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
    panNumber: json["pan_number"],
    aadhaarNumber: json["aadhaar_number"],
    gstNumber: json["gst_number"],
    deductionType: json["deduction_type"],
    deductionPercent: json["deduction_percent"],
    organizationId: json["organization_id"],
    addressUuid: json["address_uuid"],
    gender: json["gender"],
    ledger: json["ledger"],
    nominees:
        json["nominees"] == null
            ? []
            : List<dynamic>.from(json["nominees"]!.map((x) => x)),
    address:
        json["address"] == null
            ? []
            : List<Address>.from(
              json["address"]!.map((x) => Address.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sync_id": syncId,
    "readable_id": readableId,
    "phone_number": phoneNumber,
    "name": name,
    "date_of_birth":
        "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "pan_number": panNumber,
    "aadhaar_number": aadhaarNumber,
    "gst_number": gstNumber,
    "deduction_type": deductionType,
    "deduction_percent": deductionPercent,
    "organization_id": organizationId,
    "address_uuid": addressUuid,
    "gender": gender,
    "ledger": ledger,
    "nominees":
        nominees == null ? [] : List<dynamic>.from(nominees!.map((x) => x)),
    "address":
        address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
  };
}
