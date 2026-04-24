import 'dart:convert';

class GetTagPreferenceResponse {
  dynamic organizationId;
  bool? lotBasedTaggingOnly;
  bool? autoCreateLotPurchase;
  bool? autoCreateLotMaterialIn;
  bool? autoCreateLotSalesReturn;
  bool? autoCreateLotStockDifference;

  GetTagPreferenceResponse({
    this.organizationId,
    this.lotBasedTaggingOnly,
    this.autoCreateLotPurchase,
    this.autoCreateLotMaterialIn,
    this.autoCreateLotSalesReturn,
    this.autoCreateLotStockDifference,
  });

  factory GetTagPreferenceResponse.fromRawJson(String str) =>
      GetTagPreferenceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTagPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      GetTagPreferenceResponse(
        organizationId: json["organization_id"],
        lotBasedTaggingOnly: json["lot_based_tagging_only"],
        autoCreateLotPurchase: json["auto_create_lot_purchase"],
        autoCreateLotMaterialIn: json["auto_create_lot_material_in"],
        autoCreateLotSalesReturn: json["auto_create_lot_sales_return"],
        autoCreateLotStockDifference: json["auto_create_lot_stock_difference"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "lot_based_tagging_only": lotBasedTaggingOnly,
        "auto_create_lot_purchase": autoCreateLotPurchase,
        "auto_create_lot_material_in": autoCreateLotMaterialIn,
        "auto_create_lot_sales_return": autoCreateLotSalesReturn,
        "auto_create_lot_stock_difference": autoCreateLotStockDifference,
      };
}
