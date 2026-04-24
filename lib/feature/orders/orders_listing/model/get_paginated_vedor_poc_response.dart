import 'dart:convert';

class GetPaginatedVendorPocResponse {
  List<GetPaginatedVendorPocValue>? values;
  Pagination? pagination;

  GetPaginatedVendorPocResponse({
    this.values,
    this.pagination,
  });

  factory GetPaginatedVendorPocResponse.fromRawJson(String str) =>
      GetPaginatedVendorPocResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaginatedVendorPocResponse.fromJson(Map<String, dynamic> json) =>
      GetPaginatedVendorPocResponse(
        values: json["values"] == null
            ? []
            : List<GetPaginatedVendorPocValue>.from(json["values"]!
                .map((x) => GetPaginatedVendorPocValue.fromJson(x))),
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
  int? totalPages;
  int? currentPage;
  dynamic nextPage;
  dynamic previousPage;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.totalPages,
    this.currentPage,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        previousPage: json["previous_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "total_pages": totalPages,
        "current_page": currentPage,
        "next_page": nextPage,
        "previous_page": previousPage,
      };
}

class GetPaginatedVendorPocValue {
  String? id;
  String? phoneNumber;
  String? fullName;
  String? vendorPocCode;
  String? vendorPocEmail;
  String? vendorPocDesignation;
  dynamic isDeleted;
  dynamic deletedAt;

  GetPaginatedVendorPocValue({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.vendorPocCode,
    this.vendorPocEmail,
    this.vendorPocDesignation,
    this.isDeleted,
    this.deletedAt,
  });

  factory GetPaginatedVendorPocValue.fromRawJson(String str) =>
      GetPaginatedVendorPocValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaginatedVendorPocValue.fromJson(Map<String, dynamic> json) =>
      GetPaginatedVendorPocValue(
        id: json["id"],
        phoneNumber: json["phone_number"],
        fullName: json["full_name"],
        vendorPocCode: json["vendor_poc_code"],
        vendorPocEmail: json["vendor_poc_email"],
        vendorPocDesignation: json["vendor_poc_designation"],
        isDeleted: json["is_deleted"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone_number": phoneNumber,
        "full_name": fullName,
        "vendor_poc_code": vendorPocCode,
        "vendor_poc_email": vendorPocEmail,
        "vendor_poc_designation": vendorPocDesignation,
        "is_deleted": isDeleted,
        "deleted_at": deletedAt,
      };
}
