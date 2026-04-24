// To parse this JSON data, do
//
//     final getWebStoreOrdersListResponse = getWebStoreOrdersListResponseFromMap(jsonString);

import 'dart:convert';

GetWebStoreOrdersListResponse getWebStoreOrdersListResponseFromMap(
        String str) =>
    GetWebStoreOrdersListResponse.fromMap(json.decode(str));

String getWebStoreOrdersListResponseToMap(GetWebStoreOrdersListResponse data) =>
    json.encode(data.toMap());

class GetWebStoreOrdersListResponse {
  final String? id;
  final String? orderId;
  final String? totalAmount;
  final String? paidAmount;
  final DateTime? date;
  final String? orderNumber;
  final String? invoiceNo;
  final String? invoiceId;
  final String? customerId;
  final String? customerName;
  final String? totalWeight;
  final String? status;
  final ShippingAddress? shippingAddress;
  final List<StatusDropdown>? statusDropdown;

  GetWebStoreOrdersListResponse({
    this.id,
    this.orderId,
    this.totalAmount,
    this.paidAmount,
    this.date,
    this.orderNumber,
    this.invoiceNo,
    this.invoiceId,
    this.customerId,
    this.customerName,
    this.totalWeight,
    this.status,
    this.shippingAddress,
    this.statusDropdown,
  });

  factory GetWebStoreOrdersListResponse.fromMap(Map<String, dynamic> json) =>
      GetWebStoreOrdersListResponse(
        id: json["id"],
        orderId: json["order_id"],
        totalAmount: json["total_amount"],
        paidAmount: json["paid_amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        orderNumber: json["order_number"],
        invoiceId: json["invoice_id"],
        invoiceNo: json["invoice_number"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        totalWeight: json["total_weight"],
        status: json["status"],
        shippingAddress: json["shipping_address"] == null
            ? null
            : ShippingAddress.fromMap(json["shipping_address"]),
        statusDropdown: json["status_dropdown"] == null
            ? []
            : List<StatusDropdown>.from(
                json["status_dropdown"]!.map((x) => StatusDropdown.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "order_id": orderId,
        "total_amount": totalAmount,
        "paid_amount": paidAmount,
        "date": date?.toIso8601String(),
        "order_number": orderNumber,
        "customer_id": customerId,
        "customer_name": customerName,
        "total_weight": totalWeight,
        "status": status,
        "shipping_address": shippingAddress?.toMap(),
        "status_dropdown": statusDropdown == null
            ? []
            : List<dynamic>.from(statusDropdown!.map((x) => x.toMap())),
      };
}

class ShippingAddress {
  final String? id;
  final String? organizationId;
  final bool? isDefault;
  final bool? isJlAddress;
  final String? type;
  final dynamic gstNumber;
  final String? phoneNumber;
  final String? phoneCountryCode;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? state;
  final String? city;
  final String? pincode;
  final String? addressLine1;
  final String? addressLine2;
  final String? linkedEntityType;
  final String? linkedEntityId;
  final dynamic nickname;
  final dynamic longitude;
  final dynamic latitude;

  ShippingAddress({
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

  factory ShippingAddress.fromMap(Map<String, dynamic> json) => ShippingAddress(
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

  Map<String, dynamic> toMap() => {
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

class StatusDropdown {
  final String? id;
  final String? status;

  StatusDropdown({
    this.id,
    this.status,
  });

  factory StatusDropdown.fromMap(Map<String, dynamic> json) => StatusDropdown(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
      };
}
