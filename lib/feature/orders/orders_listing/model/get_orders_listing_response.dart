import 'dart:convert';

class GetOrdersListingResponse {
  List<GetOrderListingValue>? values;
  Pagination? pagination;

  GetOrdersListingResponse({
    this.values,
    this.pagination,
  });

  factory GetOrdersListingResponse.fromRawJson(String str) =>
      GetOrdersListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrdersListingResponse.fromJson(Map<String, dynamic> json) =>
      GetOrdersListingResponse(
        values: json["values"] == null
            ? []
            : List<GetOrderListingValue>.from(
                json["values"]!.map((x) => GetOrderListingValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  String? next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class GetOrderListingValue {
  String? id;
  String? organizationId;
  String? saleId;
  String? saleNumber;
  int? tagNumber;
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
  String? wastagePercentage;
  String? makingCharge;
  String? stoneCharge;
  String? gstPercentage;
  String? total;
  String? status;
  dynamic estimatedDelivery;
  String? taggingLineItemId;
  String? orderId;
  List<AssignedUser>? assignedUsers;
  List<DesignImage>? designImages;

  GetOrderListingValue({
    this.id,
    this.organizationId,
    this.saleId,
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
    this.wastagePercentage,
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
  });

  factory GetOrderListingValue.fromRawJson(String str) =>
      GetOrderListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOrderListingValue.fromJson(Map<String, dynamic> json) =>
      GetOrderListingValue(
        id: json["id"],
        organizationId: json["organization_id"],
        saleId: json["sale_id"],
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
        wastagePercentage: json["wastage_percentage"],
        makingCharge: json["making_charge"],
        stoneCharge: json["stone_charge"],
        gstPercentage: json["gst_percentage"],
        total: json["total"],
        status: json["status"],
        estimatedDelivery: json["estimated_delivery"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "sale_id": saleId,
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
        "wastage_percentage": wastagePercentage,
        "making_charge": makingCharge,
        "stone_charge": stoneCharge,
        "gst_percentage": gstPercentage,
        "total": total,
        "status": status,
        "estimated_delivery": estimatedDelivery,
        "tagging_line_item_id": taggingLineItemId,
        "order_id": orderId,
        "assigned_users": assignedUsers == null
            ? []
            : List<dynamic>.from(assignedUsers!.map((x) => x.toJson())),
        "design_images": designImages == null
            ? []
            : List<dynamic>.from(designImages!.map((x) => x.toJson())),
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
