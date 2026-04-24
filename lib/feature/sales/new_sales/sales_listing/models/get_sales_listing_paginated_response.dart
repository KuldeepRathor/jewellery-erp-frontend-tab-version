import 'dart:convert';

class GetSalesPaginatedResponse {
  List<GetSalesPaginatedResponseValue>? values;
  Pagination? pagination;

  GetSalesPaginatedResponse({
    this.values,
    this.pagination,
  });

  factory GetSalesPaginatedResponse.fromRawJson(String str) =>
      GetSalesPaginatedResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      GetSalesPaginatedResponse(
        values: json["values"] == null
            ? []
            : List<GetSalesPaginatedResponseValue>.from(json["values"]!
                .map((x) => GetSalesPaginatedResponseValue.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  String? next;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.next,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "next": next,
      };
}

class GetSalesPaginatedResponseValue {
  String? id;
  List<PurchaseInvoice>? purchaseInvoices;
  String? salesNumber;
  bool? itemHandover;
  String? paymentStatus;
  String? name;
  String? phoneNumber;
  String? partyType;
  int? pieces;
  String? oldGoldAmount;
  String? oldGoldNetWeight;
  String? oldGoldGrossWeight;
  String? netWeight;
  String? grossWeight;
  String? invoiceAmount;
  String? finalInvoiceAmount;
  DateTime? createdAt;

  GetSalesPaginatedResponseValue({
    this.id,
    this.purchaseInvoices,
    this.salesNumber,
    this.itemHandover,
    this.paymentStatus,
    this.name,
    this.phoneNumber,
    this.partyType,
    this.pieces,
    this.netWeight,
    this.grossWeight,
    this.oldGoldAmount,
    this.oldGoldNetWeight,
    this.oldGoldGrossWeight,
    this.invoiceAmount,
    this.finalInvoiceAmount,
    this.createdAt,
  });

  factory GetSalesPaginatedResponseValue.fromRawJson(String str) =>
      GetSalesPaginatedResponseValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSalesPaginatedResponseValue.fromJson(Map<String, dynamic> json) =>
      GetSalesPaginatedResponseValue(
        id: json["id"],
        purchaseInvoices: json["purchase_invoices"] == null
            ? []
            : List<PurchaseInvoice>.from(json["purchase_invoices"]!
                .map((x) => PurchaseInvoice.fromJson(x))),
        salesNumber: json["sales_number"],
        itemHandover: json["item_handover"],
        paymentStatus: json["payment_status"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        partyType: json["party_type"],
        pieces: json["pieces"],
        netWeight: json["net_weight"],
        grossWeight: json["gross_weight"],
        oldGoldAmount: json["old_gold_amount"],
        oldGoldNetWeight: json["old_gold_net_weight"],
        oldGoldGrossWeight: json["old_gold_gross_weight"],
        invoiceAmount: json["invoice_amount"],
        finalInvoiceAmount: json["final_invoice_amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purchase_invoices": purchaseInvoices == null
            ? []
            : List<dynamic>.from(purchaseInvoices!.map((x) => x.toJson())),
        "sales_number": salesNumber,
        "item_handover": itemHandover,
        "payment_status": paymentStatus,
        "name": name,
        "phone_number": phoneNumber,
        "party_type": partyType,
        "pieces": pieces,
        "net_weight": netWeight,
        "gross_weight": grossWeight,
        "old_gold_amount": oldGoldAmount,
        "old_gold_net_weight": oldGoldNetWeight,
        "old_gold_gross_weight": oldGoldGrossWeight,
        "invoice_amount": invoiceAmount,
        "final_invoice_amount": finalInvoiceAmount,
        "created_at": createdAt?.toIso8601String(),
      };
}

class PurchaseInvoice {
  String? id;
  String? organizationId;
  String? shopId;
  bool? isService;
  String? partyType;
  String? partyId;
  String? partyName;
  String? partyCode;
  String? partyAddress;
  String? partyGst;
  String? invoiceNumber;
  String? partyInvoiceNumber;
  DateTime? invoiceCreateDate;
  DateTime? invoiceReceiveDate;
  dynamic remark;
  List<PaymentDetail>? paymentDetails;
  List<dynamic>? purchaseAttachments;
  List<LineItem>? lineItems;
  dynamic cancelledAt;
  bool? isCancelled;
  String? status;

  PurchaseInvoice({
    this.id,
    this.organizationId,
    this.shopId,
    this.isService,
    this.partyType,
    this.partyId,
    this.partyName,
    this.partyCode,
    this.partyAddress,
    this.partyGst,
    this.invoiceNumber,
    this.partyInvoiceNumber,
    this.invoiceCreateDate,
    this.invoiceReceiveDate,
    this.remark,
    this.paymentDetails,
    this.purchaseAttachments,
    this.lineItems,
    this.cancelledAt,
    this.isCancelled,
    this.status,
  });

  factory PurchaseInvoice.fromRawJson(String str) =>
      PurchaseInvoice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) =>
      PurchaseInvoice(
        id: json["id"],
        organizationId: json["organization_id"],
        shopId: json["shop_id"],
        isService: json["is_service"],
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
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
        purchaseAttachments: json["purchase_attachments"] == null
            ? []
            : List<dynamic>.from(json["purchase_attachments"]!.map((x) => x)),
        lineItems: json["line_items"] == null
            ? []
            : List<LineItem>.from(
                json["line_items"]!.map((x) => LineItem.fromJson(x))),
        cancelledAt: json["cancelled_at"],
        isCancelled: json["is_cancelled"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "shop_id": shopId,
        "is_service": isService,
        "party_type": partyType,
        "party_id": partyId,
        "party_name": partyName,
        "party_code": partyCode,
        "party_address": partyAddress,
        "party_gst": partyGst,
        "invoice_number": invoiceNumber,
        "party_invoice_number": partyInvoiceNumber,
        "invoice_create_date": invoiceCreateDate?.toIso8601String(),
        "invoice_receive_date": invoiceReceiveDate?.toIso8601String(),
        "remark": remark,
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "purchase_attachments": purchaseAttachments == null
            ? []
            : List<dynamic>.from(purchaseAttachments!.map((x) => x)),
        "line_items": lineItems == null
            ? []
            : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
        "cancelled_at": cancelledAt,
        "is_cancelled": isCancelled,
        "status": status,
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
  String? purchaseInvoiceId;
  String? ornamentMetalType;
  String? hsnSac;
  dynamic hsnSacType;
  List<dynamic>? lineStones;

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
    this.purchaseInvoiceId,
    this.ornamentMetalType,
    this.hsnSac,
    this.hsnSacType,
    this.lineStones,
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
        purchaseInvoiceId: json["purchase_invoice_id"],
        ornamentMetalType: json["ornament_metal_type"],
        hsnSac: json["hsn_sac"],
        hsnSacType: json["hsn_sac_type"],
        lineStones: json["line_stones"] == null
            ? []
            : List<dynamic>.from(json["line_stones"]!.map((x) => x)),
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
        "purchase_invoice_id": purchaseInvoiceId,
        "ornament_metal_type": ornamentMetalType,
        "hsn_sac": hsnSac,
        "hsn_sac_type": hsnSacType,
        "line_stones": lineStones == null
            ? []
            : List<dynamic>.from(lineStones!.map((x) => x)),
      };
}

class PaymentDetail {
  String? id;
  String? organizationId;
  String? purchaseInvoiceId;
  String? subTotal;
  String? nett;
  dynamic cgst;
  dynamic sgst;
  dynamic igst;
  String? roundOff;
  String? total;
  dynamic tcs;
  String? tds;
  String? paidAmount;
  String? balanceAmount;
  dynamic hallmark;
  List<dynamic>? paymentMethodDetails;

  PaymentDetail({
    this.id,
    this.organizationId,
    this.purchaseInvoiceId,
    this.subTotal,
    this.nett,
    this.cgst,
    this.sgst,
    this.igst,
    this.roundOff,
    this.total,
    this.tcs,
    this.tds,
    this.paidAmount,
    this.balanceAmount,
    this.hallmark,
    this.paymentMethodDetails,
  });

  factory PaymentDetail.fromRawJson(String str) =>
      PaymentDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json["id"],
        organizationId: json["organization_id"],
        purchaseInvoiceId: json["purchase_invoice_id"],
        subTotal: json["sub_total"],
        nett: json["nett"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        roundOff: json["round_off"],
        total: json["total"],
        tcs: json["tcs"],
        tds: json["tds"],
        paidAmount: json["paid_amount"],
        balanceAmount: json["balance_amount"],
        hallmark: json["hallmark"],
        paymentMethodDetails: json["payment_method_details"] == null
            ? []
            : List<dynamic>.from(json["payment_method_details"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization_id": organizationId,
        "purchase_invoice_id": purchaseInvoiceId,
        "sub_total": subTotal,
        "nett": nett,
        "cgst": cgst,
        "sgst": sgst,
        "igst": igst,
        "round_off": roundOff,
        "total": total,
        "tcs": tcs,
        "tds": tds,
        "paid_amount": paidAmount,
        "balance_amount": balanceAmount,
        "hallmark": hallmark,
        "payment_method_details": paymentMethodDetails == null
            ? []
            : List<dynamic>.from(paymentMethodDetails!.map((x) => x)),
      };
}
