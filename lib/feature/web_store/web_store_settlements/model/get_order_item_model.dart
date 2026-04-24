// // To parse this JSON data, do
// //
// //     final settlementItem = settlementItemFromMap(jsonString);

// import 'dart:convert';

// SettlementItem settlementItemFromMap(String str) =>
//     SettlementItem.fromMap(json.decode(str));

// String settlementItemToMap(SettlementItem data) => json.encode(data.toMap());

// class SettlementItem {
//   final String? id;
//   final String? entity;
//   final int? amount;
//   final String? status;
//   final int? fees;
//   final int? tax;
//   final String? utr;
//   final int? createdAt;

//   SettlementItem({
//     this.id,
//     this.entity,
//     this.amount,
//     this.status,
//     this.fees,
//     this.tax,
//     this.utr,
//     this.createdAt,
//   });

//   factory SettlementItem.fromMap(Map<String, dynamic> json) => SettlementItem(
//         id: json["id"],
//         entity: json["entity"],
//         amount: json["amount"],
//         status: json["status"],
//         fees: json["fees"],
//         tax: json["tax"],
//         utr: json["utr"],
//         createdAt: json["created_at"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "entity": entity,
//         "amount": amount,
//         "status": status,
//         "fees": fees,
//         "tax": tax,
//         "utr": utr,
//         "created_at": createdAt,
//       };
// }
