import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/customer/add_customer/model/get_customer_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/vendor/add_vendor/model/get_vendor_by_id_response.dart';

class GetReorderLevelResponse {
  List<GetReorderLevelResponseValue>? values;
  Pagination? pagination;

  GetReorderLevelResponse({this.values, this.pagination});

  factory GetReorderLevelResponse.fromRawJson(String str) =>
      GetReorderLevelResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReorderLevelResponse.fromJson(Map<String, dynamic> json) =>
      GetReorderLevelResponse(
        values:
            json["values"] == null
                ? []
                : List<GetReorderLevelResponseValue>.from(
                  json["values"]!.map(
                    (x) => GetReorderLevelResponseValue.fromJson(x),
                  ),
                ),
        pagination:
            json["pagination"] == null
                ? null
                : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class GetReorderLevelResponseValue {
  String? id;
  String? purity;
  String? min;
  String? max;
  String? quantityType;
  String? vendorId;
  String? designName;
  String? designCode;
  String? stockHeadCode;
  String? stockHeadName;
  Group? weightGroup;
  Group? sizeGroup;
  GetVendorByIdResponse? vendorDetails;

  GetReorderLevelResponseValue({
    this.id,
    this.purity,
    this.min,
    this.max,
    this.quantityType,
    this.vendorId,
    this.designName,
    this.designCode,
    this.stockHeadCode,
    this.stockHeadName,
    this.weightGroup,
    this.sizeGroup,
    this.vendorDetails,
  });

  factory GetReorderLevelResponseValue.fromRawJson(String str) =>
      GetReorderLevelResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReorderLevelResponseValue.fromJson(Map<String, dynamic> json) =>
      GetReorderLevelResponseValue(
        id: json["id"],
        purity: json["purity"],
        min: json["min"],
        max: json["max"],
        quantityType: json["quantity_type"],
        vendorId: json["vendor_id"],
        designName: json["design_name"],
        designCode: json["design_code"],
        stockHeadCode: json["stock_head_code"],
        stockHeadName: json["stock_head_name"],
        weightGroup:
            json["weight_group"] == null
                ? null
                : Group.fromJson(json["weight_group"]),
        sizeGroup:
            json["size_group"] == null
                ? null
                : Group.fromJson(json["size_group"]),
        vendorDetails:
            json["vendor_details"] == null
                ? null
                : GetVendorByIdResponse.fromJson(json["vendor_details"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "purity": purity,
    "min": min,
    "max": max,
    "quantity_type": quantityType,
    "vendor_id": vendorId,
    "design_name": designName,
    "design_code": designCode,
    "stock_head_code": stockHeadCode,
    "stock_head_name": stockHeadName,
    "weight_group": weightGroup?.toJson(),
    "size_group": sizeGroup?.toJson(),
    "vendor_details": vendorDetails?.toJson(),
  };
}

class Group {
  String? id;
  String? code;
  String? name;

  Group({this.id, this.code, this.name});

  factory Group.fromRawJson(String str) => Group.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Group.fromJson(Map<String, dynamic> json) =>
      Group(id: json["id"], code: json["code"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "code": code, "name": name};
}
