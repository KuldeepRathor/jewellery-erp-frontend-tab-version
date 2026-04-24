// class VendorInvoices {
//   String? id;
//   String? date;
//   int? invoiceNo;
//   String? vendorName;
//   String? itemDescription;
//   int? weight;
//   int? amount;
//   int? cGST;
//   int? sGST;
//   int? iGST;
//   int? tDS;
//   int? tCS;
//   int? total;

//   VendorInvoices(
//       {this.id,
//       this.date,
//       this.invoiceNo,
//       this.vendorName,
//       this.itemDescription,
//       this.weight,
//       this.amount,
//       this.cGST,
//       this.sGST,
//       this.iGST,
//       this.tDS,
//       this.tCS,
//       this.total});

//   VendorInvoices.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     invoiceNo = json['invoice_no'];
//     vendorName = json['vendor_name'];
//     itemDescription = json['item_description'];
//     weight = json['weight'];
//     amount = json['amount'];
//     cGST = json['CGST'];
//     sGST = json['SGST'];
//     iGST = json['IGST'];
//     tDS = json['TDS'];
//     tCS = json['TCS'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     data['invoice_no'] = invoiceNo;
//     data['vendor_name'] = vendorName;
//     data['item_description'] = itemDescription;
//     data['weight'] = weight;
//     data['amount'] = amount;
//     data['CGST'] = cGST;
//     data['SGST'] = sGST;
//     data['IGST'] = iGST;
//     data['TDS'] = tDS;
//     data['TCS'] = tCS;
//     data['total'] = total;
//     return data;
//   }
// }
