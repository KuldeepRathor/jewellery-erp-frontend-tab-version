import 'dart:convert';

class PurchaseReturnResponseModel {
  String? id;
  String? organizationId;
  String? shopId;
  String? partyType;
  String? partyId;
  String? partyName;
  String? partyCode;
  String? partyAddress;
  String? partyGst;
  String? returnInvoiceNumber;
  DateTime? returnCreateDate;
  DateTime? returnReceiveDate;
  String? remark;
  List<PurchaseReturnResponseLineItem>? lineItems;
  List<PurchaseReturnResponsePaymentDetail>? paymentDetails;

  PurchaseReturnResponseModel({
    this.id,
    this.organizationId,
    this.shopId,
    this.partyType,
    this.partyId,
    this.partyName,
    this.partyCode,
    this.partyAddress,
    this.partyGst,
    this.returnInvoiceNumber,
    this.returnCreateDate,
    this.returnReceiveDate,
    this.remark,
    this.lineItems,
    this.paymentDetails,
  });

  factory PurchaseReturnResponseModel.fromRawJson(String str) =>
      PurchaseReturnResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseReturnResponseModel.fromJson(Map<String, dynamic> json) =>
      PurchaseReturnResponseModel(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyCode: json["party_code"],
        partyAddress: json["party_address"],
        partyGst: json["party_gst"],
        returnInvoiceNumber: json["return_invoice_number"],
        returnCreateDate: json["return_create_date"] == null
            ? null
            : DateTime.parse(json["return_create_date"]),
        returnReceiveDate: json["return_receive_date"] == null
            ? null
            : DateTime.parse(json["return_receive_date"]),
        remark: json["remark"],
        lineItems: json["line_items"] == null
            ? []
            : List<PurchaseReturnResponseLineItem>.from(json["line_items"]!
                .map((x) => PurchaseReturnResponseLineItem.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PurchaseReturnResponsePaymentDetail>.from(
                json["payment_details"]!.map(
                    (x) => PurchaseReturnResponsePaymentDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "party_type": partyType,
        "party_id": partyId,
        "party_name": partyName,
        "party_code": partyCode,
        "party_address": partyAddress,
        "party_gst": partyGst,
        "return_invoice_number": returnInvoiceNumber,
        "return_create_date": returnCreateDate?.toIso8601String(),
        "return_receive_date": returnReceiveDate?.toIso8601String(),
        "remark": remark,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      };
}

class PurchaseReturnResponseLineItem {
  String? id;
  String? organizationId;
  String? ornamentId;
  String? code;
  String? itemDescription;
  int? pieces;
  String? grossWeight;
  String? less;
  String? netWeight;
  dynamic va;
  String? tch;
  String? mc;
  String? stone;
  String? rate;
  String? amount;
  String? purchaseReturnId;
  List<dynamic>? lineStones;

  PurchaseReturnResponseLineItem({
    this.id,
    this.organizationId,
    this.ornamentId,
    this.code,
    this.itemDescription,
    this.pieces,
    this.grossWeight,
    this.less,
    this.netWeight,
    this.va,
    this.tch,
    this.mc,
    this.stone,
    this.rate,
    this.amount,
    this.purchaseReturnId,
    this.lineStones,
  });

  factory PurchaseReturnResponseLineItem.fromRawJson(String str) =>
      PurchaseReturnResponseLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseReturnResponseLineItem.fromJson(Map<String, dynamic> json) =>
      PurchaseReturnResponseLineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        ornamentId: json["ornament_id"],
        code: json["code"],
        itemDescription: json["item_description"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        less: json["less"],
        netWeight: json["net_weight"],
        va: json["va"],
        tch: json["tch"],
        mc: json["mc"],
        stone: json["stone"],
        rate: json["rate"],
        amount: json["amount"],
        purchaseReturnId: json["purchase_return_id"],
        lineStones: json["line_stones"] == null
            ? []
            : List<dynamic>.from(json["line_stones"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "ornament_id": ornamentId,
        "code": code,
        "item_description": itemDescription,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "less": less,
        "net_weight": netWeight,
        "va": va,
        "tch": tch,
        "mc": mc,
        "stone": stone,
        "rate": rate,
        "amount": amount,
        "purchase_return_id": purchaseReturnId,
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x)),
      };
}

class PurchaseReturnResponsePaymentDetail {
  String? id;
  String? organizationId;
  String? purchaseReturnId;
  String? subTotal;
  String? nett;
  String? cgst;
  String? sgst;
  dynamic igst;
  String? roundOff;
  String? total;
  dynamic tcs;
  String? tds;

  PurchaseReturnResponsePaymentDetail({
    this.id,
    this.organizationId,
    this.purchaseReturnId,
    this.subTotal,
    this.nett,
    this.cgst,
    this.sgst,
    this.igst,
    this.roundOff,
    this.total,
    this.tcs,
    this.tds,
  });

  factory PurchaseReturnResponsePaymentDetail.fromRawJson(String str) =>
      PurchaseReturnResponsePaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseReturnResponsePaymentDetail.fromJson(
          Map<String, dynamic> json) =>
      PurchaseReturnResponsePaymentDetail(
        id: json["id"],
        organizationId: json["organization_id"],
        purchaseReturnId: json["purchase_return_id"],
        subTotal: json["sub_total"],
        nett: json["nett"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        roundOff: json["round_off"],
        total: json["total"],
        tcs: json["tcs"],
        tds: json["tds"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "purchase_return_id": purchaseReturnId,
        "sub_total": subTotal,
        "nett": nett,
        "cgst": cgst,
        "sgst": sgst,
        "igst": igst,
        "round_off": roundOff,
        "total": total,
        "tcs": tcs,
        "tds": tds,
      };
}
