import 'dart:convert';

import '../../../../vendor/add_vendor/model/get_address_model.dart';

class CustomerSearchModel {
  List<CustomerSearchValue>? values;
  Pagination? pagination;

  CustomerSearchModel({
    this.values,
    this.pagination,
  });

  factory CustomerSearchModel.fromRawJson(String str) =>
      CustomerSearchModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerSearchModel.fromJson(Map<String, dynamic> json) =>
      CustomerSearchModel(
        values: json["values"] == null
            ? []
            : List<CustomerSearchValue>.from(
                json["values"]!.map((x) => CustomerSearchValue.fromJson(x))),
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

class CustomerSearchValue {
  String? id;
  dynamic externalId;
  String? readableId;
  String? phoneNumber;
  String? name;
  DateTime? dateOfBirth;
  String? panNumber;
  String? gstNumber;
  String? organizationId;
  dynamic addressUuid;
  String? gender;
  List<dynamic>? nominees;
  List<Address>? address;
  String? deductionType;
  String? deductionPercent;

  CustomerSearchValue({
    this.id,
    this.externalId,
    this.readableId,
    this.phoneNumber,
    this.name,
    this.dateOfBirth,
    this.panNumber,
    this.gstNumber,
    this.organizationId,
    this.addressUuid,
    this.gender,
    this.nominees,
    this.address,
    this.deductionType,
    this.deductionPercent,
  });

  factory CustomerSearchValue.fromRawJson(String str) =>
      CustomerSearchValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerSearchValue.fromJson(Map<String, dynamic> json) =>
      CustomerSearchValue(
        id: json["id"],
        externalId: json["external_id"],
        readableId: json["readable_id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        panNumber: json["pan_number"],
        gstNumber: json["gst_number"],
        organizationId: json["organization_id"],
        addressUuid: json["address_uuid"],
        gender: json["gender"],
        nominees: json["nominees"] == null
            ? []
            : List<dynamic>.from(json["nominees"]!.map((x) => x)),
        address: json["address"] == null
            ? []
            : List<Address>.from(
                json["address"]!.map((x) => Address.fromJson(x))),
        deductionType: json["deduction_type"],
        deductionPercent: json["deduction_percent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "external_id": externalId,
        "readable_id": readableId,
        "phone_number": phoneNumber,
        "name": name,
        "date_of_birth":
            "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
        "pan_number": panNumber,
        "gst_number": gstNumber,
        "organization_id": organizationId,
        "address_uuid": addressUuid,
        "gender": gender,
        "nominees":
            nominees == null ? [] : List<dynamic>.from(nominees!.map((x) => x)),
        "address": address == null
            ? []
            : List<dynamic>.from(address!.map((x) => x.toJson())),
        "deduction_type": deductionType,
        "deduction_percent": deductionPercent,
      };
}
