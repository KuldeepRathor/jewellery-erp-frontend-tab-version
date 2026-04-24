import 'dart:convert';

class CustomerBalancesAggregateResponse {
  List<CustomerBalancesAggregateResponseValue>? values;

  CustomerBalancesAggregateResponse({
    this.values,
  });

  factory CustomerBalancesAggregateResponse.fromRawJson(String str) =>
      CustomerBalancesAggregateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerBalancesAggregateResponse.fromJson(
          Map<String, dynamic> json) =>
      CustomerBalancesAggregateResponse(
        values: json["values"] == null
            ? []
            : List<CustomerBalancesAggregateResponseValue>.from(json["values"]!
                .map(
                    (x) => CustomerBalancesAggregateResponseValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class CustomerBalancesAggregateResponseValue {
  String? code;
  String? name;
  String? phoneNumber;
  String? invoiceNumber;
  DateTime? date;
  String? balanceAmount;
  DateTime? dueDate;
  String? status;
  String? remainingHandoverNetWeight;
  List<RemainingItem>? remainingItems;
  CustomerAddress? customerAddress;
  DateTime? paymentCompletionDate;
  String? paymentStatus;
  String? lastPaymentCode;
  String? lastUniversalPaymentCode;

  CustomerBalancesAggregateResponseValue({
    this.code,
    this.name,
    this.phoneNumber,
    this.invoiceNumber,
    this.date,
    this.balanceAmount,
    this.dueDate,
    this.status,
    this.remainingHandoverNetWeight,
    this.remainingItems,
    this.customerAddress,
    this.paymentCompletionDate,
    this.paymentStatus,
    this.lastPaymentCode,
    this.lastUniversalPaymentCode,
  });

  factory CustomerBalancesAggregateResponseValue.fromRawJson(String str) =>
      CustomerBalancesAggregateResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerBalancesAggregateResponseValue.fromJson(
          Map<String, dynamic> json) =>
      CustomerBalancesAggregateResponseValue(
        code: json["code"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        invoiceNumber: json["invoice_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        balanceAmount: json["balance_amount"],
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        status: json["status"],
        remainingHandoverNetWeight: json["remaining_handover_net_weight"],
        remainingItems: json["remaining_items"] == null
            ? []
            : List<RemainingItem>.from(
                json["remaining_items"]!.map((x) => RemainingItem.fromJson(x))),
        customerAddress: json["customer_address"] == null
            ? null
            : CustomerAddress.fromJson(json["customer_address"]),
        paymentCompletionDate: json["payment_completion_date"] == null
            ? null
            : DateTime.parse(json["payment_completion_date"]),
        paymentStatus: json["payment_status"],
        lastPaymentCode: json["last_payment_code"],
        lastUniversalPaymentCode: json["last_universal_payment_code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "phone_number": phoneNumber,
        "invoice_number": invoiceNumber,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "balance_amount": balanceAmount,
        "due_date":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "status": status,
        "remaining_handover_net_weight": remainingHandoverNetWeight,
        "remaining_items": remainingItems == null
            ? []
            : List<dynamic>.from(remainingItems!.map((x) => x.toJson())),
        "customer_address": customerAddress?.toJson(),
        "payment_completion_date":
            "${paymentCompletionDate!.year.toString().padLeft(4, '0')}-${paymentCompletionDate!.month.toString().padLeft(2, '0')}-${paymentCompletionDate!.day.toString().padLeft(2, '0')}",
        "last_payment_code": lastPaymentCode,
        "last_universal_payment_code": lastUniversalPaymentCode,
        "payment_status": paymentStatus,
      };
}

class CustomerAddress {
  String? id;
  String? syncId;
  String? readableId;
  String? phoneNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  dynamic aadhaarNumber;
  String? gstNumber;
  String? deductionType;
  String? deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  Ledger? ledger;
  List<dynamic>? nominees;
  List<Address>? address;
  String? signUpSource;
  String? email;

  CustomerAddress({
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

  factory CustomerAddress.fromRawJson(String str) =>
      CustomerAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        id: json["id"],
        syncId: json["sync_id"],
        readableId: json["readable_id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        dateOfBirth: json["date_of_birth"] == null
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
        ledger: json["ledger"] == null ? null : Ledger.fromJson(json["ledger"]),
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
        "ledger": ledger?.toJson(),
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
  String? firstName;
  String? lastName;
  String? country;
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

class Ledger {
  int? id;
  String? groupName;
  bool? isMandatory;
  String? groupType;
  ParentGroup? parentGroup;

  Ledger({
    this.id,
    this.groupName,
    this.isMandatory,
    this.groupType,
    this.parentGroup,
  });

  factory Ledger.fromRawJson(String str) => Ledger.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ledger.fromJson(Map<String, dynamic> json) => Ledger(
        id: json["id"],
        groupName: json["group_name"],
        isMandatory: json["is_mandatory"],
        groupType: json["group_type"],
        parentGroup: json["parent_group"] == null
            ? null
            : ParentGroup.fromJson(json["parent_group"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "is_mandatory": isMandatory,
        "group_type": groupType,
        "parent_group": parentGroup?.toJson(),
      };
}

class ParentGroup {
  int? id;
  String? groupName;
  bool? isMandatory;
  String? groupType;
  dynamic parentGroup;

  ParentGroup({
    this.id,
    this.groupName,
    this.isMandatory,
    this.groupType,
    this.parentGroup,
  });

  factory ParentGroup.fromRawJson(String str) =>
      ParentGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParentGroup.fromJson(Map<String, dynamic> json) => ParentGroup(
        id: json["id"],
        groupName: json["group_name"],
        isMandatory: json["is_mandatory"],
        groupType: json["group_type"],
        parentGroup: json["parent_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_name": groupName,
        "is_mandatory": isMandatory,
        "group_type": groupType,
        "parent_group": parentGroup,
      };
}

class RemainingItem {
  String? text;
  String? finalGrossWeight;
  String? description;

  RemainingItem({
    this.text,
    this.finalGrossWeight,
    this.description,
  });

  factory RemainingItem.fromRawJson(String str) =>
      RemainingItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RemainingItem.fromJson(Map<String, dynamic> json) => RemainingItem(
        text: json["text"],
        finalGrossWeight: json["final_gross_weight"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "final_gross_weight": finalGrossWeight,
        "description": description,
      };
}
