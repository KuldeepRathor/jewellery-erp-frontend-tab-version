import 'dart:convert';

class OrdersByOrderNumberResponse {
  String? id;
  String? organizationId;
  String? shopId;
  String? commodityType;
  String? orderNumber;
  String? customerId;
  String? bookingType;
  DateTime? orderDate;
  String? orderTakenBy;
  String? remarks;
  List<OrdersByOrderNumberResponseLineItem>? lineItems;
  List<OrdersByOrderNumberResponsePaymentDetail>? paymentDetails;
  List<dynamic>? oldGolds;

  OrdersByOrderNumberResponse({
    this.id,
    this.organizationId,
    this.shopId,
    this.commodityType,
    this.orderNumber,
    this.customerId,
    this.bookingType,
    this.orderDate,
    this.orderTakenBy,
    this.remarks,
    this.lineItems,
    this.paymentDetails,
    this.oldGolds,
  });

  factory OrdersByOrderNumberResponse.fromRawJson(String str) =>
      OrdersByOrderNumberResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersByOrderNumberResponse.fromJson(Map<String, dynamic> json) =>
      OrdersByOrderNumberResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        commodityType: json["commodity_type"],
        orderNumber: json["order_number"],
        customerId: json["customer_id"],
        bookingType: json["booking_type"],
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        orderTakenBy: json["order_taken_by"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<OrdersByOrderNumberResponseLineItem>.from(json["line_items"]!
                .map((x) => OrdersByOrderNumberResponseLineItem.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<OrdersByOrderNumberResponsePaymentDetail>.from(
                json["payment_details"]!.map((x) =>
                    OrdersByOrderNumberResponsePaymentDetail.fromJson(x))),
        oldGolds: json["old_golds"] == null
            ? []
            : List<dynamic>.from(json["old_golds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "commodity_type": commodityType,
        "order_number": orderNumber,
        "customer_id": customerId,
        "booking_type": bookingType,
        "order_date":
            "${orderDate!.year.toString().padLeft(4, '0')}-${orderDate!.month.toString().padLeft(2, '0')}-${orderDate!.day.toString().padLeft(2, '0')}",
        "order_taken_by": orderTakenBy,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "old_golds":
            oldGolds == null ? [] : List<dynamic>.from(oldGolds!.map((x) => x)),
      };
}

class OrdersByOrderNumberResponseLineItem {
  String? id;
  String? organizationId;
  String? shopId;
  String? orderId;
  dynamic saleId;
  String? itemDescription;
  String? grossWeight;
  String? netWeight;
  String? wastagePercentage;
  String? makingCharge;
  String? stoneCharge;
  String? gstPercentage;
  String? status;
  dynamic estimatedDelivery;
  String? total;
  dynamic taggingLineItemId;

  OrdersByOrderNumberResponseLineItem({
    this.id,
    this.organizationId,
    this.shopId,
    this.orderId,
    this.saleId,
    this.itemDescription,
    this.grossWeight,
    this.netWeight,
    this.wastagePercentage,
    this.makingCharge,
    this.stoneCharge,
    this.gstPercentage,
    this.status,
    this.estimatedDelivery,
    this.total,
    this.taggingLineItemId,
  });

  factory OrdersByOrderNumberResponseLineItem.fromRawJson(String str) =>
      OrdersByOrderNumberResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersByOrderNumberResponseLineItem.fromJson(
          Map<String, dynamic> json) =>
      OrdersByOrderNumberResponseLineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        orderId: json["order_id"],
        saleId: json["sale_id"],
        itemDescription: json["item_description"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        wastagePercentage: json["wastage_percentage"],
        makingCharge: json["making_charge"],
        stoneCharge: json["stone_charge"],
        gstPercentage: json["gst_percentage"],
        status: json["status"],
        estimatedDelivery: json["estimated_delivery"],
        total: json["total"],
        taggingLineItemId: json["tagging_line_item_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "order_id": orderId,
        "sale_id": saleId,
        "item_description": itemDescription,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "wastage_percentage": wastagePercentage,
        "making_charge": makingCharge,
        "stone_charge": stoneCharge,
        "gst_percentage": gstPercentage,
        "status": status,
        "estimated_delivery": estimatedDelivery,
        "total": total,
        "tagging_line_item_id": taggingLineItemId,
      };
}

class OrdersByOrderNumberResponsePaymentDetail {
  String? id;
  String? amount;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? orderId;
  dynamic remainingAmount;
  List<PaymentMethod>? paymentMethods;

  OrdersByOrderNumberResponsePaymentDetail({
    this.id,
    this.amount,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.orderId,
    this.remainingAmount,
    this.paymentMethods,
  });

  factory OrdersByOrderNumberResponsePaymentDetail.fromRawJson(String str) =>
      OrdersByOrderNumberResponsePaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersByOrderNumberResponsePaymentDetail.fromJson(
          Map<String, dynamic> json) =>
      OrdersByOrderNumberResponsePaymentDetail(
        id: json["id"],
        amount: json["amount"],
        receivedAmount: json["received_amount"],
        balanceAmount: json["balance_amount"],
        finalAmount: json["final_amount"],
        orderId: json["order_id"],
        remainingAmount: json["remaining_amount"],
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
        "order_id": orderId,
        "remaining_amount": remainingAmount,
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
  String? orderPaymentDetailsId;

  PaymentMethod({
    this.id,
    this.amount,
    this.method,
    this.date,
    this.pos,
    this.paymentCode,
    this.orderPaymentDetailsId,
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
        orderPaymentDetailsId: json["order_payment_details_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "method": method,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "pos": pos,
        "payment_code": paymentCode,
        "order_payment_details_id": orderPaymentDetailsId,
      };
}
