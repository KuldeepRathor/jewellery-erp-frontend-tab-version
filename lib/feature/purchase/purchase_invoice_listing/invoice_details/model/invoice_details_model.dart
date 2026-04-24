// import 'dart:convert';

// class InvoiceDetailsRequestResponse {
//   List<InvoiceDetail> invoices;

//   InvoiceDetailsRequestResponse({
//     required this.invoices,
//   });

//   factory InvoiceDetailsRequestResponse.fromRawJson(String str) =>
//       InvoiceDetailsRequestResponse.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory InvoiceDetailsRequestResponse.fromJson(List<dynamic> json) =>
//       InvoiceDetailsRequestResponse(
//         invoices: List<InvoiceDetail>.from(
//             json.map((x) => InvoiceDetail.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
//       };
// }

// class InvoiceDetail {
//   String? id;
//   String? organizationId;
//   String? partyType;
//   String? partyId;
//   String? partyName;
//   String? partyCode;
//   String? partyAddress;
//   String? partyGst;
//   String? invoiceNumber;
//   String? partyInvoiceNumber;
//   String? invoiceCreateDate;
//   String? invoiceReceiveDate;
//   List<PaymentDetail>? paymentDetails;
//   List<LineItem>? lineItems;

//   InvoiceDetail({
//     this.id,
//     this.organizationId,
//     this.partyType,
//     this.partyId,
//     this.partyName,
//     this.partyCode,
//     this.partyAddress,
//     this.partyGst,
//     this.invoiceNumber,
//     this.partyInvoiceNumber,
//     this.invoiceCreateDate,
//     this.invoiceReceiveDate,
//     this.paymentDetails,
//     this.lineItems,
//   });

//   factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         partyType: json["party_type"],
//         partyId: json["party_id"],
//         partyName: json["party_name"],
//         partyCode: json["party_code"],
//         partyAddress: json["party_address"],
//         partyGst: json["party_gst"],
//         invoiceNumber: json["invoice_number"],
//         partyInvoiceNumber: json["party_invoice_number"],
//         invoiceCreateDate: json["invoice_create_date"],
//         invoiceReceiveDate: json["invoice_receive_date"],
//         paymentDetails: json["payment_details"] == null
//             ? []
//             : List<PaymentDetail>.from(
//                 json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
//         lineItems: json["line_items"] == null
//             ? []
//             : List<LineItem>.from(
//                 json["line_items"]!.map((x) => LineItem.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "organization_id": organizationId,
//         "party_type": partyType,
//         "party_id": partyId,
//         "party_name": partyName,
//         "party_code": partyCode,
//         "party_address": partyAddress,
//         "party_gst": partyGst,
//         "invoice_number": invoiceNumber,
//         "party_invoice_number": partyInvoiceNumber,
//         "invoice_create_date": invoiceCreateDate,
//         "invoice_receive_date": invoiceReceiveDate,
//         "payment_details": paymentDetails == null
//             ? []
//             : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
//         "line_items": lineItems == null
//             ? []
//             : List<dynamic>.from(lineItems!.map((x) => x.toJson())),
//       };
// }

// class LineItem {
//   String? id;
//   String? organizationId;
//   String? code;
//   String? itemDescription;
//   int? pieces;
//   String? grossWeight;
//   String? less;
//   String? netWeight;
//   String? va;
//   String? tch;
//   String? mc;
//   String? stone;
//   String? rate;
//   String? amount;
//   String? purchaseInvoiceId;
//   List<LineStone>? lineStones;

//   LineItem({
//     this.id,
//     this.organizationId,
//     this.code,
//     this.itemDescription,
//     this.pieces,
//     this.grossWeight,
//     this.less,
//     this.netWeight,
//     this.va,
//     this.tch,
//     this.mc,
//     this.stone,
//     this.rate,
//     this.amount,
//     this.purchaseInvoiceId,
//     this.lineStones,
//   });

//   factory LineItem.fromRawJson(String str) =>
//       LineItem.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         code: json["code"],
//         itemDescription: json["item_description"],
//         pieces: json["pieces"],
//         grossWeight: json["gross_weight"],
//         less: json["less"],
//         netWeight: json["net_weight"],
//         va: json["va"],
//         tch: json["tch"],
//         mc: json["mc"],
//         stone: json["stone"],
//         rate: json["rate"],
//         amount: json["amount"],
//         purchaseInvoiceId: json["purchase_invoice_id"],
//         lineStones: json["line_stones"] == null
//             ? []
//             : List<LineStone>.from(
//                 json["line_stones"]!.map((x) => LineStone.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "organization_id": organizationId,
//         "code": code,
//         "item_description": itemDescription,
//         "pieces": pieces,
//         "gross_weight": grossWeight,
//         "less": less,
//         "net_weight": netWeight,
//         "va": va,
//         "tch": tch,
//         "mc": mc,
//         "stone": stone,
//         "rate": rate,
//         "amount": amount,
//         "purchase_invoice_id": purchaseInvoiceId,
//         "line_stones": lineStones == null
//             ? []
//             : List<dynamic>.from(lineStones!.map((x) => x.toJson())),
//       };
// }

