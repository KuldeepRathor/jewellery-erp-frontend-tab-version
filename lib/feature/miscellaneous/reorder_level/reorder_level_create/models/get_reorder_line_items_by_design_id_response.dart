import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';

class GetReorderLineItemsResponse {
  String? stockHeadId;
  String? designId;
  List<GetReorderLineItemsResponseValues>? values;

  GetReorderLineItemsResponse({this.stockHeadId, this.designId, this.values});

  factory GetReorderLineItemsResponse.fromRawJson(String str) =>
      GetReorderLineItemsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReorderLineItemsResponse.fromJson(Map<String, dynamic> json) =>
      GetReorderLineItemsResponse(
        stockHeadId: json["stock_head_id"],
        designId: json["design_id"],
        values:
            json["values"] == null
                ? []
                : List<GetReorderLineItemsResponseValues>.from(
                  json["values"]!.map(
                    (x) => GetReorderLineItemsResponseValues.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "stock_head_id": stockHeadId,
    "design_id": designId,
    "values":
        values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

class GetReorderLineItemsResponseValues {
  String? id;
  String? weightGroup;
  String? weightGroupCode;
  String? weightGroupName;
  String? sizeGroup;
  String? sizeGroupCode;
  String? sizeGroupName;
  String? purity;
  String? min;
  String? max;
  String? quantityType;
  String? vendorId;
  VendorSearchValue? vendorDetails;

  GetReorderLineItemsResponseValues({
    this.id,
    this.weightGroup,
    this.weightGroupCode,
    this.weightGroupName,
    this.sizeGroup,
    this.sizeGroupCode,
    this.sizeGroupName,
    this.purity,
    this.min,
    this.max,
    this.quantityType,
    this.vendorId,
    this.vendorDetails,
  });

  factory GetReorderLineItemsResponseValues.fromRawJson(String str) =>
      GetReorderLineItemsResponseValues.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReorderLineItemsResponseValues.fromJson(
    Map<String, dynamic> json,
  ) => GetReorderLineItemsResponseValues(
    id: json["id"],
    weightGroup: json["weight_group"],
    weightGroupCode: json["weight_group_code"],
    weightGroupName: json["weight_group_name"],
    sizeGroup: json["size_group"],
    sizeGroupCode: json["size_group_code"],
    sizeGroupName: json["size_group_name"],
    purity: json["purity"],
    min: json["min"],
    max: json["max"],
    quantityType: json["quantity_type"],
    vendorId: json["vendor_id"],
    vendorDetails:
        json["vendor_details"] == null
            ? null
            : VendorSearchValue.fromJson(json["vendor_details"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "weight_group": weightGroup,
    "weight_group_code": weightGroupCode,
    "weight_group_name": weightGroupName,
    "size_group": sizeGroup,
    "size_group_code": sizeGroupCode,
    "size_group_name": sizeGroupName,
    "purity": purity,
    "min": min,
    "max": max,
    "quantity_type": quantityType,
    "vendor_id": vendorId,
    "vendor_details": vendorDetails?.toJson(),
  };
}
