// import 'dart:convert';

// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/get_customer_invoice_response.dart';

// class CustomerInvoiceListingPaginationResponse {
//   int? first;
//   int? prev;
//   int? next;
//   int? last;
//   int? pages;
//   int? items;
//   List<CustomerInvoices>? data;

//   CustomerInvoiceListingPaginationResponse({
//     this.first,
//     this.prev,
//     this.next,
//     this.last,
//     this.pages,
//     this.items,
//     this.data,
//   });

//   factory CustomerInvoiceListingPaginationResponse.fromRawJson(String str) =>
//       CustomerInvoiceListingPaginationResponse.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory CustomerInvoiceListingPaginationResponse.fromJson(
//           Map<String, dynamic> json) =>
//       CustomerInvoiceListingPaginationResponse(
//         first: json["first"],
//         prev: json["prev"],
//         next: json["next"],
//         last: json["last"],
//         pages: json["pages"],
//         items: json["items"],
//         data: json["data"] == null
//             ? []
//             : List<CustomerInvoices>.from(
//                 json["data"]!.map((x) => CustomerInvoices.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "first": first,
//         "prev": prev,
//         "next": next,
//         "last": last,
//         "pages": pages,
//         "items": items,
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
