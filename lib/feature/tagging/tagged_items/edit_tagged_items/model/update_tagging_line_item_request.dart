import 'dart:convert';

class UpdateTaggingLineItemEditHistoryRequest {
  String? id;
  Design? design;
  Design? sizeGroup;
  String? purity;
  double? netWeight;
  double? grossWeight;
  double? rate;
  String? huid;
  List<dynamic>? images;
  String? oldVendorId;
  String? oldVendorCode;
  String? newVendorId;
  String? newVendorCode;

  UpdateTaggingLineItemEditHistoryRequest({
    this.id,
    this.design,
    this.sizeGroup,
    this.purity,
    this.netWeight,
    this.grossWeight,
    this.rate,
    this.huid,
    this.images,
    this.oldVendorId,
    this.oldVendorCode,
    this.newVendorId,
    this.newVendorCode,
  });

  factory UpdateTaggingLineItemEditHistoryRequest.fromRawJson(String str) =>
      UpdateTaggingLineItemEditHistoryRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateTaggingLineItemEditHistoryRequest.fromJson(
          Map<String, dynamic> json) =>
      UpdateTaggingLineItemEditHistoryRequest(
        id: json["id"],
        design: json["design"] == null ? null : Design.fromJson(json["design"]),
        sizeGroup: json["size_group"] == null
            ? null
            : Design.fromJson(json["size_group"]),
        purity: json["purity"],
        netWeight: json["net_weight"]?.toDouble(),
        grossWeight: json["gross_weight"]?.toDouble(),
        rate: json["rate"]?.toDouble(),
        huid: json["huid"],
        images: json["images"] == null
            ? []
            : List<dynamic>.from(json["images"]!.map((x) => x)),
        oldVendorId: json["old_vendor_id"],
        oldVendorCode: json["old_vendor_code"],
        newVendorId: json["new_vendor_id"],
        newVendorCode: json["new_vendor_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "design": design?.toJson(),
        "size_group": sizeGroup?.toJson(),
        "purity": purity,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "rate": rate,
        "huid": huid,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "old_vendor_id": oldVendorId,
        "old_vendor_code": oldVendorCode,
        "new_vendor_id": newVendorId,
        "new_vendor_code": newVendorCode,
      };
}

class Design {
  String? id;

  Design({
    this.id,
  });

  factory Design.fromRawJson(String str) => Design.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Design.fromJson(Map<String, dynamic> json) => Design(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
