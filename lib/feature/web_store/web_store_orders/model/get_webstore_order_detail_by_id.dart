// To parse this JSON data, do
//
//     final webStoreOrderDetailByIdResponse = webStoreOrderDetailByIdResponseFromMap(jsonString);

import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/banner_image_presigned_url_request.dart';

WebStoreOrderDetailByIdResponse webStoreOrderDetailByIdResponseFromMap(
  String str,
) => WebStoreOrderDetailByIdResponse.fromMap(json.decode(str));

String webStoreOrderDetailByIdResponseToMap(
  WebStoreOrderDetailByIdResponse data,
) => json.encode(data.toMap());

class WebStoreOrderDetailByIdResponse {
  final String? id;
  final String? organizationId;
  final String? webstoreOrderNumber;
  final String? bookingType;
  final String? customerId;
  final DateTime? createdAt;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpayStatus;
  final dynamic razorpaySettlementId;
  final dynamic razorpayUtr;
  final dynamic razorpaySettledAt;
  final LineItem? lineItem;
  final IngAddress? shippingAddress;
  final IngAddress? billingAddress;
  final String? subTotal;
  final String? discount;
  final String? tax;
  final String? shippingCharges;
  final String? totalAmount;
  final String? totalAmountWithShipping;

  WebStoreOrderDetailByIdResponse({
    this.id,
    this.organizationId,
    this.webstoreOrderNumber,
    this.bookingType,
    this.customerId,
    this.createdAt,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpayStatus,
    this.razorpaySettlementId,
    this.razorpayUtr,
    this.razorpaySettledAt,
    this.lineItem,
    this.shippingAddress,
    this.billingAddress,
    this.subTotal,
    this.discount,
    this.tax,
    this.shippingCharges,
    this.totalAmount,
    this.totalAmountWithShipping,
  });

