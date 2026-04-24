import 'dart:convert';

class EditStockHeadRequest {
  String? id;
  String? name;
  bool? isNetWeight;
  bool? sizeRequired;
  List<WeightGroup>? weightGroups;
  List<SizeGroup>? sizeGroups;
  CategoryRequest? category;
  EditStockHeadRequest({
    this.id,
    this.name,
    this.isNetWeight,
    this.sizeRequired,
    this.weightGroups,
    this.sizeGroups,
    this.category,
  });

  factory EditStockHeadRequest.fromRawJson(String str) =>
      EditStockHeadRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditStockHeadRequest.fromJson(Map<String, dynamic> json) =>
      EditStockHeadRequest(
        id: json["id"],
        name: json["name"],
        isNetWeight: json["is_net_weight"],
        sizeRequired: json["size_required"],
        weightGroups: json["weight_groups"] == null
            ? []
            : List<WeightGroup>.from(
                json["weight_groups"]!.map((x) => WeightGroup.fromJson(x))),
        sizeGroups: json["size_groups"] == null
            ? []
            : List<SizeGroup>.from(
                json["size_groups"]!.map((x) => SizeGroup.fromJson(x))),
        category: json["category"] == null
            ? null
            : CategoryRequest.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_net_weight": isNetWeight,
        "size_required": sizeRequired,
        "weight_groups": weightGroups == null
            ? []
            : List<dynamic>.from(weightGroups!.map((x) => x.toJson())),
        "size_groups": sizeGroups == null
            ? []
            : List<dynamic>.from(sizeGroups!.map((x) => x.toJson())),
        "category": category?.toJson(),
      };
}

class CategoryRequest {
  String? id;

  CategoryRequest({
    this.id,
  });

  factory CategoryRequest.fromRawJson(String str) =>
      CategoryRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryRequest.fromJson(Map<String, dynamic> json) =>
      CategoryRequest(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class SizeGroup {
  String? code;
  String? size;
  String? id;

  SizeGroup({
    this.code,
    this.size,
    this.id,
  });

  factory SizeGroup.fromRawJson(String str) =>
      SizeGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SizeGroup.fromJson(Map<String, dynamic> json) => SizeGroup(
        code: json["code"],
        size: json["size"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "size": size,
        "id": id,
      };
}

class WeightGroup {
  String? name;
  String? code;
  String? minWeight;
  String? maxWeight;
  String? id;

  WeightGroup({
    this.name,
    this.code,
    this.minWeight,
    this.maxWeight,
    this.id,
  });

  factory WeightGroup.fromRawJson(String str) =>
      WeightGroup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightGroup.fromJson(Map<String, dynamic> json) => WeightGroup(
        name: json["name"],
        code: json["code"],
        minWeight: json["min_weight"],
        maxWeight: json["max_weight"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "min_weight": minWeight,
        "max_weight": maxWeight,
        "id": id,
      };
}
