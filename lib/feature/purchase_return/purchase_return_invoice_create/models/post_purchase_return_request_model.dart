import 'dart:convert';

class PurchaseReturnRequestModel {
  bool? isService;
  List<PurchaseReturnRequestLineItem>? lineItems;
  String? organizationId;
  String? partyAddress;
  String? partyCode;
  String? partyGst;
  String? partyId;
  String? partyInvoiceNumber;
  String? partyName;
  String? partyType;
  List<PaymentDetail>? paymentDetails;
  String? remark;
  DateTime? returnCreateDate;
  DateTime? returnReceiveDate;
  String? purchaseRecordId;
  String? voucherType;
  String? voucherSeriesId;

  PurchaseReturnRequestModel({
    this.isService,
    this.lineItems,
    this.organizationId,
    this.partyAddress,
    this.partyCode,
    this.partyGst,
    this.partyId,
    this.partyInvoiceNumber,
    this.partyName,
    this.partyType,
    this.paymentDetails,
    this.remark,
    this.returnCreateDate,
    this.returnReceiveDate,
    this.purchaseRecordId,
    this.voucherType,
    this.voucherSeriesId,
  });

  factory PurchaseReturnRequestModel.fromRawJson(String str) =>
      PurchaseReturnRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseReturnRequestModel.fromJson(Map<String, dynamic> json) =>
      PurchaseReturnRequestModel(
        isService: json["is_service"],
        lineItems: json["line_items"] == null
            ? []
            : List<PurchaseReturnRequestLineItem>.from(json["line_items"]!
                .map((x) => PurchaseReturnRequestLineItem.fromJson(x))),
        organizationId: json["organization_id"],
        partyAddress: json["party_address"],
        partyCode: json["party_code"],
        partyGst: json["party_gst"],
        partyId: json["party_id"],
        partyInvoiceNumber: json["party_invoice_number"],
        partyName: json["party_name"],
        partyType: json["party_type"],
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
        remark: json["remark"],
        returnCreateDate: json["return_create_date"] == null
            ? null
            : DateTime.parse(json["return_create_date"]),
        returnReceiveDate: json["return_receive_date"] == null
            ? null
            : DateTime.parse(json["return_receive_date"]),
        purchaseRecordId: json["purchase_record_id"],
        voucherType: json["voucher_type"],
        voucherSeriesId: json["voucher_series_id"],
      );

  Map<String, dynamic> toJson() => {
        "is_service": isService,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "organization_id": organizationId,
        "party_address": partyAddress,
        "party_code": partyCode,
        "party_gst": partyGst,
        "party_id": partyId,
        "party_invoice_number": partyInvoiceNumber,
        "party_name": partyName,
        "party_type": partyType,
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "remark": remark,
        "return_create_date": returnCreateDate?.toIso8601String(),
        "return_receive_date": returnReceiveDate?.toIso8601String(),
        "purchase_record_id": purchaseRecordId,
        "voucher_type": voucherType,
        "voucher_series_id": voucherSeriesId,
      };
}

class PurchaseReturnRequestLineItem {
  String? amount;
  String? code;
  String? grossWeight;
  String? hsnSac;
  String? hsnSacType;
  String? itemDescription;
  String? less;
  List<PurchaseReturnRequestLineStone>? lineStones;
  String? mc;
  String? netWeight;
  String? organizationId;
  String? ornamentCode;
  String? ornamentId;
  String? ornamentMetalType;
  String? ornamentName;
  int? pieces;
  String? rate;
  String? stone;
  String? tch;
  String? va;

  PurchaseReturnRequestLineItem({
    this.amount,
    this.code,
    this.grossWeight,
    this.hsnSac,
    this.hsnSacType,
    this.itemDescription,
    this.less,
    this.lineStones,
    this.mc,
    this.netWeight,
    this.organizationId,
    this.ornamentCode,
    this.ornamentId,
    this.ornamentMetalType,
    this.ornamentName,
    this.pieces,
    this.rate,
    this.stone,
    this.tch,
    this.va,
  });

  factory PurchaseReturnRequestLineItem.fromRawJson(String str) =>
      PurchaseReturnRequestLineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseReturnRequestLineItem.fromJson(Map<String, dynamic> json) =>
      PurchaseReturnRequestLineItem(
        amount: json["amount"],
        code: json["code"],
        grossWeight: json["gross_weight"],
        hsnSac: json["hsn_sac"],
        hsnSacType: json["hsn_sac_type"],
        itemDescription: json["item_description"],
        less: json["less"],
        lineStones: json["line_stones"] == null
            ? []
            : List<PurchaseReturnRequestLineStone>.from(json["line_stones"]!
                .map((x) => PurchaseReturnRequestLineStone.fromJson(x))),
        mc: json["mc"],
        netWeight: json["net_weight"],
        organizationId: json["organization_id"],
        ornamentCode: json["ornament_code"],
        ornamentId: json["ornament_id"],
        ornamentMetalType: json["ornament_metal_type"],
        ornamentName: json["ornament_name"],
        pieces: json["pieces"],
        rate: json["rate"],
        stone: json["stone"],
        tch: json["tch"],
        va: json["va"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "code": code,
        "gross_weight": grossWeight,
        "hsn_sac": hsnSac,
        "hsn_sac_type": hsnSacType,
        "item_description": itemDescription,
        "less": less,
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
        "mc": mc,
        "net_weight": netWeight,
        "organization_id": organizationId,
        "ornament_code": ornamentCode,
        "ornament_id": ornamentId,
        "ornament_metal_type": ornamentMetalType,
        "ornament_name": ornamentName,
        "pieces": pieces,
        "rate": rate,
        "stone": stone,
        "tch": tch,
        "va": va,
      };
}

class PurchaseReturnRequestLineStone {
  String? carat;
  String? name;
  String? organizationId;
  int? pieces;
  String? rate;
  String? total;
  String? weight;

  PurchaseReturnRequestLineStone({
    this.carat,
    this.name,
    this.organizationId,
    this.pieces,
    this.rate,
    this.total,
    this.weight,
  });

  factory PurchaseReturnRequestLineStone.fromRawJson(String str) =>
      PurchaseReturnRequestLineStone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseReturnRequestLineStone.fromJson(Map<String, dynamic> json) =>
      PurchaseReturnRequestLineStone(
        carat: json["carat"],
        name: json["name"],
        organizationId: json["organization_id"],
        pieces: json["pieces"],
        rate: json["rate"],
        total: json["total"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "carat": carat,
        "name": name,
        "organization_id": organizationId,
        "pieces": pieces,
        "rate": rate,
        "total": total,
        "weight": weight,
      };
}

class PaymentDetail {
  String? cgst;
  String? nett;
  String? roundOff;
  String? sgst;
  String? subTotal;
  String? tcs;
  String? tds;
  String? total;

  PaymentDetail({
    this.cgst,
    this.nett,
    this.roundOff,
    this.sgst,
    this.subTotal,
    this.tcs,
    this.tds,
    this.total,
  });

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        cgst: json["cgst"],
        nett: json["nett"],
        roundOff: json["round_off"],
        sgst: json["sgst"],
        subTotal: json["sub_total"],
        tcs: json["tcs"],
        tds: json["tds"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "cgst": cgst,
        "nett": nett,
        "round_off": roundOff,
        "sgst": sgst,
        "sub_total": subTotal,
        "tcs": tcs,
        "tds": tds,
        "total": total,
      };
}