  factory WebStoreOrderDetailByIdResponse.fromMap(
    Map<String, dynamic> json,
  ) => WebStoreOrderDetailByIdResponse(
    id: json["id"],
    organizationId: json["organization_id"],
    webstoreOrderNumber: json["webstore_order_number"],
    bookingType: json["booking_type"],
    customerId: json["customer_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    razorpayOrderId: json["razorpay_order_id"],
    razorpayPaymentId: json["razorpay_payment_id"],
    razorpayStatus: json["razorpay_status"],
    razorpaySettlementId: json["razorpay_settlement_id"],
    razorpayUtr: json["razorpay_utr"],
    razorpaySettledAt: json["razorpay_settled_at"],
    lineItem:
        json["line_item"] == null ? null : LineItem.fromMap(json["line_item"]),
    shippingAddress:
        json["shipping_address"] == null
            ? null
            : IngAddress.fromMap(json["shipping_address"]),
    billingAddress:
        json["billing_address"] == null
            ? null
            : IngAddress.fromMap(json["billing_address"]),
    subTotal: json["sub_total"],
    discount: json["discount"],
    tax: json["tax"],
    shippingCharges: json["shipping_charges"],
    totalAmount: json["total_amount"],
    totalAmountWithShipping: json["total_amount_with_shipping"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "organization_id": organizationId,
    "webstore_order_number": webstoreOrderNumber,
    "booking_type": bookingType,
    "customer_id": customerId,
    "created_at": createdAt?.toIso8601String(),
    "razorpay_order_id": razorpayOrderId,
    "razorpay_payment_id": razorpayPaymentId,
    "razorpay_status": razorpayStatus,
    "razorpay_settlement_id": razorpaySettlementId,
    "razorpay_utr": razorpayUtr,
    "razorpay_settled_at": razorpaySettledAt,
    "line_item": lineItem?.toMap(),
    "shipping_address": shippingAddress?.toMap(),
    "billing_address": billingAddress?.toMap(),
    "sub_total": subTotal,
    "discount": discount,
    "tax": tax,
    "shipping_charges": shippingCharges,
    "total_amount": totalAmount,
    "total_amount_with_shipping": totalAmountWithShipping,
  };
}

class IngAddress {
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

  IngAddress({
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

  factory IngAddress.fromMap(Map<String, dynamic> json) => IngAddress(
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

class LineItem {
  final String? id;
  final String? itemDescription;
  final String? ratePerGm;
  final dynamic size;
  final String? purity;
  final String? netWeight;
  final String? saleAmount;
  final String? grossWeight;
  final String? wastagePercentage;
  final String? makingCharge;
  final dynamic stoneCharge;
  final String? gstPercentage;
  final String? itemTotalAmount;
  final String? itemPayableAmount;
  final String? paidAmount;
  final bool? isPaidOff;
  final String? status;
  final DateTime? estimatedDelivery;
  final String? taggingLineItemId;
  final dynamic catalogItemId;
  final String? shippingCompany;
  final String? shipppingTrackingNumber;
  final dynamic shippingTime;
  final DateTime? deliveryTime;
  final DateTime? returnTime;
  final String? returnInvoiceNumber;
  final dynamic cancelTime;
  final String? reason;
  final DateTime? refundTime;
  final String? refundAmount;
  final String? refundId;
  final List<ShippingImage>? shippingImages;
  final List<BannerImagesPresignedUrlImage>? images;

  LineItem({
    this.id,
    this.itemDescription,
    this.ratePerGm,
    this.size,
    this.purity,
    this.netWeight,
    this.saleAmount,
    this.grossWeight,
    this.wastagePercentage,
    this.makingCharge,
    this.stoneCharge,
    this.gstPercentage,
    this.itemTotalAmount,
    this.itemPayableAmount,
    this.paidAmount,
    this.isPaidOff,
    this.status,
    this.estimatedDelivery,
    this.taggingLineItemId,
    this.catalogItemId,
    this.shippingCompany,
    this.shipppingTrackingNumber,
    this.shippingTime,
    this.deliveryTime,
    this.returnTime,
    this.returnInvoiceNumber,
    this.cancelTime,
    this.reason,
    this.refundTime,
    this.refundAmount,
    this.refundId,
    this.shippingImages,
    this.images,
  });

  factory LineItem.fromMap(Map<String, dynamic> json) => LineItem(
    id: json["id"],
    itemDescription: json["item_description"],
    ratePerGm: json["rate_per_gm"],
    size: json["size"],
    purity: json["purity"],
    netWeight: json["net_weight"],
    saleAmount: json["sale_amount"],
    grossWeight: json["gross_weight"],
    wastagePercentage: json["wastage_percentage"],
    makingCharge: json["making_charge"],
    stoneCharge: json["stone_charge"],
    gstPercentage: json["gst_percentage"],
    itemTotalAmount: json["item_total_amount"],
    itemPayableAmount: json["item_payable_amount"],
    paidAmount: json["paid_amount"],
    isPaidOff: json["is_paid_off"],
    status: json["status"],
    estimatedDelivery:
        json["estimated_delivery"] == null
            ? null
            : DateTime.parse(json["estimated_delivery"]),
    taggingLineItemId: json["tagging_line_item_id"],
    catalogItemId: json["catalog_item_id"],
    shippingCompany: json["shipping_company"],
    shipppingTrackingNumber: json["shippping_tracking_number"],
    shippingTime: json["shipping_time"],
    deliveryTime:
        json["delivery_time"] == null
            ? null
            : DateTime.parse(json["delivery_time"]),
    returnTime:
        json["return_time"] == null
            ? null
            : DateTime.parse(json["return_time"]),
    returnInvoiceNumber: json["return_invoice_number"],
    cancelTime: json["cancel_time"],
    reason: json["reason"],
    refundTime:
        json["refund_time"] == null
            ? null
            : DateTime.parse(json["refund_time"]),
    refundAmount: json["refund_amount"],
    refundId: json["refund_id"],
    shippingImages:
        json["shipping_images"] == null
            ? []
            : List<ShippingImage>.from(
              json["shipping_images"]!.map((x) => ShippingImage.fromMap(x)),
            ),
    images:
        json["images"] != null
            ? List<BannerImagesPresignedUrlImage>.from(
              json["images"].map(
                (x) => BannerImagesPresignedUrlImage.fromJson(x),
              ),
            )
            : [],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "item_description": itemDescription,
    "rate_per_gm": ratePerGm,
    "size": size,
    "purity": purity,
    "net_weight": netWeight,
    "sale_amount": saleAmount,
    "gross_weight": grossWeight,
    "wastage_percentage": wastagePercentage,
    "making_charge": makingCharge,
    "stone_charge": stoneCharge,
    "gst_percentage": gstPercentage,
    "item_total_amount": itemTotalAmount,
    "item_payable_amount": itemPayableAmount,
    "paid_amount": paidAmount,
    "is_paid_off": isPaidOff,
    "status": status,
    "estimated_delivery":
        "${estimatedDelivery!.year.toString().padLeft(4, '0')}-${estimatedDelivery!.month.toString().padLeft(2, '0')}-${estimatedDelivery!.day.toString().padLeft(2, '0')}",
    "tagging_line_item_id": taggingLineItemId,
    "catalog_item_id": catalogItemId,
    "shipping_company": shippingCompany,
    "shippping_tracking_number": shipppingTrackingNumber,
    "shipping_time": shippingTime,
    "delivery_time": deliveryTime?.toIso8601String(),
    "return_time": returnTime?.toIso8601String(),
    "return_invoice_number": returnInvoiceNumber,
    "cancel_time": cancelTime,
    "reason": reason,
    "refund_time": refundTime?.toIso8601String(),
    "refund_amount": refundAmount,
    "refund_id": refundId,
    "shipping_images":
        shippingImages == null
            ? []
            : List<dynamic>.from(shippingImages!.map((x) => x.toMap())),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
  };
}

class ShippingImage {
  final String? id;
  final String? fileName;
  final String? fileType;
  final String? s3Key;
  final String? presignedUrl;
  final bool? isWebstore;

  ShippingImage({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.isWebstore,
  });

  factory ShippingImage.fromMap(Map<String, dynamic> json) => ShippingImage(
    id: json["id"],
    fileName: json["file_name"],
    fileType: json["file_type"],
    s3Key: json["s3_key"],
    presignedUrl: json["presigned_url"],
    isWebstore: json["is_webstore"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "file_name": fileName,
    "file_type": fileType,
    "s3_key": s3Key,
    "presigned_url": presignedUrl,
    "is_webstore": isWebstore,
  };
}
