// // To parse this JSON data, do
// //
// //     final webStoreOrderDetailByIdResponse = webStoreOrderDetailByIdResponseFromMap(jsonString);

// import 'dart:convert';

// import 'package:jewellery_erp_frontend_tab_version/feature/web_store/home_page/hero_slides/model/banner_image_presigned_url_request.dart';

// WebStoreOrderDetailByIdResponse webStoreOrderDetailByIdResponseFromMap(
//         String str) =>
//     WebStoreOrderDetailByIdResponse.fromMap(json.decode(str));

// String webStoreOrderDetailByIdResponseToMap(
//         WebStoreOrderDetailByIdResponse data) =>
//     json.encode(data.toMap());

// class WebStoreOrderDetailByIdResponse {
//   final String id;
//   final String organizationId;
//   final String webstoreOrderNumber;
//   final String bookingType;
//   final String customerId;
//   final DateTime createdAt;
//   final String razorpayOrderId;
//   final String razorpayPaymentId;
//   final String razorpayStatus;
//   final String razorpaySettlementId;
//   final String razorpayUtr;
//   final DateTime razorpaySettledAt;
//   final List<LineItem> lineItems;
//   final List<PaymentDetail> paymentDetails;
//   final IngAddress shippingAddress;
//   final IngAddress billingAddress;

//   WebStoreOrderDetailByIdResponse({
//     required this.id,
//     required this.organizationId,
//     required this.webstoreOrderNumber,
//     required this.bookingType,
//     required this.customerId,
//     required this.createdAt,
//     required this.razorpayOrderId,
//     required this.razorpayPaymentId,
//     required this.razorpayStatus,
//     required this.razorpaySettlementId,
//     required this.razorpayUtr,
//     required this.razorpaySettledAt,
//     required this.lineItems,
//     required this.paymentDetails,
//     required this.shippingAddress,
//     required this.billingAddress,
//   });

//   factory WebStoreOrderDetailByIdResponse.fromMap(Map<String, dynamic> json) =>
//       WebStoreOrderDetailByIdResponse(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         webstoreOrderNumber: json["webstore_order_number"],
//         bookingType: json["booking_type"],
//         customerId: json["customer_id"],
//         createdAt: DateTime.parse(json["created_at"]),
//         razorpayOrderId: json["razorpay_order_id"],
//         razorpayPaymentId: json["razorpay_payment_id"],
//         razorpayStatus: json["razorpay_status"],
//         razorpaySettlementId: json["razorpay_settlement_id"] ?? "",
//         razorpayUtr: json["razorpay_utr"] ?? "",
//         razorpaySettledAt: json["razorpay_settled_at"] != null
//             ? DateTime.parse(json["razorpay_settled_at"])
//             : DateTime.now(),
//         lineItems: json["line_items"] != null
//             ? List<LineItem>.from(
//                 json["line_items"].map((x) => LineItem.fromMap(x)))
//             : [],
//         paymentDetails: List<PaymentDetail>.from(
//             json["payment_details"].map((x) => PaymentDetail.fromMap(x))),
//         shippingAddress: IngAddress.fromMap(json["shipping_address"]),
//         billingAddress: IngAddress.fromMap(json["billing_address"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "organization_id": organizationId,
//         "webstore_order_number": webstoreOrderNumber,
//         "booking_type": bookingType,
//         "customer_id": customerId,
//         "created_at": createdAt.toIso8601String(),
//         "razorpay_order_id": razorpayOrderId,
//         "razorpay_payment_id": razorpayPaymentId,
//         "razorpay_status": razorpayStatus,
//         "razorpay_settlement_id": razorpaySettlementId,
//         "razorpay_utr": razorpayUtr,
//         "razorpay_settled_at": razorpaySettledAt.toIso8601String(),
//         "line_items": List<dynamic>.from(lineItems.map((x) => x.toMap())),
//         "payment_details":
//             List<dynamic>.from(paymentDetails.map((x) => x.toMap())),
//         "shipping_address": shippingAddress.toMap(),
//         "billing_address": billingAddress.toMap(),
//       };
// }

