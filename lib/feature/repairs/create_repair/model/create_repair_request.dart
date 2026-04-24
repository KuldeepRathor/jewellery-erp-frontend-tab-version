import 'dart:convert';

class CreateRepairRequest {
  String? organizationId;
  String? shopId;
  String? commodityType;
  String? bookingType;
  String? repairDate;
  String? customerId;
  String? repairTakenBy;
  String? remarks;
  List<LineItem>? lineItems;
  List<PaymentDetail>? paymentDetails;

  CreateRepairRequest({
    this.organizationId,
    this.shopId,
    this.commodityType,
    this.bookingType,
    this.repairDate,
    this.customerId,
    this.repairTakenBy,
    this.remarks,
    this.lineItems,
    this.paymentDetails,
  });

  factory CreateRepairRequest.fromRawJson(String str) =>
      CreateRepairRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateRepairRequest.fromJson(Map<String, dynamic> json) =>
      CreateRepairRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        commodityType: json["commodity_type"],
        bookingType: json["booking_type"],
        repairDate: json["repair_date"],
        customerId: json["customer_id"],
        repairTakenBy: json["repair_taken_by"],
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
        "organization_id": organizationId,
        "shop_id": shopId,
        "commodity_type": commodityType,
        "booking_type": bookingType,
        "repair_date": repairDate,
        "customer_id": customerId,
        "repair_taken_by": repairTakenBy,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? organizationId;
  String? shopId;
  String? itemDescription;
  String? size;
  String? purity;
  double? netWeight;
  double? amount;
  double? noOfPieces;
  String? status;
  DateTime? estimatedDelivery;
  String? repairId;
  String? saleId;

  LineItem({
    this.organizationId,
    this.shopId,
    this.itemDescription,
    this.size,
    this.purity,
    this.netWeight,
    this.amount,
    this.noOfPieces,
    this.status,
    this.estimatedDelivery,
    this.repairId,
    this.saleId,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        itemDescription: json["item_description"],
        size: json["size"],
        purity: json["purity"],
        netWeight: json["net_weight"] != null
            ? _parseDouble(json["net_weight"])
            : null,
        amount: json["amount"] != null ? _parseDouble(json["amount"]) : null,
        noOfPieces: json["no_of_pieces"] != null
            ? _parseDouble(json["no_of_pieces"])
            : null,
        status: json["status"],
        estimatedDelivery: json["estimated_delivery"] == null
            ? null
            : DateTime.parse(json["estimated_delivery"]),
        repairId: json["repair_id"],
        saleId: json["sale_id"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "item_description": itemDescription,
        "size": size,
        "purity": purity,
        "net_weight": netWeight,
        "amount": amount,
        "no_of_pieces": noOfPieces,
        "status": status,
        "estimated_delivery": estimatedDelivery?.toIso8601String(),
        "repair_id": repairId,
        "sale_id": saleId,
      };

  // Helper method to parse both int and double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class PaymentDetail {
  String? organizationId;
  String? shopId;
  double? amount;
  double? gst;
  double? receivedAmount;
  double? balanceAmount;
  double? finalAmount;
  String? repairId;
  List<PaymentMethodDetail>? paymentMethodDetails;

  PaymentDetail({
    this.organizationId,
    this.shopId,
    this.amount,
    this.gst,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.repairId,
    this.paymentMethodDetails,
  });

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        amount: _parseDouble(json["amount"]),
        gst: _parseDouble(json["gst"]),
        receivedAmount: _parseDouble(json["received_amount"]),
        balanceAmount: _parseDouble(json["balance_amount"]),
        finalAmount: _parseDouble(json["final_amount"]),
        repairId: json["repair_id"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<PaymentMethodDetail>.from(json["payment_method_details"]!
                .map((x) => PaymentMethodDetail.fromJson(x))),
      );

// Add this helper method in the PaymentDetail class
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "amount": amount,
        "gst": gst,
        "received_amount": receivedAmount,
        "balance_amount": balanceAmount,
        "final_amount": finalAmount,
        "repair_id": repairId,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
      };
}

class PaymentMethodDetail {
  String? organizationId;
  double? amount;
  String? method;
  String? date;
  String? pos;
  String? paymentCode;

  PaymentMethodDetail({
    this.organizationId,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
  });

  factory PaymentMethodDetail.fromRawJson(String str) =>
      PaymentMethodDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethodDetail.fromJson(Map<String, dynamic> json) =>
      PaymentMethodDetail(
        organizationId: json["organization_id"],
        amount: json["amount"],
        method: json["method"],
        date: json["date"],
        pos: json["pos"],
        paymentCode: json["payment_code"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "amount": amount,
        "method": method,
        "date": date,
        "pos": pos,
        "payment_code": paymentCode,
      };
}
