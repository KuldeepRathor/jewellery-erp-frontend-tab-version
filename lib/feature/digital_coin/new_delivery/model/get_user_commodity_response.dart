import 'dart:convert';

class GetUserCommodityResponse {
  List<GetUserCommodityResponseDatum>? data;
  User? user;

  GetUserCommodityResponse({
    this.data,
    this.user,
  });

  factory GetUserCommodityResponse.fromRawJson(String str) =>
      GetUserCommodityResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserCommodityResponse.fromJson(Map<String, dynamic> json) =>
      GetUserCommodityResponse(
        data: json["data"] == null
            ? []
            : List<GetUserCommodityResponseDatum>.from(json["data"]!
                .map((x) => GetUserCommodityResponseDatum.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "user": user?.toJson(),
      };
}

class GetUserCommodityResponseDatum {
  String? commodity;
  List<DatumDatum>? data;
  double? weight;

  GetUserCommodityResponseDatum({
    this.commodity,
    this.data,
    this.weight,
  });

  factory GetUserCommodityResponseDatum.fromRawJson(String str) =>
      GetUserCommodityResponseDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserCommodityResponseDatum.fromJson(Map<String, dynamic> json) =>
      GetUserCommodityResponseDatum(
        commodity: json["commodity"],
        data: json["data"] == null
            ? []
            : List<DatumDatum>.from(
                json["data"]!.map((x) => DatumDatum.fromJson(x))),
        weight: json["weight"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "commodity": commodity,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "weight": weight,
      };
}

class DatumDatum {
  int? shopId;
  int? userId;
  String? category;
  double? weight;
  int? orderCount;
  double? totalAmount; // Changed from int? to double?

  DatumDatum({
    this.shopId,
    this.userId,
    this.category,
    this.weight,
    this.orderCount,
    this.totalAmount,
  });

  factory DatumDatum.fromRawJson(String str) =>
      DatumDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumDatum.fromJson(Map<String, dynamic> json) => DatumDatum(
        shopId: json["shop_id"],
        userId: json["user_id"],
        category: json["category"],
        weight: json["weight"]?.toDouble(),
        orderCount: json["order_count"],
        totalAmount: json["total_amount"]?.toDouble(), // Added toDouble()
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "user_id": userId,
        "category": category,
        "weight": weight,
        "order_count": orderCount,
        "total_amount": totalAmount,
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? gstin;
  String? pan;
  String? address;
  String? email;
  dynamic pincode;
  String? state;
  String? username;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.gstin,
    this.pan,
    this.address,
    this.email,
    this.pincode,
    this.state,
    this.username,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        gstin: json["gstin"],
        pan: json["pan"],
        address: json["address"],
        email: json["email"],
        pincode: json["pincode"],
        state: json["state"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "gstin": gstin,
        "pan": pan,
        "address": address,
        "email": email,
        "pincode": pincode,
        "state": state,
        "username": username,
      };
}
