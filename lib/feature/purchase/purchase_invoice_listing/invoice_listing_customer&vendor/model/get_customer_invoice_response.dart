// // class GetCustomerInvoiceResponse {
// //   List<CustomerInvoices>? customerInvoices;

// //   GetCustomerInvoiceResponse({this.customerInvoices});

// //   GetCustomerInvoiceResponse.fromJson(Map<String, dynamic> json) {
// //     if (json['customer_invoices'] != null) {
// //       customerInvoices = <CustomerInvoices>[];
// //       json['customer_invoices'].forEach((v) {
// //         customerInvoices!.add(CustomerInvoices.fromJson(v));
// //       });
// //     }
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (customerInvoices != null) {
// //       data['customer_invoices'] =
// //           customerInvoices!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }

// class CustomerInvoices {
//   String? id;
//   String? date;
//   int? invoiceNo;
//   String? customerName;
//   String? itemDescription;
//   String? mobileNo;
//   int? weight;
//   int? amount;
//   int? total;

//   CustomerInvoices(
//       {this.id,
//       this.date,
//       this.invoiceNo,
//       this.customerName,
//       this.itemDescription,
//       this.mobileNo,
//       this.weight,
//       this.amount,
//       this.total});

//   CustomerInvoices.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     invoiceNo = json['invoice_no'];
//     customerName = json['customer_name'];
//     itemDescription = json['item_description'];
//     mobileNo = json['mobile_no'];
//     weight = json['weight'];
//     amount = json['amount'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     data['invoice_no'] = invoiceNo;
//     data['customer_name'] = customerName;
//     data['item_description'] = itemDescription;
//     data['mobile_no'] = mobileNo;
//     data['weight'] = weight;
//     data['amount'] = amount;
//     data['total'] = total;
//     return data;
//   }
// }
