import 'dart:convert';

class GetOrderDetailsByIdResponse {
  String? id;
  String? organizationId;
  String? saleId;
  String? fixedRate;
  String? saleNumber;
  String? tagNumber;
  String? tagCode;
  String? taggingInvoiceNumber;
  String? orderNumber;
  String? orderTakenBy;
  String? orderTakenByName;
  String? customerName;
  String? customerId;
  String? shopId;
  String? itemDescription;
  String? ratePerGm;
  String? size;
  String? purity;
  String? netWeight;
  String? amount;
  DateTime? createdAt;
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
  String? taggingLineItemId;
  String? orderId;
  List<AssignedUser>? assignedUsers;
  List<DesignImage>? designImages;
  List<OldGold>? oldGolds;
  List<PaymentDetail>? paymentDetails;

  GetOrderDetailsByIdResponse({
    this.id,
    this.organizationId,
    this.saleId,
    this.fixedRate,
    this.saleNumber,
    this.tagNumber,
    this.tagCode,
    this.taggingInvoiceNumber,
    this.orderNumber,
    this.orderTakenBy,
    this.orderTakenByName,
    this.customerName,
    this.customerId,
    this.shopId,
    this.itemDescription,
    this.ratePerGm,
    this.size,
    this.purity,
    this.netWeight,
    this.amount,
    this.createdAt,
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
    this.taggingLineItemId,
    this.orderId,
    this.assignedUsers,
    this.designImages,
    this.oldGolds,
    this.paymentDetails,
  });

  factory GetOrderDetailsByIdResponse.fromRawJson(String str) =>
      GetOrderDetailsByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrderDetailsByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetOrderDetailsByIdResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        saleId: json["sale_id"],
        fixedRate: json["fixed_rate"],
        saleNumber: json["sale_number"],
        tagNumber: json["tag_number"],
        tagCode: json["tag_code"],
        taggingInvoiceNumber: json["tagging_invoice_number"],
        orderNumber: json["order_number"],
        orderTakenBy: json["order_taken_by"],
        orderTakenByName: json["order_taken_by_name"],
        customerName: json["customer_name"],
        customerId: json["customer_id"],
        shopId: json["shop_id"],
        itemDescription: json["item_description"],
        ratePerGm: json["rate_per_gm"],
        size: json["size"],
        purity: json["purity"],
        netWeight: json["net_weight"],
        amount: json["amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
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
        taggingLineItemId: json["tagging_line_item_id"],
        orderId: json["order_id"],
        assignedUsers: json["assigned_users"] == null
            ? []
            : List<AssignedUser>.from(
                json["assigned_users"]!.map((x) => AssignedUser.fromJson(x))),
        designImages: json["design_images"] == null
            ? []
            : List<DesignImage>.from(
                json["design_images"]!.map((x) => DesignImage.fromJson(x))),
        oldGolds: json["old_golds"] == null
            ? []
            : List<OldGold>.from(
                json["old_golds"]!.map((x) => OldGold.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "sale_id": saleId,
        "fixed_rate": fixedRate,
        "sale_number": saleNumber,
        "tag_number": tagNumber,
        "tag_code": tagCode,
        "tagging_invoice_number": taggingInvoiceNumber,
        "order_number": orderNumber,
        "order_taken_by": orderTakenBy,
        "order_taken_by_name": orderTakenByName,
        "customer_name": customerName,
        "customer_id": customerId,
        "shop_id": shopId,
        "item_description": itemDescription,
        "rate_per_gm": ratePerGm,
        "size": size,
        "purity": purity,
        "net_weight": netWeight,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
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
        "tagging_line_item_id": taggingLineItemId,
        "order_id": orderId,
        "assigned_users": assignedUsers == null
            ? []
            : List<dynamic>.from(assignedUsers!.map((x) => x.toJson())),
        "design_images": designImages == null
            ? []
            : List<dynamic>.from(designImages!.map((x) => x.toJson())),
        "old_golds": oldGolds == null
            ? []
            : List<dynamic>.from(oldGolds!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      };
}

class AssignedUser {
  String? id;
  String? name;
  String? code;

  AssignedUser({
    this.id,
    this.name,
    this.code,
  });

  factory AssignedUser.fromRawJson(String str) =>
      AssignedUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssignedUser.fromJson(Map<String, dynamic> json) => AssignedUser(
        id: json["id"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
      };
}

class DesignImage {
  String? id;
  String? designId;
  String? organizationId;
  String? shopId;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;
  String? notes;

  DesignImage({
    this.id,
    this.designId,
    this.organizationId,
    this.shopId,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
    this.notes,
  });

  factory DesignImage.fromRawJson(String str) =>
      DesignImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DesignImage.fromJson(Map<String, dynamic> json) => DesignImage(
        id: json["id"],
        designId: json["design_id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "design_id": designId,
        "organization_id": organizationId,
        "shop_id": shopId,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3Key,
        "presigned_url": presignedUrl,
        "notes": notes,
      };
}

class OldGold {
  String? id;
  String? oldGoldEstimateNumber;
  String? organizationId;
  String? shopId;
  String? code;
  String? description;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? less;
  String? purityType;
  String? ornamentId;
  String? ornamentName;
  String? rate;
  String? amount;
  String? roundOff;
  String? total;
  bool? isReceived;

  OldGold({
    this.id,
    this.oldGoldEstimateNumber,
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
    this.ornamentName,
    this.rate,
    this.amount,
    this.roundOff,
    this.total,
    this.isReceived,
  });

  factory OldGold.fromRawJson(String str) => OldGold.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OldGold.fromJson(Map<String, dynamic> json) => OldGold(
        id: json["id"],
        oldGoldEstimateNumber: json["old_gold_estimate_number"],
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
        ornamentName: json["ornament_name"],
        rate: json["rate"],
        amount: json["amount"],
        roundOff: json["round_off"],
        total: json["total"],
        isReceived: json["is_received"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "old_gold_estimate_number": oldGoldEstimateNumber,
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
        "ornament_name": ornamentName,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "total": total,
        "is_received": isReceived,
      };
}

class PaymentDetail {
  String? id;
  String? amount;
  String? receivedAmount;
  String? balanceAmount;
  String? finalAmount;
  String? orderId;
  String? remainingAmount;
  List<PaymentMethod>? paymentMethods;

  PaymentDetail({
    this.id,
    this.amount,
    this.receivedAmount,
    this.balanceAmount,
    this.finalAmount,
    this.orderId,
    this.remainingAmount,
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
