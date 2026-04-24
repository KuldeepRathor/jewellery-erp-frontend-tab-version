import 'dart:convert';

class AddStockHeadRequest {
  String? name;
  String? code;
  // String? organizationId;
  Category? category;
  bool? isNetWeight;
  String? hallmarkExtraCharge;
  Category? metalType;
  List<WeightGroup>? weightGroups;
  List<SizeGroup>? sizeGroups;
  bool? sizeRequired;

  AddStockHeadRequest({
    this.name,
    this.code,
    // this.organizationId,
    this.category,
    this.isNetWeight,
    this.hallmarkExtraCharge,
    this.metalType,
    this.weightGroups,
    this.sizeGroups,
    this.sizeRequired,
  });

  factory AddStockHeadRequest.fromRawJson(String str) =>
      AddStockHeadRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddStockHeadRequest.fromJson(Map<String, dynamic> json) =>
      AddStockHeadRequest(
        name: json["name"],
        code: json["code"],
        // organizationId: json["organization_id"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        isNetWeight: json["is_net_weight"],
        hallmarkExtraCharge: json["hallmark_extra_charge"],
        metalType: json["metal_type"] == null
            ? null
            : Category.fromJson(json["metal_type"]),
        weightGroups: json["weight_groups"] == null
            ? []
            : List<WeightGroup>.from(
                json["weight_groups"]!.map((x) => WeightGroup.fromJson(x))),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<SizeGroup>.from(
                json["size_groups"]!.map((x) => SizeGroup.fromJson(x))),
        sizeRequired: json["size_required"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        // "organization_id": organizationId,
        "category": category?.toJson(),
        "is_net_weight": isNetWeight,
        "hallmark_extra_charge": hallmarkExtraCharge,
        "metal_type": metalType?.toJson(),
        "weight_groups": weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x.toJson())),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x.toJson())),
        "size_required": sizeRequired,
      };
}

class Category {
  String? id;

  Category({
    this.id,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class SizeGroup {
  String? code;
  String? size;

  SizeGroup({
    this.code,
    this.size,
  });

  factory SizeGroup.fromRawJson(String str) =>
      SizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SizeGroup.fromJson(Map<String, dynamic> json) => SizeGroup(
        code: json["code"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "size": size,
      };
}

class WeightGroup {
  String? name;
  String? code;
  String? minWeight;
  String? maxWeight;

  WeightGroup({
    this.name,
    this.code,
    this.minWeight,
    this.maxWeight,
  });

  factory WeightGroup.fromRawJson(String str) =>
      WeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightGroup.fromJson(Map<String, dynamic> json) => WeightGroup(
        name: json["name"],
        code: json["code"],
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "min_weight": minWeight,
        "max_weight": maxWeight,
      };
}
