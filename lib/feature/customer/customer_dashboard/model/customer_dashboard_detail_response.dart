import 'dart:convert';

class CustomerDashboardDetailsResponse {
  CustomerDetails? customerDetails;
  String? customerBalanceAmount;
  CustomerPurchaseDetail? customerPurchaseDetail;
  CustomerOrderDetail? customerOrderDetail;
  CustomerRepairDetail? customerRepairDetail;
  SalesReturnDetails? salesReturnDetails;
  SalesDetails? salesDetails;
  CustomerEstimationDetails? customerEstimationDetails;
  CustomerOldGoldDetails? customerOldGoldDetails;
  CustomerJewelleryPlanDetails? customerJewelleryPlanDetails;
  CustomerDigitalCoinDetails? customerDigitalCoinDetails;
  CustomerAdvanceBookingDetails? customerAdvanceBookingDetails;

  CustomerDashboardDetailsResponse({
    this.customerDetails,
    this.customerBalanceAmount,
    this.customerPurchaseDetail,
    this.customerOrderDetail,
    this.customerRepairDetail,
    this.salesReturnDetails,
    this.salesDetails,
    this.customerEstimationDetails,
    this.customerOldGoldDetails,
    this.customerJewelleryPlanDetails,
    this.customerDigitalCoinDetails,
    this.customerAdvanceBookingDetails,
  });

  factory CustomerDashboardDetailsResponse.fromRawJson(String str) =>
      CustomerDashboardDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerDashboardDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      CustomerDashboardDetailsResponse(
        customerDetails: json["customer_details"] == null
            ? null
            : CustomerDetails.fromJson(json["customer_details"]),
        customerBalanceAmount: json["customer_balance_amount"],
        customerPurchaseDetail: json["customer_purchase_detail"] == null
            ? null
            : CustomerPurchaseDetail.fromJson(json["customer_purchase_detail"]),
        customerOrderDetail: json["customer_order_detail"] == null
            ? null
            : CustomerOrderDetail.fromJson(json["customer_order_detail"]),
        customerRepairDetail: json["customer_repair_detail"] == null
            ? null
            : CustomerRepairDetail.fromJson(json["customer_repair_detail"]),
        salesReturnDetails: json["sales_return_details"] == null
            ? null
            : SalesReturnDetails.fromJson(json["sales_return_details"]),
        salesDetails: json["sales_details"] == null
            ? null
            : SalesDetails.fromJson(json["sales_details"]),
        customerEstimationDetails: json["customer_estimation_details"] == null
            ? null
            : CustomerEstimationDetails.fromJson(
                json["customer_estimation_details"]),
        customerOldGoldDetails: json["customer_old_gold_details"] == null
            ? null
            : CustomerOldGoldDetails.fromJson(
                json["customer_old_gold_details"]),
        customerJewelleryPlanDetails:
            json["customer_jewellery_plan_details"] == null
                ? null
                : CustomerJewelleryPlanDetails.fromJson(
                    json["customer_jewellery_plan_details"]),
        customerDigitalCoinDetails:
            json["customer_digital_coin_details"] == null
                ? null
                : CustomerDigitalCoinDetails.fromJson(
                    json["customer_digital_coin_details"]),
        customerAdvanceBookingDetails:
            json["customer_advance_booking_details"] == null
                ? null
                : CustomerAdvanceBookingDetails.fromJson(
                    json["customer_advance_booking_details"]),
      );

  Map<String, dynamic> toJson() => {
        "customer_details": customerDetails?.toJson(),
        "customer_balance_amount": customerBalanceAmount,
        "customer_purchase_detail": customerPurchaseDetail?.toJson(),
        "customer_order_detail": customerOrderDetail?.toJson(),
        "customer_repair_detail": customerRepairDetail?.toJson(),
        "sales_return_details": salesReturnDetails?.toJson(),
        "sales_details": salesDetails?.toJson(),
        "customer_estimation_details": customerEstimationDetails?.toJson(),
        "customer_old_gold_details": customerOldGoldDetails?.toJson(),
        "customer_jewellery_plan_details":
            customerJewelleryPlanDetails?.toJson(),
        "customer_digital_coin_details": customerDigitalCoinDetails?.toJson(),
        "customer_advance_booking_details":
            customerAdvanceBookingDetails?.toJson(),
      };
}

