import 'dart:convert';

class GetRepairsListingResponse {
  List<GetRepairsListingValue>? values;
  Pagination? pagination;

  GetRepairsListingResponse({
    this.values,
    this.pagination,
  });

  factory GetRepairsListingResponse.fromRawJson(String str) =>
      GetRepairsListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRepairsListingResponse.fromJson(Map<String, dynamic> json) =>
      GetRepairsListingResponse(
        values: json["values"] == null
            ? []
            : List<GetRepairsListingValue>.from(
                json["values"]!.map((x) => GetRepairsListingValue.fromJson(x))),
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

class GetRepairsListingValue {
  String? id;
  String? organizationId;
  String? repairNumber;
  String? repairTakenBy;
  String? customerId;
  String? shopId;
  String? itemDescription;
  String? ratePerGm;
  String? size;
  DateTime? createdAt;
  String? purity;
  String? netWeight;
  String? amount;
  String? grossWeight;
  String? wastagePercentage;
  String? makingCharge;
  String? stoneCharge;
  String? gstPercentage;
  String? total;
  String? status;
  String? estimatedDelivery;
  String? taggingLineItemId;
  String? repairId;
  String? saleId;

  int? tagNumber;
  String? tagCode;
  String? taggingInvoiceNumber;
  String? saleNumber;

  String? repairTakenByName;
  String? customerName;

  List<AssignedUser>? assignedUsers;
  List<DesignImage>? designImages;

  GetRepairsListingValue({
    this.id,
    this.organizationId,
    this.repairNumber,
    this.repairTakenBy,
    this.repairTakenByName,
    this.customerName,
    this.customerId,
    this.shopId,
    this.itemDescription,
    this.ratePerGm,
    this.size,
    this.createdAt,
    this.purity,
    this.netWeight,
    this.amount,
    this.grossWeight,
    this.wastagePercentage,
    this.makingCharge,
    this.stoneCharge,
    this.gstPercentage,
    this.total,
    this.status,
    this.estimatedDelivery,
    this.taggingLineItemId,
    this.repairId,
    this.saleId,
    this.tagNumber,
    this.tagCode,
    this.taggingInvoiceNumber,
    this.saleNumber,
    this.assignedUsers,
    this.designImages,
  });

  factory GetRepairsListingValue.fromRawJson(String str) =>
      GetRepairsListingValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetRepairsListingValue.fromJson(Map<String, dynamic> json) =>
      GetRepairsListingValue(
        id: json["id"],
        organizationId: json["organization_id"],
        repairNumber: json["repair_number"],
        saleNumber: json["sale_number"],
        repairTakenBy: json["repair_taken_by"],
        repairTakenByName: json["repair_taken_by_name"],
        customerName: json["customer_name"],
        customerId: json["customer_id"],
        shopId: json["shop_id"],
        itemDescription: json["item_description"],
        ratePerGm: json["rate_per_gm"],
        size: json["size"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        purity: json["purity"],
        netWeight: json["net_weight"],
        amount: json["amount"],
        grossWeight: json["gross_weight"],
        wastagePercentage: json["wastage_percentage"],
        makingCharge: json["making_charge"],
        stoneCharge: json["stone_charge"],
        gstPercentage: json["gst_percentage"],
        total: json["total"],
        status: json["status"],
        estimatedDelivery: json["estimated_delivery"],
        taggingLineItemId: json["tagging_line_item_id"],
        repairId: json["repair_id"],
        saleId: json["sale_id"],
        tagNumber: json["tag_number"],
        tagCode: json["tag_code"],
        taggingInvoiceNumber: json["tagging_invoice_number"],
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
        "repair_number": repairNumber,
        "sale_number": saleNumber,
        "repair_taken_by": repairTakenBy,
        "repair_taken_by_name": repairTakenByName,
        "customer_name": customerName,
        "customer_id": customerId,
        "shop_id": shopId,
        "item_description": itemDescription,
        "rate_per_gm": ratePerGm,
        "size": size,
        "created_at": createdAt?.toIso8601String(),
        "purity": purity,
        "net_weight": netWeight,
        "amount": amount,
        "gross_weight": grossWeight,
        "wastage_percentage": wastagePercentage,
        "making_charge": makingCharge,
        "stone_charge": stoneCharge,
        "gst_percentage": gstPercentage,
        "total": total,
        "status": status,
        "estimated_delivery": estimatedDelivery,
        "tagging_line_item_id": taggingLineItemId,
        "repair_id": repairId,
        "sale_id": saleId,
        "tag_number": tagNumber,
        "tag_code": tagCode,
        "tagging_invoice_number": taggingInvoiceNumber,
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