// class IngAddress {
//   final String id;
//   final String organizationId;
//   final bool isDefault;
//   final bool isJlAddress;
//   final String type;
//   final String gstNumber;
//   final String phoneNumber;
//   final String phoneCountryCode;
//   final String firstName;
//   final String lastName;
//   final String country;
//   final String state;
//   final String city;
//   final String pincode;
//   final String addressLine1;
//   final String addressLine2;
//   final String linkedEntityType;
//   final String linkedEntityId;
//   final String nickname;
//   final String longitude;
//   final String latitude;

//   IngAddress({
//     required this.id,
//     required this.organizationId,
//     required this.isDefault,
//     required this.isJlAddress,
//     required this.type,
//     required this.gstNumber,
//     required this.phoneNumber,
//     required this.phoneCountryCode,
//     required this.firstName,
//     required this.lastName,
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.pincode,
//     required this.addressLine1,
//     required this.addressLine2,
//     required this.linkedEntityType,
//     required this.linkedEntityId,
//     required this.nickname,
//     required this.longitude,
//     required this.latitude,
//   });

//   factory IngAddress.fromMap(Map<String, dynamic> json) => IngAddress(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         isDefault: json["is_default"],
//         isJlAddress: json["is_jl_address"],
//         type: json["type"] ?? "",
//         gstNumber: json["gst_number"] ?? "",
//         phoneNumber: json["phone_number"] ?? "",
//         phoneCountryCode: json["phone_country_code"] ?? "",
//         firstName: json["first_name"] ?? "",
//         lastName: json["last_name"] ?? "",
//         country: json["country"] ?? "",
//         state: json["state"] ?? "",
//         city: json["city"],
//         pincode: json["pincode"] ?? "",
//         addressLine1: json["address_line1"] ?? "",
//         addressLine2: json["address_line2"] ?? "",
//         linkedEntityType: json["linked_entity_type"] ?? "",
//         linkedEntityId: json["linked_entity_id"] ?? "",
//         nickname: json["nickname"] ?? "",
//         longitude: json["longitude"] ?? "",
//         latitude: json["latitude"] ?? "",
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "organization_id": organizationId,
//         "is_default": isDefault,
//         "is_jl_address": isJlAddress,
//         "type": type,
//         "gst_number": gstNumber,
//         "phone_number": phoneNumber,
//         "phone_country_code": phoneCountryCode,
//         "first_name": firstName,
//         "last_name": lastName,
//         "country": country,
//         "state": state,
//         "city": city,
//         "pincode": pincode,
//         "address_line1": addressLine1,
//         "address_line2": addressLine2,
//         "linked_entity_type": linkedEntityType,
//         "linked_entity_id": linkedEntityId,
//         "nickname": nickname,
//         "longitude": longitude,
//         "latitude": latitude,
//       };
// }

// class LineItem {
//   final String itemDescription;
//   final String ratePerGm;
//   final String size;
//   final String purity;
//   final String netWeight;
//   final String saleAmount;
//   final String grossWeight;
//   final String wastagePercentage;
//   final String makingCharge;
//   final String stoneCharge;
//   final String gstPercentage;
//   final String itemTotalAmount;
//   final String itemPayableAmount;
//   final String paidAmount;
//   final bool isPaidOff;
//   final String status;
//   final DateTime estimatedDelivery;
//   final String taggingLineItemId;
//   final String catalogItemId;
//   final String shippingCompany;
//   final String shipppingTrackingNumber;
//   final DateTime shippingTime;
//   final DateTime deliveryTime;
//   final DateTime returnTime;
//   final String returnInvoiceNumber;
//   final DateTime cancelTime;
//   final String reason;
//   final DateTime refundTime;
//   final String refundAmount;
//   final String refundId;
//   final List<dynamic> shippingImages;
//   final List<BannerImagesPresignedUrlImage> images;

