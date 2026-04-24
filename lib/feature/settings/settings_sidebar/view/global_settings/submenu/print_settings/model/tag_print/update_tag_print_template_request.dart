import 'dart:convert';

class UpdateTagPrintTemplateRequest {
  bool? leftDesignName;
  bool? leftVendor;
  bool? leftTagNumber;
  bool? leftStoneWeight;
  bool? leftGrossWeight;
  bool? leftNetWeight;
  bool? leftPurity;
  bool? leftVaTypeGms;
  bool? leftSize;
  bool? leftHuid;
  bool? leftBarcodeNumber;
  bool? rightDesignName;
  bool? rightVendor;
  bool? rightTagNumber;
  bool? rightStoneWeight;
  bool? rightGrossWeight;
  bool? rightNetWeight;
  bool? rightPurity;
  bool? rightVaTypeGms;
  bool? rightSize;
  bool? rightHuid;
  bool? rightBarcodeNumber;

  UpdateTagPrintTemplateRequest({
    this.leftDesignName,
    this.leftVendor,
    this.leftTagNumber,
    this.leftStoneWeight,
    this.leftGrossWeight,
    this.leftNetWeight,
    this.leftPurity,
    this.leftVaTypeGms,
    this.leftSize,
    this.leftHuid,
    this.leftBarcodeNumber,
    this.rightDesignName,
    this.rightVendor,
    this.rightTagNumber,
    this.rightStoneWeight,
    this.rightGrossWeight,
    this.rightNetWeight,
    this.rightPurity,
    this.rightVaTypeGms,
    this.rightSize,
    this.rightHuid,
    this.rightBarcodeNumber,
  });

  factory UpdateTagPrintTemplateRequest.fromRawJson(String str) =>
      UpdateTagPrintTemplateRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateTagPrintTemplateRequest.fromJson(Map<String, dynamic> json) =>
      UpdateTagPrintTemplateRequest(
        leftDesignName: json["left_design_name"],
        leftVendor: json["left_vendor"],
        leftTagNumber: json["left_tag_number"],
        leftStoneWeight: json["left_stone_weight"],
        leftGrossWeight: json["left_gross_weight"],
        leftNetWeight: json["left_net_weight"],
        leftPurity: json["left_purity"],
        leftVaTypeGms: json["left_va_type_gms"],
        leftSize: json["left_size"],
        leftHuid: json["left_huid"],
        leftBarcodeNumber: json["left_barcode_number"],
        rightDesignName: json["right_design_name"],
        rightVendor: json["right_vendor"],
        rightTagNumber: json["right_tag_number"],
        rightStoneWeight: json["right_stone_weight"],
        rightGrossWeight: json["right_gross_weight"],
        rightNetWeight: json["right_net_weight"],
        rightPurity: json["right_purity"],
        rightVaTypeGms: json["right_va_type_gms"],
        rightSize: json["right_size"],
        rightHuid: json["right_huid"],
        rightBarcodeNumber: json["right_barcode_number"],
      );

  Map<String, dynamic> toJson() => {
        "left_design_name": leftDesignName,
        "left_vendor": leftVendor,
        "left_tag_number": leftTagNumber,
        "left_stone_weight": leftStoneWeight,
        "left_gross_weight": leftGrossWeight,
        "left_net_weight": leftNetWeight,
        "left_purity": leftPurity,
        "left_va_type_gms": leftVaTypeGms,
        "left_size": leftSize,
        "left_huid": leftHuid,
        "left_barcode_number": leftBarcodeNumber,
        "right_design_name": rightDesignName,
        "right_vendor": rightVendor,
        "right_tag_number": rightTagNumber,
        "right_stone_weight": rightStoneWeight,
        "right_gross_weight": rightGrossWeight,
        "right_net_weight": rightNetWeight,
        "right_purity": rightPurity,
        "right_va_type_gms": rightVaTypeGms,
        "right_size": rightSize,
        "right_huid": rightHuid,
        "right_barcode_number": rightBarcodeNumber,
      };
}
