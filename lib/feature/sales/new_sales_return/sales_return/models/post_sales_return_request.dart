import 'dart:convert';

class PostSalesReturnRequest {
  String? voucherType;
  String? voucherSeriesId;
  String? organizationId;
  String? shopId;
  String? partyId;
  String? partyType;
  String? partyName;
  String? saleReturnNumber;
  String? saleRecordId;
  String? remarks;
  List<PostSalesReturnLineItemRequest>? lineItems;
  List<PostSalesReturnPaymentDetailRequest>? paymentDetails;

  PostSalesReturnRequest({
    this.voucherType,
    this.voucherSeriesId,
    this.organizationId,
    this.shopId,
    this.partyId,
    this.partyType,
    this.partyName,
    this.saleReturnNumber,
    this.saleRecordId,
    this.remarks,
    this.lineItems,
    this.paymentDetails,
  });

  factory PostSalesReturnRequest.fromRawJson(String str) =>
      PostSalesReturnRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSalesReturnRequest.fromJson(Map<String, dynamic> json) =>
      PostSalesReturnRequest(
        voucherType: json["voucher_type"],
        voucherSeriesId: json["voucher_series_id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        partyId: json["party_id"],
        partyType: json["party_type"],
        partyName: json["party_name"],
        saleReturnNumber: json["sale_return_number"],
        saleRecordId: json["sale_record_id"],
        remarks: json["remarks"],
        lineItems: json["line_items"] == null
            ? []
            : List<PostSalesReturnLineItemRequest>.from(json["line_items"]!
                .map((x) => PostSalesReturnLineItemRequest.fromJson(x))),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PostSalesReturnPaymentDetailRequest>.from(
                json["payment_details"]!.map(
                    (x) => PostSalesReturnPaymentDetailRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "voucher_type": voucherType,
        "voucher_series_id": voucherSeriesId,
        "organization_id": organizationId,
        "shop_id": shopId,
        "party_id": partyId,
        "party_type": partyType,
        "party_name": partyName,
        "sale_return_number": saleReturnNumber,
        "sale_record_id": saleRecordId,
        "remarks": remarks,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
      };
}

class PostSalesReturnLineItemRequest {
  String? organizationId;
  String? shopId;
  String? ornamentId;
  String? designCode;
  String? ornamentCode;
  String? ornamentName;
  String? saleReturnRecordId;
  String? saleLineItemId;
  String? code;
  String? taggingId;
  String? tag;
  String? description;
  String? salesPersonId;
  double? pieces;
  double? grossWeight;
  double? netWeight;
  double? taggingVa;
  double? finalVa;
  double? taggingMc;
  double? finalMc;
  double? stoneCost;
  double? hallMark;
  double? discount;
  double? salesAmount;
  double? totalAmount;

  PostSalesReturnLineItemRequest({
    this.organizationId,
    this.shopId,
    this.ornamentId,
    this.designCode,
    this.ornamentCode,
    this.ornamentName,
    this.saleReturnRecordId,
    this.saleLineItemId,
    this.code,
    this.taggingId,
    this.tag,
    this.description,
    this.salesPersonId,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.taggingVa,
    this.finalVa,
    this.taggingMc,
    this.finalMc,
    this.stoneCost,
    this.hallMark,
    this.discount,
    this.salesAmount,
    this.totalAmount,
  });

  factory PostSalesReturnLineItemRequest.fromRawJson(String str) =>
      PostSalesReturnLineItemRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSalesReturnLineItemRequest.fromJson(Map<String, dynamic> json) =>
      PostSalesReturnLineItemRequest(
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        ornamentId: json["ornament_id"],
        designCode: json["design_code"],
        ornamentCode: json["ornament_code"],
        ornamentName: json["ornament_name"],
        saleReturnRecordId: json["sale_return_record_id"],
        saleLineItemId: json["sale_line_item_id"],
        code: json["code"],
        taggingId: json["tagging_id"],
        tag: json["tag"],
        description: json["description"],
        salesPersonId: json["sales_person_id"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        taggingVa: json["tagging_va"],
        finalVa: json["final_va"],
        taggingMc: json["tagging_mc"],
        finalMc: json["final_mc"],
        stoneCost: json["stone_cost"],
        hallMark: json["hall_mark"],
        discount: json["discount"],
        salesAmount: json["sales_amount"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "shop_id": shopId,
        "ornament_id": ornamentId,
        "design_code": designCode,
        "ornament_code": ornamentCode,
        "ornament_name": ornamentName,
        "sale_return_record_id": saleReturnRecordId,
        "sale_line_item_id": saleLineItemId,
        "code": code,
        "tagging_id": taggingId,
        "tag": tag,
        "description": description,
        "sales_person_id": salesPersonId,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "tagging_va": taggingVa,
        "final_va": finalVa,
        "tagging_mc": taggingMc,
        "final_mc": finalMc,
        "stone_cost": stoneCost,
        "hall_mark": hallMark,
        "discount": discount,
        "sales_amount": salesAmount,
        "total_amount": totalAmount,
      };
}

class PostSalesReturnPaymentDetailRequest {
  String? organizationId;
  bool? isConsumed;
  String? balance;
  String? subTotal;
  String? schemeDiscount;
  String? rateDiscount;
  String? salesAmount;
  String? amount;
  String? cgst;
  String? sgst;
  String? igst;
  String? nettGst;
  String? tcs;
  String? tds;
  String? nettTdsTcs;
  String? purchaseOldGold;
  String? advance;
  String? roundOff;
  String? bankCharges;
  String? finalAmount;
  String? saleReturnRecordId;

  PostSalesReturnPaymentDetailRequest({
    this.organizationId,
    this.isConsumed,
    this.balance,
    this.subTotal,
    this.schemeDiscount,
    this.rateDiscount,
    this.salesAmount,
    this.amount,
    this.cgst,
    this.sgst,
    this.igst,
    this.nettGst,
    this.tcs,
    this.tds,
    this.nettTdsTcs,
    this.purchaseOldGold,
    this.advance,
    this.roundOff,
    this.bankCharges,
    this.finalAmount,
    this.saleReturnRecordId,
  });

  factory PostSalesReturnPaymentDetailRequest.fromRawJson(String str) =>
      PostSalesReturnPaymentDetailRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostSalesReturnPaymentDetailRequest.fromJson(
          Map<String, dynamic> json) =>
      PostSalesReturnPaymentDetailRequest(
        organizationId: json["organization_id"],
        isConsumed: json["is_consumed"],
        balance: json["balance"],
        subTotal: json["sub_total"],
        schemeDiscount: json["scheme_discount"],
        rateDiscount: json["rate_discount"],
        salesAmount: json["sales_amount"],
        amount: json["amount"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        nettGst: json["nett_gst"],
        tcs: json["tcs"],
        tds: json["tds"],
        nettTdsTcs: json["nett_tds_tcs"],
        purchaseOldGold: json["purchase_old_gold"],
        advance: json["advance"],
        roundOff: json["round_off"],
        bankCharges: json["bank_charges"],
        finalAmount: json["final_amount"],
        saleReturnRecordId: json["sale_return_record_id"],
      );

  Map<String, dynamic> toJson() => {
        "organization_id": organizationId,
        "is_consumed": isConsumed,
        "balance": balance,
        "sub_total": subTotal,
        "scheme_discount": schemeDiscount,
        "rate_discount": rateDiscount,
        "sales_amount": salesAmount,
        "amount": amount,
        "cgst": cgst,
        "sgst": sgst,
        "igst": igst,
        "nett_gst": nettGst,
        "tcs": tcs,
        "tds": tds,
        "nett_tds_tcs": nettTdsTcs,
        "purchase_old_gold": purchaseOldGold,
        "advance": advance,
        "round_off": roundOff,
        "bank_charges": bankCharges,
        "final_amount": finalAmount,
        "sale_return_record_id": saleReturnRecordId,
      };
}