//   LineItem({
//     required this.itemDescription,
//     required this.ratePerGm,
//     required this.size,
//     required this.purity,
//     required this.netWeight,
//     required this.saleAmount,
//     required this.grossWeight,
//     required this.wastagePercentage,
//     required this.makingCharge,
//     required this.stoneCharge,
//     required this.gstPercentage,
//     required this.itemTotalAmount,
//     required this.itemPayableAmount,
//     required this.paidAmount,
//     required this.isPaidOff,
//     required this.status,
//     required this.estimatedDelivery,
//     required this.taggingLineItemId,
//     required this.catalogItemId,
//     required this.shippingCompany,
//     required this.shipppingTrackingNumber,
//     required this.shippingTime,
//     required this.deliveryTime,
//     required this.returnTime,
//     required this.returnInvoiceNumber,
//     required this.cancelTime,
//     required this.reason,
//     required this.refundTime,
//     required this.refundAmount,
//     required this.refundId,
//     required this.shippingImages,
//     required this.images,
//   });

//   factory LineItem.fromMap(Map<String, dynamic> json) => LineItem(
//         itemDescription: json["item_description"],
//         ratePerGm: json["rate_per_gm"],
//         size: json["size"] ?? "",
//         purity: json["purity"],
//         netWeight: json["net_weight"],
//         saleAmount: json["sale_amount"],
//         grossWeight: json["gross_weight"],
//         wastagePercentage: json["wastage_percentage"] ?? "",
//         makingCharge: json["making_charge"] ?? "",
//         stoneCharge: json["stone_charge"] ?? "",
//         gstPercentage: json["gst_percentage"],
//         itemTotalAmount: json["item_total_amount"],
//         itemPayableAmount: json["item_payable_amount"],
//         paidAmount: json["paid_amount"],
//         isPaidOff: json["is_paid_off"],
//         status: json["status"],
//         estimatedDelivery: DateTime.parse(json["estimated_delivery"]),
//         taggingLineItemId: json["tagging_line_item_id"] ?? "",
//         catalogItemId: json["catalog_item_id"] ?? "",
//         shippingCompany: json["shipping_company"] ?? "",
//         shipppingTrackingNumber: json["shippping_tracking_number"] ?? "",
//         shippingTime: json["shipping_time"] != null
//             ? DateTime.parse(json["shipping_time"])
//             : DateTime.now(),
//         deliveryTime: json["delivery_time"] != null
//             ? DateTime.parse(json["delivery_time"])
//             : DateTime.now(),
//         returnTime: json["return_time"] != null
//             ? DateTime.parse(json["return_time"])
//             : DateTime.now(),
//         returnInvoiceNumber: json["return_invoice_number"] ?? "",
//         cancelTime: json["cancel_time"] != null
//             ? DateTime.parse(json["cancel_time"])
//             : DateTime.now(),
//         reason: json["reason"] ?? "",
//         refundTime: json["refund_time"] != null
//             ? DateTime.parse(json["refund_time"])
//             : DateTime.now(),
//         refundAmount: json["refund_amount"] ?? "",
//         refundId: json["refund_id"] ?? "",
//         shippingImages:
//             json["shipping_images"] != null && json["shipping_images"] is List
//                 ? List<dynamic>.from(json["shipping_images"].map((x) => x))
//                 : [],
//         images: json["images"] != null
//             ? List<BannerImagesPresignedUrlImage>.from(json["images"]
//                 .map((x) => BannerImagesPresignedUrlImage.fromJson(x)))
//             : [],
//       );

