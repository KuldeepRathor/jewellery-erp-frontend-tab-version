import 'dart:convert';

class GetApprovalIssueByIdResponse {
  String? id;
  String? partyId;
  String? partyType;
  PartyDetails? partyDetails;
  String? approverId;
  String? approverName;
  DateTime? approvalDate;
  String? approvalIssueNumber;
  dynamic receiptDate;
  String? remarks;
  List<GetApprovalIssueByIdLineItem>? lineItems;

  GetApprovalIssueByIdResponse({
    this.id,
    this.partyId,
    this.partyType,
    this.partyDetails,
    this.approverId,
    this.approverName,
    this.approvalDate,
    this.approvalIssueNumber,
    this.receiptDate,
    this.remarks,
    this.lineItems,
  });

  factory GetApprovalIssueByIdResponse.fromRawJson(String str) =>
      GetApprovalIssueByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalIssueByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetApprovalIssueByIdResponse(
        id: json["id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyDetails: json["party_details"] == null
            ? null
            : PartyDetails.fromJson(json["party_details"]),
        approverId: json["approver_id"],
        approverName: json["approver_name"],
        approvalDate: json["approval_date"] == null
            ? null
            : DateTime.parse(json["approval_date"]),
        approvalIssueNumber: json["approval_issue_number"],
        receiptDate: json["receipt_date"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<GetApprovalIssueByIdLineItem>.from(json["line_items"]!
                .map((x) => GetApprovalIssueByIdLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "party_id": partyId,
        "party_type": partyType,
        "party_details": partyDetails?.toJson(),
        "approver_id": approverId,
        "approver_name": approverName,
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

class GetApprovalIssueByIdLineItem {
  String? id;
  String? approvalRecordId;
  dynamic ornamentId;
  String? approvalReceiptId;
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

  GetApprovalIssueByIdLineItem({
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

  factory GetApprovalIssueByIdLineItem.fromRawJson(String str) =>
      GetApprovalIssueByIdLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetApprovalIssueByIdLineItem.fromJson(Map<String, dynamic> json) =>
      GetApprovalIssueByIdLineItem(
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
  dynamic dateOfBirth;
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
  dynamic signUpSource;
  dynamic email;

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
    this.signUpSource,
    this.email,
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
        dateOfBirth: json["date_of_birth"],
        panNumber: json["pan_number"],
        aadhaarNumber: json["aadhaar_number"],
        gstNumber: json["gst_number"],
        deductionType: json["deduction_type"],
        deductionPercent: json["deduction_percent"],
        organizationId: json["organization_id"],
        addressUuid: json["address_uuid"],
        gender: json["gender"],
        ledger: json["ledger"],
        nominees: json["nominees"] == null
            ? []
            : List<dynamic>.from(json["nominees"]!.map((x) => x)),
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
        signUpSource: json["sign_up_source"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sync_id": syncId,
        "readable_id": readableId,
        "phone_number": phoneNumber,
        "name": name,
        "date_of_birth": dateOfBirth,
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
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "sign_up_source": signUpSource,
        "email": email,
      };
}

class Address {
  String? id;
  String? organizationId;
  bool? isDefault;
  bool? isJlAddress;
  String? type;
  dynamic gstNumber;
  String? phoneNumber;
  String? phoneCountryCode;
  dynamic firstName;
  dynamic lastName;
  dynamic country;
  String? state;
  String? city;
  String? pincode;
  String? addressLine1;
  String? addressLine2;
  String? linkedEntityType;
  String? linkedEntityId;
  dynamic nickname;
  dynamic longitude;
  dynamic latitude;

  Address({
    this.id,
    this.organizationId,
    this.isDefault,
    this.isJlAddress,
    this.type,
    this.gstNumber,
    this.phoneNumber,
    this.phoneCountryCode,
    this.firstName,
    this.lastName,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.addressLine1,
    this.addressLine2,
    this.linkedEntityType,
    this.linkedEntityId,
    this.nickname,
    this.longitude,
    this.latitude,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        organizationId: json["organization_id"],
        isDefault: json["is_default"],
        isJlAddress: json["is_jl_address"],
        type: json["type"],
        gstNumber: json["gst_number"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        pincode: json["pincode"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        linkedEntityType: json["linked_entity_type"],
        linkedEntityId: json["linked_entity_id"],
        nickname: json["nickname"],
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "is_default": isDefault,
        "is_jl_address": isJlAddress,
        "type": type,
        "gst_number": gstNumber,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
        "first_name": firstName,
        "last_name": lastName,
        "country": country,
        "state": state,
        "city": city,
        "pincode": pincode,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "linked_entity_type": linkedEntityType,
        "linked_entity_id": linkedEntityId,
        "nickname": nickname,
        "longitude": longitude,
        "latitude": latitude,
      };
}
