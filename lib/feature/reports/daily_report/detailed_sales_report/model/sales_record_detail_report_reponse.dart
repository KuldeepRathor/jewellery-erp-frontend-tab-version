import 'dart:convert';

class SalesRecordDetailReportResponse {
  List<SalesRecordDetailReportValue>? values;
  SalesRecordDetailReportTotal? total;
  List<SalesRecordDetailReportStoneData>? stoneData;
  SalesRecordDetailReportStoneTotal? stoneTotal;

  SalesRecordDetailReportResponse({
    this.values,
    this.total,
    this.stoneData,
    this.stoneTotal,
  });

  factory SalesRecordDetailReportResponse.fromRawJson(String str) =>
      SalesRecordDetailReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesRecordDetailReportResponse.fromJson(Map<String, dynamic> json) =>
      SalesRecordDetailReportResponse(
        values: json["values"] == null
            ? []
            : List<SalesRecordDetailReportValue>.from(json["values"]!
                .map((x) => SalesRecordDetailReportValue.fromJson(x))),
        total: json["total"] == null
            ? null
            : SalesRecordDetailReportTotal.fromJson(json["total"]),
        stoneData: json["stone_data"] == null
            ? []
            : List<SalesRecordDetailReportStoneData>.from(json["stone_data"]!
                .map((x) => SalesRecordDetailReportStoneData.fromJson(x))),
        stoneTotal: json["stone_total"] == null
            ? null
            : SalesRecordDetailReportStoneTotal.fromJson(json["stone_total"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "total": total?.toJson(),
        "stone_data": stoneData == null
            ? []
            : List<dynamic>.from(stoneData!.map((x) => x.toJson())),
        "stone_total": stoneTotal?.toJson(),
      };
}

class SalesRecordDetailReportStoneData {
  String? stoneId;
  String? stoneCode;
  String? stoneName;
  int? pieces;
  String? weight;
  String? carat;
  String? totalAmount;
  dynamic ornamentCode;
  dynamic ornamentId;

  SalesRecordDetailReportStoneData({
    this.stoneId,
    this.stoneCode,
    this.stoneName,
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
    this.ornamentCode,
    this.ornamentId,
  });

  factory SalesRecordDetailReportStoneData.fromRawJson(String str) =>
      SalesRecordDetailReportStoneData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesRecordDetailReportStoneData.fromJson(
          Map<String, dynamic> json) =>
      SalesRecordDetailReportStoneData(
        stoneId: json["stone_id"],
        stoneCode: json["stone_code"],
        stoneName: json["stone_name"],
        pieces: json["pieces"],
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
        ornamentCode: json["ornament_code"],
        ornamentId: json["ornament_id"],
      );

  Map<String, dynamic> toJson() => {
        "stone_id": stoneId,
        "stone_code": stoneCode,
        "stone_name": stoneName,
        "pieces": pieces,
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
        "ornament_code": ornamentCode,
        "ornament_id": ornamentId,
      };
}

class SalesRecordDetailReportStoneTotal {
  int? pieces;
  String? weight;
  String? carat;
  String? totalAmount;

  SalesRecordDetailReportStoneTotal({
    this.pieces,
    this.weight,
    this.carat,
    this.totalAmount,
  });

  factory SalesRecordDetailReportStoneTotal.fromRawJson(String str) =>
      SalesRecordDetailReportStoneTotal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesRecordDetailReportStoneTotal.fromJson(
          Map<String, dynamic> json) =>
      SalesRecordDetailReportStoneTotal(
        pieces: json["pieces"],
        weight: json["weight"],
        carat: json["carat"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "pieces": pieces,
        "weight": weight,
        "carat": carat,
        "total_amount": totalAmount,
      };
}

class SalesRecordDetailReportTotal {
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? weightDifference;
  String? advance;
  String? receivedAmount;
  String? paymentMethodCash;
  String? paymentMethodCard;
  String? paymentMethodNeftRtgs;
  String? paymentMethodUpiImps;
  String? paymentMethodCheque;
  String? paymentMethodCreditNote;
  String? stoneWeightCarat;
  String? stoneAmount;
  String? oldGoldNettWeight;
  String? oldGoldGrossWeight;
  String? oldGoldAmount;
  String? benefitDiscount;

  SalesRecordDetailReportTotal({
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.weightDifference,
    this.advance,
    this.receivedAmount,
    this.paymentMethodCash,
    this.paymentMethodCard,
    this.paymentMethodNeftRtgs,
    this.paymentMethodUpiImps,
    this.paymentMethodCheque,
    this.paymentMethodCreditNote,
    this.stoneWeightCarat,
    this.stoneAmount,
    this.oldGoldNettWeight,
    this.oldGoldGrossWeight,
    this.oldGoldAmount,
    this.benefitDiscount,
  });

  factory SalesRecordDetailReportTotal.fromRawJson(String str) =>
      SalesRecordDetailReportTotal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesRecordDetailReportTotal.fromJson(Map<String, dynamic> json) =>
      SalesRecordDetailReportTotal(
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        weightDifference: json["weight_difference"],
        advance: json["advance"],
        receivedAmount: json["received_amount"],
        paymentMethodCash: json["payment_method_cash"],
        paymentMethodCard: json["payment_method_card"],
        paymentMethodNeftRtgs: json["payment_method_neft_rtgs"],
        paymentMethodUpiImps: json["payment_method_upi_imps"],
        paymentMethodCheque: json["payment_method_cheque"],
        paymentMethodCreditNote: json["payment_method_credit_note"],
        stoneWeightCarat: json["stone_weight_carat"],
        stoneAmount: json["stone_amount"],
        oldGoldNettWeight: json["old_gold_nett_weight"],
        oldGoldGrossWeight: json["old_gold_gross_weight"],
        oldGoldAmount: json["old_gold_amount"],
        benefitDiscount: json["benefit_discount"],
      );

  Map<String, dynamic> toJson() => {
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "weight_difference": weightDifference,
        "advance": advance,
        "received_amount": receivedAmount,
        "payment_method_cash": paymentMethodCash,
        "payment_method_card": paymentMethodCard,
        "payment_method_neft_rtgs": paymentMethodNeftRtgs,
        "payment_method_upi_imps": paymentMethodUpiImps,
        "payment_method_cheque": paymentMethodCheque,
        "payment_method_credit_note": paymentMethodCreditNote,
        "stone_weight_carat": stoneWeightCarat,
        "stone_amount": stoneAmount,
        "old_gold_nett_weight": oldGoldNettWeight,
        "old_gold_gross_weight": oldGoldGrossWeight,
        "old_gold_amount": oldGoldAmount,
        "benefit_discount": benefitDiscount,
      };
}

class SalesRecordDetailReportValue {
  DateTime? invoiceDate;
  String? invoiceNumber;
  String? tagNumber;
  String? itemDescription;
  String? code;
  int? pieces;
  String? grossWeight;
  String? netWeight;
  String? weightDifference;
  String? receivedAmount;
  String? paymentMethodCash;
  String? paymentMethodCard;
  String? paymentMethodNeftRtgs;
  String? paymentMethodUpiImps;
  String? paymentMethodCheque;
  String? stoneWeightCarat;
  String? stoneAmount;
  String? oldGoldNettWeight;
  String? oldGoldGrossWeight;
  String? oldGoldAmount;

  SalesRecordDetailReportValue({
    this.invoiceDate,
    this.invoiceNumber,
    this.tagNumber,
    this.itemDescription,
    this.code,
    this.pieces,
    this.grossWeight,
    this.netWeight,
    this.weightDifference,
    this.receivedAmount,
    this.paymentMethodCash,
    this.paymentMethodCard,
    this.paymentMethodNeftRtgs,
    this.paymentMethodUpiImps,
    this.paymentMethodCheque,
    this.stoneWeightCarat,
    this.stoneAmount,
    this.oldGoldNettWeight,
    this.oldGoldGrossWeight,
    this.oldGoldAmount,
  });

  factory SalesRecordDetailReportValue.fromRawJson(String str) =>
      SalesRecordDetailReportValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalesRecordDetailReportValue.fromJson(Map<String, dynamic> json) =>
      SalesRecordDetailReportValue(
        invoiceDate: json["invoice_date"] == null
            ? null
            : DateTime.parse(json["invoice_date"]),
        invoiceNumber: json["invoice_number"],
        tagNumber: json["tag_number"],
        itemDescription: json["item_description"],
        code: json["code"],
        pieces: json["pieces"],
        grossWeight: json["gross_weight"],
        netWeight: json["net_weight"],
        weightDifference: json["weight_difference"],
        receivedAmount: json["received_amount"],
        paymentMethodCash: json["payment_method_cash"],
        paymentMethodCard: json["payment_method_card"],
        paymentMethodNeftRtgs: json["payment_method_neft_rtgs"],
        paymentMethodUpiImps: json["payment_method_upi_imps"],
        paymentMethodCheque: json["payment_method_cheque"],
        stoneWeightCarat: json["stone_weight_carat"],
        stoneAmount: json["stone_amount"],
        oldGoldNettWeight: json["old_gold_nett_weight"],
        oldGoldGrossWeight: json["old_gold_gross_weight"],
        oldGoldAmount: json["old_gold_amount"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_date":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "invoice_number": invoiceNumber,
        "tag_number": tagNumber,
        "item_description": itemDescription,
        "code": code,
        "pieces": pieces,
        "gross_weight": grossWeight,
        "net_weight": netWeight,
        "weight_difference": weightDifference,
        "received_amount": receivedAmount,
        "payment_method_cash": paymentMethodCash,
        "payment_method_card": paymentMethodCard,
        "payment_method_neft_rtgs": paymentMethodNeftRtgs,
        "payment_method_upi_imps": paymentMethodUpiImps,
        "payment_method_cheque": paymentMethodCheque,
        "stone_weight_carat": stoneWeightCarat,
        "stone_amount": stoneAmount,
        "old_gold_nett_weight": oldGoldNettWeight,
        "old_gold_gross_weight": oldGoldGrossWeight,
        "old_gold_amount": oldGoldAmount,
      };
}
