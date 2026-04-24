import 'dart:convert';

class CreateOrderRequest {
  String? organizationId;
  String? shopId;
  String? commodityType;
  String? orderStringber;
  String? bookingType;
  String? orderDate;
  String? customerId;
  String? orderTakenBy;
  String? remarks;
  List<CreateOrderLineItem>? lineItems;
  List<CreateOrderPaymentDetail>? paymentDetails;
  List<CreateOrderOldGold>? oldGolds;
  String? webstoreOrderId;

  CreateOrderRequest({
    this.organizationId,
    this.shopId,
    this.commodityType,
    this.orderStringber,
    this.bookingType,
    this.orderDate,
    this.customerId,
    this.orderTakenBy,
    this.remarks,
    this.lineItems,
    this.paymentDetails,
    this.oldGolds,
    this.webstoreOrderId,
  });

  factory CreateOrderRequest.fromRawJson(String str) =>
      CreateOrderRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      CreateOrderRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        commodityType: json["commodity_type"],
        orderStringber: json["order_Stringber"],
        bookingType: json["booking_type"],
        orderDate: json["order_date"],
        customerId: json["customer_id"],
        orderTakenBy: json["order_taken_by"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<CreateOrderLineItem>.from(json["line_items"]!
                .map((x) => CreateOrderLineItem.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<CreateOrderPaymentDetail>.from(json["payment_details"]!
                .map((x) => CreateOrderPaymentDetail.fromJson(x))),
        oldGolds: json["old_golds"] == null
            ? []
            : List<CreateOrderOldGold>.from(
                json["old_golds"]!.map((x) => CreateOrderOldGold.fromJson(x))),
        webstoreOrderId: json["webstore_order_id"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "commodity_type": commodityType,
        "order_Stringber": orderStringber,
        "booking_type": bookingType,
        "order_date": orderDate,
        "customer_id": customerId,
        "order_taken_by": orderTakenBy,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "old_golds": oldGolds == null
            ? []
            : List<CreateOrderOldGold>.from(oldGolds!.map((x) => x)),
        "webstore_order_id": webstoreOrderId,
      };
}

class CreateOrderLineItem {
  String? webstoreLineItemId;
  String? organizationId;
  String? shopId;
  String? designId;
  String? itemDescription;
  String? ratePerGm;
  String? size;
  String? purity;
  String? fixedRate;
  String? netWeight;
  String? amount;
  String? grossWeight;
  String? wastage;
  String? wastageType;
  String? makingChargeType;
  String? makingCharge;
  String? stoneCharge;
  String? gstPercentage;
  String? total;
  String? status;
  DateTime? estimatedDelivery;
  String? orderId;
  String? saleId;

  CreateOrderLineItem({
    this.webstoreLineItemId,
    this.organizationId,
    this.shopId,
    this.designId,
    this.itemDescription,
    this.ratePerGm,
    this.size,
    this.purity,
    this.fixedRate,
    this.netWeight,
    this.amount,
    this.grossWeight,
    this.wastage,
    this.wastageType,
    this.makingChargeType,
    this.makingCharge,
    this.stoneCharge,
    this.gstPercentage,
    this.total,
    this.status,
    this.estimatedDelivery,
    this.orderId,
    this.saleId,
  });

  factory CreateOrderLineItem.fromRawJson(String str) =>
      CreateOrderLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateOrderLineItem.fromJson(Map<String, dynamic> json) =>
      CreateOrderLineItem(
        webstoreLineItemId: json["webstore_line_item_id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        designId: json["design_id"],
        itemDescription: json["item_description"],
        ratePerGm: json["rate_per_gm"],
        size: json["size"],
        purity: json["purity"],
        fixedRate: json["fixed_rate"],
        netWeight: json["net_weight"],
        amount: json["amount"],
        grossWeight: json["gross_weight"],
        wastage: json["wastage"],
        wastageType: json["wastage_type"],
        makingChargeType: json["making_charge_type"],
        makingCharge: json["making_charge"],
        stoneCharge: json["stone_charge"],
        gstPercentage: json["gst_percentage"],
        total: json["total"],
        status: json["status"],
        estimatedDelivery: json["estimated_delivery"] == null
            ? null
            : DateTime.parse(json["estimated_delivery"]),
        orderId: json["order_id"],
        saleId: json["sale_id"],
      );

  Map<String, dynamic> toJson() => {
        "webstore_line_item_id": webstoreLineItemId,
        "organization_id": organizationId,
        "shop_id": shopId,
        "design_id": designId,
        "item_description": itemDescription,
        "rate_per_gm": ratePerGm,
        "size": size,
        "purity": purity,
        "fixed_rate": fixedRate,
        "net_weight": netWeight,
        "amount": amount,
        "gross_weight": grossWeight,
        "wastage": wastage,
        "wastage_type": wastageType,
        "making_charge_type": makingChargeType,
        "making_charge": makingCharge,
        "stone_charge": stoneCharge,
        "gst_percentage": gstPercentage,
        "total": total,
        "status": status,
        "estimated_delivery":
            "${estimatedDelivery!.year.toString().padLeft(4, '0')}-${estimatedDelivery!.month.toString().padLeft(2, '0')}-${estimatedDelivery!.day.toString().padLeft(2, '0')}",
        "order_id": orderId,
        "sale_id": saleId,
      };
}

class CreateOrderPaymentDetail {
  String? organizationId;
  String? shopId;
  String? amount;
  String? gst;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? orderId;
  String? remainingAmount;
  List<PaymentMethodDetail>? paymentMethodDetails;
  String? webstorePaymentCode;

  CreateOrderPaymentDetail({
    this.organizationId,
    this.shopId,
    this.amount,
    this.gst,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.orderId,
    this.remainingAmount,
    this.paymentMethodDetails,
    this.webstorePaymentCode,
  });

  factory CreateOrderPaymentDetail.fromRawJson(String str) =>
      CreateOrderPaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateOrderPaymentDetail.fromJson(Map<String, dynamic> json) =>
      CreateOrderPaymentDetail(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        amount: json["amount"],
        gst: json["gst"],
        receivedAmount: json["received_amount"],
        balanceAmount: json["balance_amount"],
        finalAmount: json["final_amount"],
        orderId: json["order_id"],
        remainingAmount: json["remaining_amount"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<PaymentMethodDetail>.from(json["payment_method_details"]!
                .map((x) => PaymentMethodDetail.fromJson(x))),
        webstorePaymentCode: json["webstore_payment_code"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "amount": amount,
        "gst": gst,
        "received_amount": receivedAmount,
        "balance_amount": balanceAmount,
        "final_amount": finalAmount,
        "order_id": orderId,
        "remaining_amount": remainingAmount,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
        "webstore_payment_code": webstorePaymentCode,
      };
}

class PaymentMethodDetail {
  String? organizationId;
  String? amount;
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

class CreateOrderOldGold {
  bool? isCompleted;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  num? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? ornamentId;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;
  String? id;

  CreateOrderOldGold({
    this.isCompleted,
    this.organizationId,
    this.shopId,
    this.code,
    this.description,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.less,
    this.purityType,
    this.ornamentId,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
    this.id,
  });

  factory CreateOrderOldGold.fromRawJson(String str) =>
      CreateOrderOldGold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateOrderOldGold.fromJson(Map<String, dynamic> json) =>
      CreateOrderOldGold(
        isCompleted: json["is_completed"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        code: json["code"],
        description: json["description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        less: json["less"],
        purityType: json["purity_type"],
        ornamentId: json["ornament_id"],
        rate: json["rate"],
        amount: json["amount"],
        roundOff: json["round_off"],
        total: json["total"],
        isReceived: json["is_received"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "is_completed": isCompleted,
        "organization_id": organizationId,
        "shop_id": shopId,
        "code": code,
        "description": description,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "less": less,
        "purity_type": purityType,
        "ornament_id": ornamentId,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
        "id": id,
      };
}
