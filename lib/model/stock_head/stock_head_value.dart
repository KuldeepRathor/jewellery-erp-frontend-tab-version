import 'dart:convert';

import 'package:jewellery_erp_frontend_tab_version/model/stock_head/size_group_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_category.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/stock_head_response.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stock_head/weight_group_response.dart';

class StockHeadValue {
  String? id;
  String? name;
  String? code;
  String? organizationId;
  StockHeadCategory? category;
  String? hallmarkExtraCharge;
  MetalType? metalType;
  bool? sizeRequired;
  List<WeightGroup>? weightGroups;
  List<SizeGroup>? sizeGroups;

  StockHeadValue({
    this.id,
    this.name,
    this.code,
    this.organizationId,
    this.category,
    this.hallmarkExtraCharge,
    this.metalType,
    this.sizeRequired,
    this.weightGroups,
    this.sizeGroups,
  });

  factory StockHeadValue.fromRawJson(String str) =>
      StockHeadValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StockHeadValue.fromJson(Map<String, dynamic> json) => StockHeadValue(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    organizationId: json["organization_id"],
    category:
        json["category"] == null
            ? null
            : StockHeadCategory.fromJson(json["category"]),
    hallmarkExtraCharge: json["hallmark_extra_charge"],
    metalType:
        json["metal_type"] == null
            ? null
            : MetalType.fromJson(json["metal_type"]),
    sizeRequired: json["size_required"],
    weightGroups:
        json["weight_groups"] == null
            ? []
            : List<WeightGroup>.from(
              json["weight_groups"]!.map((x) => WeightGroup.fromJson(x)),
            ),
    sizeGroups:
        json["size_groups"] == null
            ? []
            : List<SizeGroup>.from(
              json["size_groups"]!.map((x) => SizeGroup.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "organization_id": organizationId,
    "category": category?.toJson(),
    "hallmark_extra_charge": hallmarkExtraCharge,
    "metal_type": metalType?.toJson(),
    "size_required": sizeRequired,
    "weight_groups":
        weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x.toJson())),
    "size_groups":
        sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x.toJson())),
  };
}
