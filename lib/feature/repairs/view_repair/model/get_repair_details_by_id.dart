import 'dart:convert';

class GetRepairDetailsByIdResponse {
  String? id;
  String? organizationId;
  String? shopId;
  String? commodityType;
  String? customerId;
  String? customerName;
  String? customerGst;
  CustomerAddress? customerAddress;
  String? repairNumber;
  DateTime? repairDate;
  String? repairTakenBy;
  String? repairTakenByName;
  dynamic remarks;
  List<LineItem>? lineItems;
  List<PaymentDetail>? paymentDetails;

  GetRepairDetailsByIdResponse({
    this.id,
    this.organizationId,
    this.shopId,
    this.commodityType,
    this.customerId,
    this.customerName,
    this.customerGst,
    this.customerAddress,
    this.repairNumber,
    this.repairDate,
    this.repairTakenBy,
    this.repairTakenByName,
    this.remarks,
    this.lineItems,
    this.paymentDetails,
  });

  factory GetRepairDetailsByIdResponse.fromRawJson(String str) =>
      GetRepairDetailsByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRepairDetailsByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetRepairDetailsByIdResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        commodityType: json["commodity_type"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        customerGst: json["customer_gst"],
        customerAddress: json["customer_address"] == null
            ? null
            : CustomerAddress.fromJson(json["customer_address"]),
        repairNumber: json["repair_number"],
        repairDate: json["repair_date"] == null
            ? null
            : DateTime.parse(json["repair_date"]),
        repairTakenBy: json["repair_taken_by"],
        repairTakenByName: json["repair_taken_by_name"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "commodity_type": commodityType,
        "customer_id": customerId,
        "customer_name": customerName,
        "customer_gst": customerGst,
        "customer_address": customerAddress?.toJson(),
        "repair_number": repairNumber,
        "repair_date":
            "${repairDate!.year.toString().padLeft(4, '0')}-${repairDate!.month.toString().padLeft(2, '0')}-${repairDate!.day.toString().padLeft(2, '0')}",
        "repair_taken_by": repairTakenBy,
        "repair_taken_by_name": repairTakenByName,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      };
}

class CustomerAddress {
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

  CustomerAddress({
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

  factory CustomerAddress.fromRawJson(String str) =>
      CustomerAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
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

class LineItem {
  String? id;
  String? organizationId;
  String? shopId;
  String? repairId;
  dynamic size;
  String? purity;
  dynamic amount;
  int? noOfPieces;
  dynamic saleId;
  String? itemDescription;
  dynamic netWeight;
  String? status;
  dynamic estimatedDelivery;
  List<dynamic>? designImages;
  dynamic taggingLineItemId;

  LineItem({
    this.id,
    this.organizationId,
    this.shopId,
    this.repairId,
    this.size,
    this.purity,
    this.amount,
    this.noOfPieces,
    this.saleId,
    this.itemDescription,
    this.netWeight,
    this.status,
    this.estimatedDelivery,
    this.designImages,
    this.taggingLineItemId,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        repairId: json["repair_id"],
        size: json["size"],
        purity: json["purity"],
        amount: json["amount"],
        noOfPieces: json["no_of_pieces"],
        saleId: json["sale_id"],
        itemDescription: json["item_description"],
        netWeight: json["net_weight"],
        status: json["status"],
        estimatedDelivery: json["estimated_delivery"],
        designImages: json["design_images"] == null
            ? []
            : List<dynamic>.from(json["design_images"]!.map((x) => x)),
        taggingLineItemId: json["tagging_line_item_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "repair_id": repairId,
        "size": size,
        "purity": purity,
        "amount": amount,
        "no_of_pieces": noOfPieces,
        "sale_id": saleId,
        "item_description": itemDescription,
        "net_weight": netWeight,
        "status": status,
        "estimated_delivery": estimatedDelivery,
        "design_images": designImages == null
            ? []
            : List<dynamic>.from(designImages!.map((x) => x)),
        "tagging_line_item_id": taggingLineItemId,
      };
}

class PaymentDetail {
  String? id;
  String? amount;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? repairId;
  List<PaymentMethod>? paymentMethods;

  PaymentDetail({
    this.id,
    this.amount,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.repairId,
    this.paymentMethods,
  });

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json["id"],
        amount: json["amount"],
        receivedAmount: json["received_amount"],
        balanceAmount: json["balance_amount"],
        finalAmount: json["final_amount"],
        repairId: json["repair_id"],
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<PaymentMethod>.from(
                json["payment_methods"]!.map((x) => PaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "received_amount": receivedAmount,
        "balance_amount": balanceAmount,
        "final_amount": finalAmount,
        "repair_id": repairId,
        "payment_methods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
      };
}

class PaymentMethod {
  String? id;
  String? amount;
  String? method;
  DateTime? date;
  String? pos;
  String? paymentCode;
  String? repairPaymentDetailsId;

  PaymentMethod({
    this.id,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.repairPaymentDetailsId,
  });

  factory PaymentMethod.fromRawJson(String str) =>
      PaymentMethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        amount: json["amount"],
        method: json["method"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        pos: json["pos"],
        paymentCode: json["payment_code"],
        repairPaymentDetailsId: json["repair_payment_details_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "method": method,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "pos": pos,
        "payment_code": paymentCode,
        "repair_payment_details_id": repairPaymentDetailsId,
      };
}
