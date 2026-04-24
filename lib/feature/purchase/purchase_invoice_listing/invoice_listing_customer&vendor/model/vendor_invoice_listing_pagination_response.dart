// import 'dart:convert';

// import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/model/get_vendor_invoice_response.dart';

// class VendorInvoiceListingPaginationResponse {
//   int? first;
//   int? prev;
//   int? next;
//   int? last;
//   int? pages;
//   int? items;
//   List<VendorInvoices>? data;

//   VendorInvoiceListingPaginationResponse({
//     this.first,
//     this.prev,
//     this.next,
//     this.last,
//     this.pages,
//     this.items,
//     this.data,
//   });

//   factory VendorInvoiceListingPaginationResponse.fromRawJson(String str) =>
//       VendorInvoiceListingPaginationResponse.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory VendorInvoiceListingPaginationResponse.fromJson(
//           Map<String, dynamic> json) =>
//       VendorInvoiceListingPaginationResponse(
//         first: json["first"],
//         prev: json["prev"],
//         next: json["next"],
//         last: json["last"],
//         pages: json["pages"],
//         items: json["items"],
//         data: json["data"] == null
//             ? []
//             : List<VendorInvoices>.from(
//                 json["data"]!.map((x) => VendorInvoices.fromJson(x))),
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