//   Map<String, dynamic> toMap() => {
//         "item_description": itemDescription,
//         "rate_per_gm": ratePerGm,
//         "size": size,
//         "purity": purity,
//         "net_weight": netWeight,
//         "sale_amount": saleAmount,
//         "gross_weight": grossWeight,
//         "wastage_percentage": wastagePercentage,
//         "making_charge": makingCharge,
//         "stone_charge": stoneCharge,
//         "gst_percentage": gstPercentage,
//         "item_total_amount": itemTotalAmount,
//         "item_payable_amount": itemPayableAmount,
//         "paid_amount": paidAmount,
//         "is_paid_off": isPaidOff,
//         "status": status,
//         "estimated_delivery":
//             "${estimatedDelivery.year.toString().padLeft(4, '0')}-${estimatedDelivery.month.toString().padLeft(2, '0')}-${estimatedDelivery.day.toString().padLeft(2, '0')}",
//         "tagging_line_item_id": taggingLineItemId,
//         "catalog_item_id": catalogItemId,
//         "shipping_company": shippingCompany,
//         "shippping_tracking_number": shipppingTrackingNumber,
//         "shipping_time": shippingTime.toIso8601String(),
//         "delivery_time": deliveryTime.toIso8601String(),
//         "return_time": returnTime.toIso8601String(),
//         "return_invoice_number": returnInvoiceNumber,
//         "cancel_time": cancelTime.toIso8601String(),
//         "reason": reason,
//         "refund_time": refundTime.toIso8601String(),
//         "refund_amount": refundAmount,
//         "refund_id": refundId,
//         "shipping_images": List<dynamic>.from(shippingImages.map((x) => x)),
//         "images": List<dynamic>.from(images.map((x) => x)),
//       };
// }

// class PaymentDetail {
//   final String shippingCharges;
//   final String paymentGatewayCharges;
//   final String advanceBookingPercentage;
//   final String amount;
//   final String receivedAmount;
//   final String balanceAmount;
//   final String finalAmount;
//   final String remainingAmount;
//   final List<PaymentMethod> paymentMethods;

//   PaymentDetail({
//     required this.shippingCharges,
//     required this.paymentGatewayCharges,
//     required this.advanceBookingPercentage,
//     required this.amount,
//     required this.receivedAmount,
//     required this.balanceAmount,
//     required this.finalAmount,
//     required this.remainingAmount,
//     required this.paymentMethods,
//   });

//   factory PaymentDetail.fromMap(Map<String, dynamic> json) => PaymentDetail(
//         shippingCharges: json["shipping_charges"],
//         paymentGatewayCharges: json["payment_gateway_charges"],
//         advanceBookingPercentage: json["advance_booking_percentage"],
//         amount: json["amount"],
//         receivedAmount: json["received_amount"],
//         balanceAmount: json["balance_amount"],
//         finalAmount: json["final_amount"],
//         remainingAmount: json["remaining_amount"],
//         paymentMethods: List<PaymentMethod>.from(
//             json["payment_methods"].map((x) => PaymentMethod.fromMap(x))),
//       );

//   Map<String, dynamic> toMap() => {
//         "shipping_charges": shippingCharges,
//         "payment_gateway_charges": paymentGatewayCharges,
//         "advance_booking_percentage": advanceBookingPercentage,
//         "amount": amount,
//         "received_amount": receivedAmount,
//         "balance_amount": balanceAmount,
//         "final_amount": finalAmount,
//         "remaining_amount": remainingAmount,
//         "payment_methods":
//             List<dynamic>.from(paymentMethods.map((x) => x.toMap())),
//       };
// }

// class PaymentMethod {
//   final String amount;
//   final String method;
//   final DateTime date;
//   final String pos;
//   final String paymentCode;

//   PaymentMethod({
//     required this.amount,
//     required this.method,
//     required this.date,
//     required this.pos,
//     required this.paymentCode,
//   });

//   factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
//         amount: json["amount"],
//         method: json["method"],
//         date: DateTime.parse(json["date"]),
//         pos: json["pos"],
//         paymentCode: json["payment_code"],
//       );

//   Map<String, dynamic> toMap() => {
//         "amount": amount,
//         "method": method,
//         "date":
//             "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//         "pos": pos,
//         "payment_code": paymentCode,
//       };
// }
