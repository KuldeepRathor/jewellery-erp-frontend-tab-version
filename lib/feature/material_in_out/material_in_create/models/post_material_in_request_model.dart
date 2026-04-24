import 'dart:convert';

class MaterialInRequestModel {
  String? voucherType;
  String? voucherSeriesId;
  List<LineItem>? lineItems;
  String? partyAddress;
  String? partyCode;
  String? partyGst;
  String? partyId;
  String? partyInvoiceNumber;
  String? partyName;
  String? partyType;
  String? remark;
  DateTime? invoiceCreateDate;
  DateTime? invoiceReceiveDate;

  MaterialInRequestModel({
    this.voucherType,
    this.voucherSeriesId,
    this.lineItems,
    this.partyAddress,
    this.partyCode,
    this.partyGst,
    this.partyId,
    this.partyInvoiceNumber,
    this.partyName,
    this.partyType,
    this.remark,
    this.invoiceCreateDate,
    this.invoiceReceiveDate,
  });

  factory MaterialInRequestModel.fromRawJson(String str) =>
      MaterialInRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MaterialInRequestModel.fromJson(Map<String, dynamic> json) =>
      MaterialInRequestModel(
        voucherType: json["voucher_type"],
        voucherSeriesId: json["voucher_series_id"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        partyAddress: json["party_address"],
        partyCode: json["party_code"],
        partyGst: json["party_gst"],
        partyId: json["party_id"],
        partyInvoiceNumber: json["party_invoice_number"],
        partyName: json["party_name"],
        partyType: json["party_type"],
        remark: json["remark"],
        invoiceCreateDate: json["invoice_create_date"] == null
            ? null
            : DateTime.parse(json["invoice_create_date"]),
        invoiceReceiveDate: json["invoice_receive_date"] == null
            ? null
            : DateTime.parse(json["invoice_receive_date"]),
      );

  Map<String, dynamic> toJson() => {
        "voucher_type": voucherType,
        "voucher_series_id": voucherSeriesId,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "party_address": partyAddress,
        "party_code": partyCode,
        "party_gst": partyGst,
        "party_id": partyId,
        "party_invoice_number": partyInvoiceNumber,
        "party_name": partyName,
        "party_type": partyType,
        "remark": remark,
        "invoice_create_date":
            "${invoiceCreateDate!.year.toString().padLeft(4, '0')}-${invoiceCreateDate!.month.toString().padLeft(2, '0')}-${invoiceCreateDate!.day.toString().padLeft(2, '0')}",
        "invoice_receive_date":
            "${invoiceReceiveDate!.year.toString().padLeft(4, '0')}-${invoiceReceiveDate!.month.toString().padLeft(2, '0')}-${invoiceReceiveDate!.day.toString().padLeft(2, '0')}",
      };
}

class LineItem {
  String? amount;
  String? code;
  String? grossWeight;
  String? itemDescription;
  String? less;
  String? mc;
  String? netWeight;
  String? ornamentId;
  int? pieces;
  String? rate;
  String? stone;
  String? va;

  LineItem({
    this.amount,
    this.code,
    this.grossWeight,
    this.itemDescription,
    this.less,
    this.mc,
    this.netWeight,
    this.ornamentId,
    this.pieces,
    this.rate,
    this.stone,
    this.va,
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        amount: json["amount"],
        code: json["code"],
        grossWeight: json["gross_weight"],
        itemDescription: json["item_description"],
        less: json["less"],
        mc: json["mc"],
        netWeight: json["net_weight"],
        ornamentId: json["ornament_id"],
        pieces: json["pieces"],
        rate: json["rate"],
        stone: json["stone"],
        va: json["va"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "code": code,
        "gross_weight": grossWeight,
        "item_description": itemDescription,
        "less": less,
        "mc": mc,
        "net_weight": netWeight,
        "ornament_id": ornamentId,
        "pieces": pieces,
        "rate": rate,
        "stone": stone,
        "va": va,
      };
}
