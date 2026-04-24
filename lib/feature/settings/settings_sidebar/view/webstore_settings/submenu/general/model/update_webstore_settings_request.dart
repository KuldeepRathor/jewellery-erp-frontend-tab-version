import 'dart:convert';

class UpdateWebstoreSettingsRequest {
  String? id;
  String? organizationId;
  bool? isShippingChargeFromCustomer;
  double? shippingCharges;
  bool? isPgChargeFromCustomer;
  double? paymentGatewayCharges;
  double? advanceBookingPercentage;
  double? additionalWebstoreVa;
  double? additionalWebstoreMc;

  UpdateWebstoreSettingsRequest({
    this.id,
    this.organizationId,
    this.isShippingChargeFromCustomer,
    this.shippingCharges,
    this.isPgChargeFromCustomer,
    this.paymentGatewayCharges,
    this.advanceBookingPercentage,
    this.additionalWebstoreVa,
    this.additionalWebstoreMc,
  });

  factory UpdateWebstoreSettingsRequest.fromRawJson(String str) =>
      UpdateWebstoreSettingsRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateWebstoreSettingsRequest.fromJson(Map<String, dynamic> json) =>
      UpdateWebstoreSettingsRequest(
        id: json["id"],
        organizationId: json["organization_id"],
        isShippingChargeFromCustomer: json["is_shipping_charge_from_customer"],
        shippingCharges: json["shipping_charges"]?.toDouble(),
        isPgChargeFromCustomer: json["is_pg_charge_from_customer"],
        paymentGatewayCharges: json["payment_gateway_charges"]?.toDouble(),
        advanceBookingPercentage:
            json["advance_booking_percentage"]?.toDouble(),
        additionalWebstoreVa: json["additional_webstore_va"]?.toDouble(),
        additionalWebstoreMc: json["additional_webstore_mc"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "is_shipping_charge_from_customer": isShippingChargeFromCustomer,
        "shipping_charges": shippingCharges,
        "is_pg_charge_from_customer": isPgChargeFromCustomer,
        "payment_gateway_charges": paymentGatewayCharges,
        "advance_booking_percentage": advanceBookingPercentage,
        "additional_webstore_va": additionalWebstoreVa,
        "additional_webstore_mc": additionalWebstoreMc,
      };
}
