import 'dart:convert';

class BranchOutReportResponse {
  List<Value>? values;
  Pagination? pagination;

  BranchOutReportResponse({
    this.values,
    this.pagination,
  });

  factory BranchOutReportResponse.fromRawJson(String str) =>
      BranchOutReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchOutReportResponse.fromJson(Map<String, dynamic> json) =>
      BranchOutReportResponse(
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
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
  dynamic next;

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

class Value {
  String? employeeId;
  String? employeeName;
  String? transferToBranch;
  String? branchName;
  DateTime? date;
  int? itemCount;
  String? branchTransferNumber;
  String? grossWeight;
  String? netWeight;
  List<LineItem>? lineItems;

  Value({
    this.employeeId,
    this.employeeName,
    this.transferToBranch,
    this.branchName,
    this.date,
    this.itemCount,
    this.branchTransferNumber,
    this.grossWeight,
    this.netWeight,
    this.lineItems,
  });

  factory Value.fromRawJson(String str) => Value.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        transferToBranch: json["transfer_to_branch"],
        branchName: json["branch_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        itemCount: json["item_count"],
        branchTransferNumber: json["branch_transfer_number"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "employee_name": employeeName,
        "transfer_to_branch": transferToBranch,
        "branch_name": branchName,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "item_count": itemCount,
        "branch_transfer_number": branchTransferNumber,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? id;
  String? organizationId;
  String? shopId;
  String? startShopId;
  String? status;
  String? code;
  String? codeType;
  String? tagBarcode;
  int? tagNumber;
  int? pieces;

  LineItem({
    this.id,
    this.organizationId,
    this.shopId,
    this.startShopId,
    this.status,
    this.code,
    this.codeType,
    this.tagBarcode,
    this.tagNumber,
    this.pieces,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        startShopId: json["start_shop_id"],
        status: json["status"],
        code: json["code"],
        codeType: json["code_type"],
        tagBarcode: json["tag_barcode"],
        tagNumber: json["tag_number"],
        pieces: json["pieces"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "start_shop_id": startShopId,
        "status": status,
        "code": code,
        "code_type": codeType,
        "tag_barcode": tagBarcode,
        "tag_number": tagNumber,
        "pieces": pieces,
      };
}
