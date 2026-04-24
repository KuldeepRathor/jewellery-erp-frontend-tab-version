import 'dart:convert';

class CreateLotEntryRequest {
  String? organizationId;
  String? shopId;
  String? vendorId;
  int? pieces;
  double? netWeight;
  double? grossWeight;
  String? transactionType;

  String? invoiceNumber;
  List<LotPurityRequest>? lotPurity;
  String? status;

  CreateLotEntryRequest({
    this.organizationId,
    this.shopId,
    this.vendorId,
    this.pieces,
    this.netWeight,
    this.grossWeight,
    this.transactionType,
    this.invoiceNumber,
    this.lotPurity,
    this.status,
  });

  factory CreateLotEntryRequest.fromRawJson(String str) =>
      CreateLotEntryRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateLotEntryRequest.fromJson(Map<String, dynamic> json) =>
      CreateLotEntryRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        vendorId: json["vendor_id"],
        pieces: json["pieces"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        transactionType: json["transaction_type"],
        invoiceNumber: json["invoice_number"],
        lotPurity: json["lot_purity"] == null
            ? []
            : List<LotPurityRequest>.from(
                json["lot_purity"]!.map((x) => LotPurityRequest.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "vendor_id": vendorId,
        "pieces": pieces,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "transaction_type": transactionType,
        "invoice_number": invoiceNumber,
        "lot_purity": lotPurity == null
            ? []
            : List<dynamic>.from(lotPurity!.map((x) => x.toJson())),
        "status": status,
      };
}

class LotPurityRequest {
  String? purityType;

  LotPurityRequest({
    this.purityType,
  });

  factory LotPurityRequest.fromRawJson(String str) =>
      LotPurityRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LotPurityRequest.fromJson(Map<String, dynamic> json) =>
      LotPurityRequest(
        purityType: json["purity_type"],
      );

  Map<String, dynamic> toJson() => {
        "purity_type": purityType,
      };
}
