import 'dart:convert';

class GetWebstoreSettingsResponse {
  String? id;
  bool? isShippingChargeFromCustomer;
  String? shippingCharges;
  bool? isPgChargeFromCustomer;
  String? paymentGatewayCharges;
  String? advanceBookingPercentage;
  String? additionalWebstoreVa;
  String? additionalWebstoreMc;
  String? webstoreViewType;

  GetWebstoreSettingsResponse({
    this.id,
    this.isShippingChargeFromCustomer,
    this.shippingCharges,
    this.isPgChargeFromCustomer,
    this.paymentGatewayCharges,
    this.advanceBookingPercentage,
    this.additionalWebstoreVa,
    this.additionalWebstoreMc,
    this.webstoreViewType,
  });

  factory GetWebstoreSettingsResponse.fromRawJson(String str) =>
      GetWebstoreSettingsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetWebstoreSettingsResponse.fromJson(Map<String, dynamic> json) =>
      GetWebstoreSettingsResponse(
        id: json["id"],
        isShippingChargeFromCustomer: json["is_shipping_charge_from_customer"],
        shippingCharges: json["shipping_charges"],
        isPgChargeFromCustomer: json["is_pg_charge_from_customer"],
        paymentGatewayCharges: json["payment_gateway_charges"],
        advanceBookingPercentage: json["advance_booking_percentage"],
        additionalWebstoreVa: json["additional_webstore_va"],
        additionalWebstoreMc: json["additional_webstore_mc"],
        webstoreViewType: json["webstore_view_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_shipping_charge_from_customer": isShippingChargeFromCustomer,
        "shipping_charges": shippingCharges,
        "is_pg_charge_from_customer": isPgChargeFromCustomer,
        "payment_gateway_charges": paymentGatewayCharges,
        "advance_booking_percentage": advanceBookingPercentage,
        "additional_webstore_va": additionalWebstoreVa,
        "additional_webstore_mc": additionalWebstoreMc,
        "webstore_view_type": webstoreViewType,
      };
}
