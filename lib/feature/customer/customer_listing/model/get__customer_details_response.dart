// import 'dart:convert';

// class GetCustomerListingDetailsResponse {
//   int? sr;
//   String? customerId;
//   String? name;
//   String? mobile;
//   String? area;
//   bool? kycStatus;
//   List<String>? tags;
//   String? id;

//   GetCustomerListingDetailsResponse({
//     this.sr,
//     this.customerId,
//     this.name,
//     this.mobile,
//     this.area,
//     this.kycStatus,
//     this.tags,
//     this.id,
//   });

//   factory GetCustomerListingDetailsResponse.fromRawJson(String str) =>
//       GetCustomerListingDetailsResponse.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory GetCustomerListingDetailsResponse.fromJson(
//           Map<String, dynamic> json) =>
//       GetCustomerListingDetailsResponse(
//         sr: json["sr"],
//         customerId: json["customer_id"],
//         name: json["name"],
//         mobile: json["mobile"],
//         area: json["area"],
//         kycStatus: json["kyc_status"],
//         tags: json["tags"] == null
//             ? []
//             : List<String>.from(json["tags"]!.map((x) => x)),
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "sr": sr,
//         "customer_id": customerId,
//         "name": name,
//         "mobile": mobile,
//         "area": area,
//         "kyc_status": kycStatus,
//         "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
//         "id": id,
//       };
// }
