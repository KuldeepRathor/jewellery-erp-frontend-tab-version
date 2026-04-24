import 'dart:convert';

class TransferToDropDownModel {
  List<BranchValue>? values;
  Pagination? pagination;

  TransferToDropDownModel({
    this.values,
    this.pagination,
  });

  TransferToDropDownModel copyWith({
    List<BranchValue>? values,
    Pagination? pagination,
  }) =>
      TransferToDropDownModel(
        values: values ?? this.values,
        pagination: pagination ?? this.pagination,
      );

  factory TransferToDropDownModel.fromRawJson(String str) =>
      TransferToDropDownModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransferToDropDownModel.fromJson(Map<String, dynamic> json) =>
      TransferToDropDownModel(
        values: json["values"] == null
            ? []
            : List<BranchValue>.from(
                json["values"]!.map((x) => BranchValue.fromJson(x))),
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

  Pagination copyWith({
    int? totalCount,
    int? pageCount,
    dynamic next,
  }) =>
      Pagination(
        totalCount: totalCount ?? this.totalCount,
        pageCount: pageCount ?? this.pageCount,
        next: next ?? this.next,
      );

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

class BranchValue {
  String? id;
  String? branchName;
  String? readableId;
  String? pincode;
  String? gstNumber;
  String? stateCode;
  dynamic phoneNumber;
  dynamic phoneCountryCode;
  dynamic firstName;
  dynamic lastName;
  String? country;
  String? state;
  String? city;
  String? addressLine1;
  dynamic addressLine2;
  String? status;
  String? organizationId;
  dynamic companyName;
  dynamic companyId;
  dynamic serialNo;

  BranchValue({
    this.id,
    this.branchName,
    this.readableId,
    this.pincode,
    this.gstNumber,
    this.stateCode,
    this.phoneNumber,
    this.phoneCountryCode,
    this.firstName,
    this.lastName,
    this.country,
    this.state,
    this.city,
    this.addressLine1,
    this.addressLine2,
    this.status,
    this.organizationId,
    this.companyName,
    this.companyId,
    this.serialNo,
  });

  BranchValue copyWith({
    String? id,
    String? branchName,
    String? readableId,
    String? pincode,
    String? gstNumber,
    String? stateCode,
    dynamic phoneNumber,
    dynamic phoneCountryCode,
    dynamic firstName,
    dynamic lastName,
    String? country,
    String? state,
    String? city,
    String? addressLine1,
    dynamic addressLine2,
    String? status,
    String? organizationId,
    dynamic companyName,
    dynamic companyId,
    dynamic serialNo,
  }) =>
      BranchValue(
        id: id ?? this.id,
        branchName: branchName ?? this.branchName,
        readableId: readableId ?? this.readableId,
        pincode: pincode ?? this.pincode,
        gstNumber: gstNumber ?? this.gstNumber,
        stateCode: stateCode ?? this.stateCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        status: status ?? this.status,
        organizationId: organizationId ?? this.organizationId,
        companyName: companyName ?? this.companyName,
        companyId: companyId ?? this.companyId,
        serialNo: serialNo ?? this.serialNo,
      );

  factory BranchValue.fromRawJson(String str) =>
      BranchValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchValue.fromJson(Map<String, dynamic> json) => BranchValue(
        id: json["id"],
        branchName: json["branch_name"],
        readableId: json["readable_id"],
        pincode: json["pincode"],
        gstNumber: json["gst_number"],
        stateCode: json["state_code"],
        phoneNumber: json["phone_number"],
        phoneCountryCode: json["phone_country_code"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        status: json["status"],
        organizationId: json["organization_id"],
        companyName: json["company_name"],
        companyId: json["company_id"],
        serialNo: json["serial_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_name": branchName,
        "readable_id": readableId,
        "pincode": pincode,
        "gst_number": gstNumber,
        "state_code": stateCode,
        "phone_number": phoneNumber,
        "phone_country_code": phoneCountryCode,
        "first_name": firstName,
        "last_name": lastName,
        "country": country,
        "state": state,
        "city": city,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "status": status,
        "organization_id": organizationId,
        "company_name": companyName,
        "company_id": companyId,
        "serial_no": serialNo,
      };
}
