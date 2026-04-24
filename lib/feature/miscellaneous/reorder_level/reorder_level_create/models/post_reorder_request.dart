import 'dart:convert';

class PostReorderRequest {
  String? designId;
  String? stockHeadId;
  List<PostReorderRequestLineItems>? values;

  PostReorderRequest({
    this.designId,
    this.stockHeadId,
    this.values,
  });

  factory PostReorderRequest.fromRawJson(String str) =>
      PostReorderRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostReorderRequest.fromJson(Map<String, dynamic> json) =>
      PostReorderRequest(
        designId: json["design_id"],
        stockHeadId: json["stock_head_id"],
        values: json["values"] == null
            ? []
            : List<PostReorderRequestLineItems>.from(json["values"]!
                .map((x) => PostReorderRequestLineItems.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "design_id": designId,
        "stock_head_id": stockHeadId,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class PostReorderRequestLineItems {
  String? max;
  String? min;
  String? purity;
  String? quantityType;
  String? sizeGroupId;
  String? vendorId;
  String? weightGroupId;
  String? id;

  PostReorderRequestLineItems({
    this.max,
    this.min,
    this.purity,
    this.quantityType,
    this.sizeGroupId,
    this.vendorId,
    this.weightGroupId,
    this.id,
  });

  factory PostReorderRequestLineItems.fromRawJson(String str) =>
      PostReorderRequestLineItems.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostReorderRequestLineItems.fromJson(Map<String, dynamic> json) =>
      PostReorderRequestLineItems(
        max: json["max"],
        min: json["min"],
        purity: json["purity"],
        quantityType: json["quantity_type"],
        sizeGroupId: json["size_group_id"],
        vendorId: json["vendor_id"],
        weightGroupId: json["weight_group_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "max": max,
        "min": min,
        "purity": purity,
        "quantity_type": quantityType,
        "size_group_id": sizeGroupId,
        "vendor_id": vendorId,
        "weight_group_id": weightGroupId,
        "id": id,
      };
}