// class LineStone {
//   String? id;
//   String? organizationId;
//   String? name;
//   int? pieces;
//   String? carat;
//   String? weight;
//   String? rate;
//   String? total;
//   String? purchaseLineItemId;

//   LineStone({
//     this.id,
//     this.organizationId,
//     this.name,
//     this.pieces,
//     this.carat,
//     this.weight,
//     this.rate,
//     this.total,
//     this.purchaseLineItemId,
//   });

//   factory LineStone.fromRawJson(String str) =>
//       LineStone.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory LineStone.fromJson(Map<String, dynamic> json) => LineStone(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         name: json["name"],
//         pieces: json["pieces"],
//         carat: json["carat"],
//         weight: json["weight"],
//         rate: json["rate"],
//         total: json["total"],
//         purchaseLineItemId: json["purchase_line_item_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "organization_id": organizationId,
//         "name": name,
//         "pieces": pieces,
//         "carat": carat,
//         "weight": weight,
//         "rate": rate,
//         "total": total,
//         "purchase_line_item_id": purchaseLineItemId,
//       };
// }

// class PaymentDetail {
//   String? id;
//   String? organizationId;
//   String? purchaseInvoiceId;
//   String? subTotal;
//   String? nett;
//   String? cgst;
//   String? sgst;
//   String? igst;
//   String? roundOff;
//   String? total;
//   String? tcs;
//   String? tds;
//   String? paidAmount;
//   String? balanceAmount;
//   List<PaymentMethodDetail>? paymentMethodDetails;

//   PaymentDetail({
//     this.id,
//     this.organizationId,
//     this.purchaseInvoiceId,
//     this.subTotal,
//     this.nett,
//     this.cgst,
//     this.sgst,
//     this.igst,
//     this.roundOff,
//     this.total,
//     this.tcs,
//     this.tds,
//     this.paidAmount,
//     this.balanceAmount,
//     this.paymentMethodDetails,
//   });

//   factory PaymentDetail.fromRawJson(String str) =>
//       PaymentDetail.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         purchaseInvoiceId: json["purchase_invoice_id"],
//         subTotal: json["sub_total"],
//         nett: json["nett"],
//         cgst: json["cgst"],
//         sgst: json["sgst"],
//         igst: json["igst"],
//         roundOff: json["round_off"],
//         total: json["total"],
//         tcs: json["tcs"],
//         tds: json["tds"],
//         paidAmount: json["paid_amount"],
//         balanceAmount: json["balance_amount"],
//         paymentMethodDetails: json["payment_method_details"] == null
//             ? []
//             : List<PaymentMethodDetail>.from(json["payment_method_details"]!
//                 .map((x) => PaymentMethodDetail.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "organization_id": organizationId,
//         "purchase_invoice_id": purchaseInvoiceId,
//         "sub_total": subTotal,
//         "nett": nett,
//         "cgst": cgst,
//         "sgst": sgst,
//         "igst": igst,
//         "round_off": roundOff,
//         "total": total,
//         "tcs": tcs,
//         "tds": tds,
//         "paid_amount": paidAmount,
//         "balance_amount": balanceAmount,
//         "payment_method_details": paymentMethodDetails == null
//             ? []
//             : List<dynamic>.from(paymentMethodDetails!.map((x) => x.toJson())),
//       };
// }

// class PaymentMethodDetail {
//   String? id;
//   String? organizationId;
//   String? purchaseInvoicePaymentDetailsId;
//   String? amount;
//   String? method;
//   String? date;
//   String? pos;
//   String? paymentCode;

//   PaymentMethodDetail({
//     this.id,
//     this.organizationId,
//     this.purchaseInvoicePaymentDetailsId,
//     this.amount,
//     this.method,
//     this.date,
//     this.pos,
//     this.paymentCode,
//   });

//   factory PaymentMethodDetail.fromRawJson(String str) =>
//       PaymentMethodDetail.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaymentMethodDetail.fromJson(Map<String, dynamic> json) =>
//       PaymentMethodDetail(
//         id: json["id"],
//         organizationId: json["organization_id"],
//         purchaseInvoicePaymentDetailsId:
//             json["purchase_invoice_payment_details_id"],
//         amount: json["amount"],
//         method: json["method"],
//         date: json["date"],
//         pos: json["pos"],
//         paymentCode: json["payment_code"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "organization_id": organizationId,
//         "purchase_invoice_payment_details_id": purchaseInvoicePaymentDetailsId,
//         "amount": amount,
//         "method": method,
//         "date": date,
//         "pos": pos,
//         "payment_code": paymentCode,
//       };
// }
