import 'dart:convert';

class TaggingRecordRequest {
  String? taggedById;
  List<TaggingLineItem>? lineItems;

  TaggingRecordRequest({
    this.taggedById,
    this.lineItems,
  });

  factory TaggingRecordRequest.fromRawJson(String str) =>
      TaggingRecordRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggingRecordRequest.fromJson(Map<String, dynamic> json) =>
      TaggingRecordRequest(
        taggedById: json["tagged_by_id"],
        lineItems: json["line_items"] == null
            ? []
            : List<TaggingLineItem>.from(
                json["line_items"]!.map((x) => TaggingLineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tagged_by_id": taggedById,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class TaggingLineItem {
  String? organizationId;
  String? shopId;
  String? taggingRecordId;
  String? vendorId;
  String? code;
  String? codeId;
  String? codeType;

  String? tagBarcode;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? va;
  String? mc;
  String? rate;
  String? huid;
  String? purity;
  Design? design;
  Design? sizeGroup;
  Design? counter;
  String? metalColorId;
  String? gender;
  List<String>? qcEmployeeIds;
  List<Image>? images;
  List<LineStone>? lineStones;
  String? vendorCode;
  TaggingLineItem({
    this.organizationId,
    this.shopId,
    this.taggingRecordId,
    this.vendorId,
    this.code,
    this.codeType,
    this.codeId,
    this.tagBarcode,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.va,
    this.mc,
    this.rate,
    this.huid,
    this.purity,
    this.design,
    this.sizeGroup,
    this.counter,
    this.metalColorId,
    this.gender,
    this.qcEmployeeIds,
    this.images,
    this.lineStones,
    this.vendorCode,
  });

  factory TaggingLineItem.fromRawJson(String str) =>
      TaggingLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaggingLineItem.fromJson(Map<String, dynamic> json) =>
      TaggingLineItem(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        taggingRecordId: json["tagging_record_id"],
        vendorId: json["vendor_id"],
        code: json["code"],
        codeType: json["code_type"],
        codeId: json["code_id"],
        tagBarcode: json["tag_barcode"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        va: json["va"],
        mc: json["mc"],
        rate: json["rate"],
        huid: json["huid"],
        purity: json["purity"],
        design: json["design"] == null ? null : Design.fromJson(json["design"]),
        sizeGroup: json["size_group"] == null
            ? null
            : Design.fromJson(json["size_group"]),
        counter:
            json["counter"] == null ? null : Design.fromJson(json["counter"]),
        metalColorId: json["metal_color_id"],
        gender: json["gender"],
        qcEmployeeIds: json["qc_employee_ids"] == null
            ? []
            : List<String>.from(json["qc_employee_ids"]!.map((x) => x)),
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        lineStones: json["line_stones"] == null
            ? []
            : List<LineStone>.from(
                json["line_stones"]!.map((x) => LineStone.fromJson(x))),
        vendorCode: json["vendor_code"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "tagging_record_id": taggingRecordId,
        "vendor_id": vendorId,
        "code": code,
        "code_type": codeType,
        "code_id": codeId,
        "tag_barcode": tagBarcode,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "va": va,
        "mc": mc,
        "rate": rate,
        "huid": huid,
        "purity": purity,
        "design": design?.toJson(),
        "size_group": sizeGroup?.toJson(),
        "counter": counter?.toJson(),
        "metal_color_id": metalColorId,
        "gender": gender,
        "qc_employee_ids": qcEmployeeIds == null
            ? []
            : List<dynamic>.from(qcEmployeeIds!.map((x) => x)),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
        "vendor_code": vendorCode,
      };

  static List<TaggingLineItem> dummyData = List.generate(5, (index) {
    return TaggingLineItem(
      vendorId: 'Vendor${index + 1}',
      code: 'CODE${100 + index}',
      codeId: 'CodeId${index + 1}',
      tagBarcode: '978020137962',
      pieces: (index + 1) * 5,
      grossWeight: '${(index + 1) * 10.5}kg',
      netWeight: '${(index + 1) * 9.5}kg',
      va: 'VA${index + 1}',
      mc: 'MC${index + 1}',
      rate: '${(index + 1) * 50.75}',
      huid: 'HUID${1000 + index}',
      purity: '99%',
      design: Design(id: 'DesignId${index + 1}'),
      sizeGroup: Design(id: 'SizeGroupId${index + 1}'),
      counter: Design(id: 'CounterId${index + 1}'),
    );
  });
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

class Image {
  String? id;
  String? fileName;
  String? fileType;
  String? s3Key;
  String? presignedUrl;

  Image({
    this.id,
    this.fileName,
    this.fileType,
    this.s3Key,
    this.presignedUrl,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        s3Key: json["s3_key"],
        presignedUrl: json["presigned_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_type": fileType,
        "s3_key": s3Key,
        "presigned_url": presignedUrl,
      };
}

class LineStone {
  String? taggingLineItemId;
  String? organizationId;
  String? shopId;
  String? referenceStoneId;
  String? name;
  int? pieces;
  String? carat;
  String? weight;
  String? rate;
  String? total;

  LineStone({
    this.taggingLineItemId,
    this.organizationId,
    this.shopId,
    this.referenceStoneId,
    this.name,
    this.pieces,
    this.carat,
    this.weight,
    this.rate,
    this.total,
  });

  factory LineStone.fromRawJson(String str) =>
      LineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineStone.fromJson(Map<String, dynamic> json) => LineStone(
        taggingLineItemId: json["tagging_line_item_id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        referenceStoneId: json["reference_stone_id"],
        name: json["name"],
        pieces: json["pieces"],
        carat: json["carat"],
        weight: json["weight"],
        rate: json["rate"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item_id": taggingLineItemId,
        "organization_id": organizationId,
        "shop_id": shopId,
        "reference_stone_id": referenceStoneId,
        "name": name,
        "pieces": pieces,
        "carat": carat,
        "weight": weight,
        "rate": rate,
        "total": total,
      };
}