class CustomerAdvanceBookingDetails {
  int? count;
  String? totalAdvanceAmount;

  CustomerAdvanceBookingDetails({
    this.count,
    this.totalAdvanceAmount,
  });

  factory CustomerAdvanceBookingDetails.fromRawJson(String str) =>
      CustomerAdvanceBookingDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerAdvanceBookingDetails.fromJson(Map<String, dynamic> json) =>
      CustomerAdvanceBookingDetails(
        count: json["count"],
        totalAdvanceAmount: json["total_advance_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_advance_amount": totalAdvanceAmount,
      };
}

class CustomerDetails {
  String? id;
  String? syncId;
  String? readableId;
  String? phoneNumber;
  String? phoneCountryCode;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  String? aadhaarNumber;
  String? gstNumber;
  dynamic deductionType;
  dynamic deductionPercent;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  dynamic ledger;
  List<dynamic>? nominees;
  List<Address>? address;
  String? signUpSource;
  String? email;
  bool? isAadhaarVerified;
  bool? isPanVerified;
  bool? isAadhaarOnlineVerified;
  bool? isPanOnlineVerified;
  bool? isForcedKycAadhaar;
  bool? isForcedKycPan;

  CustomerDetails({
    this.id,
    this.syncId,
    this.readableId,
    this.phoneNumber,
    this.phoneCountryCode,
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
    this.isAadhaarVerified,
    this.isPanVerified,
    this.isAadhaarOnlineVerified,
    this.isPanOnlineVerified,
    this.isForcedKycAadhaar,
    this.isForcedKycPan,
  });

