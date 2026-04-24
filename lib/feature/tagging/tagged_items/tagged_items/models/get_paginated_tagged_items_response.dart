import 'dart:convert';

class PaginatedGetTaggedItemsResponse {
  List<GetTaggedItemsResponseValue>? values;
  Pagination? pagination;

  PaginatedGetTaggedItemsResponse({
    this.values,
    this.pagination,
  });

  factory PaginatedGetTaggedItemsResponse.fromRawJson(String str) =>
      PaginatedGetTaggedItemsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginatedGetTaggedItemsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedGetTaggedItemsResponse(
        values: json["values"] == null
            ? []
            : List<GetTaggedItemsResponseValue>.from(json["values"]!
                .map((x) => GetTaggedItemsResponseValue.fromJson(x))),
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

class GetTaggedItemsResponseValue {
  String? id;
  DateTime? date;
  dynamic lotId;
  dynamic lotNumber;
  String? recordNumber;
  String? taggedById;
  EmployeeDetails? employeeDetails;
  int? totalPieces;
  String? totalGrossWeight;
  String? totalNetWeight;
  String? totalStoneWeight;
  String? totalStoneAmount;

  GetTaggedItemsResponseValue({
    this.id,
    this.date,
    this.lotId,
    this.lotNumber,
    this.recordNumber,
    this.taggedById,
    this.employeeDetails,
    this.totalPieces,
    this.totalGrossWeight,
    this.totalNetWeight,
    this.totalStoneWeight,
    this.totalStoneAmount,
  });

  factory GetTaggedItemsResponseValue.fromRawJson(String str) =>
      GetTaggedItemsResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggedItemsResponseValue.fromJson(Map<String, dynamic> json) =>
      GetTaggedItemsResponseValue(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        lotId: json["lot_id"],
        lotNumber: json["lot_number"],
        recordNumber: json["record_number"],
        taggedById: json["tagged_by_id"],
        employeeDetails: json["employee_details"] == null
            ? null
            : EmployeeDetails.fromJson(json["employee_details"]),
        totalPieces: json["total_pieces"],
        totalGrossWeight: json["total_gross_weight"],
        totalNetWeight: json["total_net_weight"],
        totalStoneWeight: json["total_stone_weight"],
        totalStoneAmount: json["total_stone_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "lot_id": lotId,
        "lot_number": lotNumber,
        "record_number": recordNumber,
        "tagged_by_id": taggedById,
        "employee_details": employeeDetails?.toJson(),
        "total_pieces": totalPieces,
        "total_gross_weight": totalGrossWeight,
        "total_net_weight": totalNetWeight,
        "total_stone_weight": totalStoneWeight,
        "total_stone_amount": totalStoneAmount,
      };
}

class EmployeeDetails {
  String? id;
  String? organizationId;
  String? employeeId;
  String? shopId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountryCode;

  EmployeeDetails({
    this.id,
    this.organizationId,
    this.employeeId,
    this.shopId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountryCode,
  });

  factory EmployeeDetails.fromRawJson(String str) =>
      EmployeeDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeDetails.fromJson(Map<String, dynamic> json) =>
      EmployeeDetails(
        id: json["id"],
        organizationId: json["organization_id"],
        employeeId: json["employee_id"],
        shopId: json["shop_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "employee_id": employeeId,
        "shop_id": shopId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
      };
}
