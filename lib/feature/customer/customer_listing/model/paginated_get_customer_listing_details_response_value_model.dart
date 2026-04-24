// import 'dart:convert';

// import '../../../vendor/add_vendor/model/get_address_model.dart';

// class PaginatedGetCustomerListingDetailsResponseValue {
//   String? id;
//   dynamic externalId;
//   String? readableId;
//   String? phoneNumber;
//   String? name;
//   DateTime? dateOfBirth;
//   String? panNumber;
//   String? gstNumber;
//   String? organizationId;
//   dynamic addressUuid;
//   String? gender;
//   List<dynamic>? nominees;
//   List<Address>? address;

//   PaginatedGetCustomerListingDetailsResponseValue({
//     this.id,
//     this.externalId,
//     this.readableId,
//     this.phoneNumber,
//     this.name,
//     this.dateOfBirth,
//     this.panNumber,
//     this.gstNumber,
//     this.organizationId,
//     this.addressUuid,
//     this.gender,
//     this.nominees,
//     this.address,
//   });

//   factory PaginatedGetCustomerListingDetailsResponseValue.fromRawJson(
//           String str) =>
//       PaginatedGetCustomerListingDetailsResponseValue.fromJson(
//           json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaginatedGetCustomerListingDetailsResponseValue.fromJson(
//           Map<String, dynamic> json) =>
//       PaginatedGetCustomerListingDetailsResponseValue(
//         id: json["id"],
//         externalId: json["external_id"],
//         readableId: json["readable_id"],
//         phoneNumber: json["phone_number"],
//         name: json["name"],
//         dateOfBirth: json["date_of_birth"] == null
//             ? null
//             : DateTime.parse(json["date_of_birth"]),
//         panNumber: json["pan_number"],
//         gstNumber: json["gst_number"],
//         organizationId: json["organization_id"],
//         addressUuid: json["address_uuid"],
//         gender: json["gender"],
//         nominees: json["nominees"] == null
//             ? []
//             : List<dynamic>.from(json["nominees"]!.map((x) => x)),
//         address: json["address"] == null
//             ? []
//             : List<Address>.from(
//                 json["address"]!.map((x) => Address.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "external_id": externalId,
//         "readable_id": readableId,
//         "phone_number": phoneNumber,
//         "name": name,
//         "date_of_birth":
//             "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
//         "pan_number": panNumber,
//         "gst_number": gstNumber,
//         "organization_id": organizationId,
//         "address_uuid": addressUuid,
//         "gender": gender,
//         "nominees":
//             nominees == null ? [] : List<dynamic>.from(nominees!.map((x) => x)),
//         "address": address == null
//             ? []
//             : List<dynamic>.from(address!.map((x) => x.toJson())),
//       };
// }

// // class Address {
// //   String? id;
// //   String? organizationId;
// //   String? type;
// //   dynamic gstNumber;
// //   dynamic phoneNumber;
// //   String? phoneCountryCode;
// //   dynamic firstName;
// //   dynamic lastName;
// //   dynamic country;
// //   String? state;
// //   String? city;
// //   String? pincode;
// //   String? addressLine1;
// //   String? addressLine2;
// //   String? linkedEntityType;
// //   String? linkedEntityId;
// //   dynamic nickname;
// //   dynamic longitude;
// //   dynamic latitude;

// //   Address({
// //     this.id,
// //     this.organizationId,
// //     this.type,
// //     this.gstNumber,
// //     this.phoneNumber,
// //     this.phoneCountryCode,
// //     this.firstName,
// //     this.lastName,
// //     this.country,
// //     this.state,
// //     this.city,
// //     this.pincode,
// //     this.addressLine1,
// //     this.addressLine2,
// //     this.linkedEntityType,
// //     this.linkedEntityId,
// //     this.nickname,
// //     this.longitude,
// //     this.latitude,
// //   });

// //   factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

// //   String toRawJson() => json.encode(toJson());

// //   factory Address.fromJson(Map<String, dynamic> json) => Address(
// //         id: json["id"],
// //         organizationId: json["organization_id"],
// //         type: json["type"],
// //         gstNumber: json["gst_number"],
// //         phoneNumber: json["phone_number"],
// //         phoneCountryCode: json["phone_country_code"],
// //         firstName: json["first_name"],
// //         lastName: json["last_name"],
// //         country: json["country"],
// //         state: json["state"],
// //         city: json["city"],
// //         pincode: json["pincode"],
// //         addressLine1: json["address_line1"],
// //         addressLine2: json["address_line2"],
// //         linkedEntityType: json["linked_entity_type"],
// //         linkedEntityId: json["linked_entity_id"],
// //         nickname: json["nickname"],
// //         longitude: json["longitude"],
// //         latitude: json["latitude"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "organization_id": organizationId,
// //         "type": type,
// //         "gst_number": gstNumber,
// //         "phone_number": phoneNumber,
// //         "phone_country_code": phoneCountryCode,
// //         "first_name": firstName,
// //         "last_name": lastName,
// //         "country": country,
// //         "state": state,
// //         "city": city,
// //         "pincode": pincode,
// //         "address_line1": addressLine1,
// //         "address_line2": addressLine2,
// //         "linked_entity_type": linkedEntityType,
// //         "linked_entity_id": linkedEntityId,
// //         "nickname": nickname,
// //         "longitude": longitude,
// //         "latitude": latitude,
// //       };
// // }