  factory CustomerDetails.fromRawJson(String str) =>
      CustomerDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        id: json["id"],
        syncId: json["sync_id"],
        readableId: json["readable_id"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
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
        isAadhaarVerified: json["is_aadhaar_verified"],
        isPanVerified: json["is_pan_verified"],
        isAadhaarOnlineVerified: json["is_aadhaar_online_verified"],
        isPanOnlineVerified: json["is_pan_online_verified"],
        isForcedKycAadhaar: json["is_forced_kyc_aadhaar"],
        isForcedKycPan: json["is_forced_kyc_pan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sync_id": syncId,
        "readable_id": readableId,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
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
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "sign_up_source": signUpSource,
        "email": email,
        "is_aadhaar_verified": isAadhaarVerified,
        "is_pan_verified": isPanVerified,
        "is_aadhaar_online_verified": isAadhaarOnlineVerified,
        "is_pan_online_verified": isPanOnlineVerified,
        "is_forced_kyc_aadhaar": isForcedKycAadhaar,
        "is_forced_kyc_pan": isForcedKycPan,
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

class CustomerDigitalCoinDetails {
  String? totalDigitalCoinWeight;
  String? totalDigitalCoinAmount;

  CustomerDigitalCoinDetails({
    this.totalDigitalCoinWeight,
    this.totalDigitalCoinAmount,
  });

  factory CustomerDigitalCoinDetails.fromRawJson(String str) =>
      CustomerDigitalCoinDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerDigitalCoinDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDigitalCoinDetails(
        totalDigitalCoinWeight: json["total_digital_coin_weight"],
        totalDigitalCoinAmount: json["total_digital_coin_amount"],
      );

  Map<String, dynamic> toJson() => {
        "total_digital_coin_weight": totalDigitalCoinWeight,
        "total_digital_coin_amount": totalDigitalCoinAmount,
      };
}

class CustomerEstimationDetails {
  int? count;
  String? totalEstimationAmount;

  CustomerEstimationDetails({
    this.count,
    this.totalEstimationAmount,
  });

  factory CustomerEstimationDetails.fromRawJson(String str) =>
      CustomerEstimationDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerEstimationDetails.fromJson(Map<String, dynamic> json) =>
      CustomerEstimationDetails(
        count: json["count"],
        totalEstimationAmount: json["total_estimation_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_estimation_amount": totalEstimationAmount,
      };
}

class CustomerJewelleryPlanDetails {
  int? count;
  String? totalJewelleryPlanAmount;

  CustomerJewelleryPlanDetails({
    this.count,
    this.totalJewelleryPlanAmount,
  });

  factory CustomerJewelleryPlanDetails.fromRawJson(String str) =>
      CustomerJewelleryPlanDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerJewelleryPlanDetails.fromJson(Map<String, dynamic> json) =>
      CustomerJewelleryPlanDetails(
        count: json["count"],
        totalJewelleryPlanAmount: json["total_jewellery_plan_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_jewellery_plan_amount": totalJewelleryPlanAmount,
      };
}

class CustomerOldGoldDetails {
  int? count;
  String? totalOldGoldAmount;

  CustomerOldGoldDetails({
    this.count,
    this.totalOldGoldAmount,
  });

  factory CustomerOldGoldDetails.fromRawJson(String str) =>
      CustomerOldGoldDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerOldGoldDetails.fromJson(Map<String, dynamic> json) =>
      CustomerOldGoldDetails(
        count: json["count"],
        totalOldGoldAmount: json["total_old_gold_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_old_gold_amount": totalOldGoldAmount,
      };
}

class CustomerOrderDetail {
  int? count;
  String? totalOrderAmount;

  CustomerOrderDetail({
    this.count,
    this.totalOrderAmount,
  });

  factory CustomerOrderDetail.fromRawJson(String str) =>
      CustomerOrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerOrderDetail.fromJson(Map<String, dynamic> json) =>
      CustomerOrderDetail(
        count: json["count"],
        totalOrderAmount: json["total_order_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_order_amount": totalOrderAmount,
      };
}

class CustomerPurchaseDetail {
  int? count;
  String? totalPurchaseAmount;
  String? totalPurchaseWeight;

  CustomerPurchaseDetail({
    this.count,
    this.totalPurchaseAmount,
    this.totalPurchaseWeight,
  });

  factory CustomerPurchaseDetail.fromRawJson(String str) =>
      CustomerPurchaseDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerPurchaseDetail.fromJson(Map<String, dynamic> json) =>
      CustomerPurchaseDetail(
        count: json["count"],
        totalPurchaseAmount: json["total_purchase_amount"],
        totalPurchaseWeight: json["total_purchase_weight"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_purchase_amount": totalPurchaseAmount,
        "total_purchase_weight": totalPurchaseWeight,
      };
}

class CustomerRepairDetail {
  int? count;
  String? totalRepairAmount;

  CustomerRepairDetail({
    this.count,
    this.totalRepairAmount,
  });

  factory CustomerRepairDetail.fromRawJson(String str) =>
      CustomerRepairDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerRepairDetail.fromJson(Map<String, dynamic> json) =>
      CustomerRepairDetail(
        count: json["count"],
        totalRepairAmount: json["total_repair_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_repair_amount": totalRepairAmount,
      };
}

class SalesDetails {
  int? count;
  String? totalSalesAmount;

  SalesDetails({
    this.count,
    this.totalSalesAmount,
  });

  factory SalesDetails.fromRawJson(String str) =>
      SalesDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesDetails.fromJson(Map<String, dynamic> json) => SalesDetails(
        count: json["count"],
        totalSalesAmount: json["total_sales_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_sales_amount": totalSalesAmount,
      };
}

class SalesReturnDetails {
  int? count;
  String? totalSalesReturnAmount;

  SalesReturnDetails({
    this.count,
    this.totalSalesReturnAmount,
  });

  factory SalesReturnDetails.fromRawJson(String str) =>
      SalesReturnDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesReturnDetails.fromJson(Map<String, dynamic> json) =>
      SalesReturnDetails(
        count: json["count"],
        totalSalesReturnAmount: json["total_sales_return_amount"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total_sales_return_amount": totalSalesReturnAmount,
      };
}
