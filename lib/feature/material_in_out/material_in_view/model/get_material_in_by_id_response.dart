import 'dart:convert';

class GetMaterialInByIdResponse {
  String? id;
  String? organizationId;
  String? shopId;
  String? partyType;
  String? partyId;
  String? partyName;
  String? partyCode;
  String? partyAddress;
  String? partyGst;
  String? invoiceNumber;
  String? partyInvoiceNumber;
  String? remark;

  DateTime? invoiceCreateDate;
  DateTime? invoiceReceiveDate;
  List<LineItem>? lineItems;

  GetMaterialInByIdResponse({
    this.id,
    this.organizationId,
    this.shopId,
    this.partyType,
    this.partyId,
    this.partyName,
    this.partyCode,
    this.partyAddress,
    this.partyGst,
    this.invoiceNumber,
    this.partyInvoiceNumber,
    this.remark,
    this.invoiceCreateDate,
    this.invoiceReceiveDate,
    this.lineItems,
  });

  factory GetMaterialInByIdResponse.fromRawJson(String str) =>
      GetMaterialInByIdResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetMaterialInByIdResponse.fromJson(Map<String, dynamic> json) =>
      GetMaterialInByIdResponse(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        partyType: json["party_type"],
        partyId: json["party_id"],
        partyName: json["party_name"],
        partyCode: json["party_code"],
        partyAddress: json["party_address"],
        partyGst: json["party_gst"],
        invoiceNumber: json["invoice_number"],
        partyInvoiceNumber: json["party_invoice_number"],
        invoiceCreateDate: json["invoice_create_date"] == null
            ? null
            : DateTime.parse(json["invoice_create_date"]),
        invoiceReceiveDate: json["invoice_receive_date"] == null
            ? null
            : DateTime.parse(json["invoice_receive_date"]),
        remark: json["remark"],
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
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
        "invoice_number": invoiceNumber,
        "party_invoice_number": partyInvoiceNumber,
        "invoice_create_date":
            "${invoiceCreateDate!.year.toString().padLeft(4, '0')}-${invoiceCreateDate!.month.toString().padLeft(2, '0')}-${invoiceCreateDate!.day.toString().padLeft(2, '0')}",
        "invoice_receive_date":
            "${invoiceReceiveDate!.year.toString().padLeft(4, '0')}-${invoiceReceiveDate!.month.toString().padLeft(2, '0')}-${invoiceReceiveDate!.day.toString().padLeft(2, '0')}",
        "remark": remark,
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
      };
}

class LineItem {
  String? id;
  String? organizationId;
  String? shopId;
  String? ornamentId;
  String? code;
  String? itemDescription;
  int? pieces;
  String? grossWeight;
  String? less;
  String? netWeight;
  String? va;
  dynamic tch;
  String? mc;
  String? stone;
  String? rate;
  String? amount;

  LineItem({
    this.id,
    this.organizationId,
    this.shopId,
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
  });

  factory LineItem.fromRawJson(String str) =>
      LineItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
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
      };
}
