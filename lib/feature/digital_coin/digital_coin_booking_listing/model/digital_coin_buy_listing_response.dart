import 'dart:convert';

class DigitalCoinBuyListingResponse {
  int? page;
  int? limit;
  int? totalResults;
  List<Result>? results;

  DigitalCoinBuyListingResponse({
    this.page,
    this.limit,
    this.totalResults,
    this.results,
  });

  factory DigitalCoinBuyListingResponse.fromRawJson(String str) =>
      DigitalCoinBuyListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DigitalCoinBuyListingResponse.fromJson(Map<String, dynamic> json) =>
      DigitalCoinBuyListingResponse(
        page: json["page"],
        limit: json["limit"],
        totalResults: json["total_results"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total_results": totalResults,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  int? id;
  int? shopId;
  String? purchaseId;
  String? commodity;
  User? user;
  String? status;
  String? category;
  String? source;
  String? completedDate;
  dynamic cancelledDate;
  String? invoiceNo;
  double? igstAmount; // Changed from int? to double?
  double? cgstAmount; // Changed from int? to double?
  double? sgstAmount; // Changed from int? to double?
  double? vaAmount; // Changed from int? to double?
  double? subTotal; // Changed from int? to double?
  double? quantity;
  dynamic rateTimestamp;
  double? rate; // Changed from int? to double?
  double? amount; // Changed from int? to double?
  double? roundOff; // Changed from int? to double?
  dynamic invoiceUrl;
  String? deliveryUrl;

  Result({
    this.id,
    this.shopId,
    this.purchaseId,
    this.commodity,
    this.user,
    this.status,
    this.category,
    this.source,
    this.completedDate,
    this.cancelledDate,
    this.invoiceNo,
    this.igstAmount,
    this.cgstAmount,
    this.sgstAmount,
    this.vaAmount,
    this.subTotal,
    this.quantity,
    this.rateTimestamp,
    this.rate,
    this.amount,
    this.roundOff,
    this.invoiceUrl,
    this.deliveryUrl,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        shopId: json["shop_id"],
        purchaseId: json["purchase_id"],
        commodity: json["commodity"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        status: json["status"],
        category: json["category"],
        source: json["source"],
        completedDate: json["completed_date"],
        cancelledDate: json["cancelled_date"],
        invoiceNo: json["invoice_no"],
        igstAmount: (json["igst_amount"] as num?)
            ?.toDouble(), // Handle numeric conversion
        cgstAmount: (json["cgst_amount"] as num?)
            ?.toDouble(), // Handle numeric conversion
        sgstAmount: (json["sgst_amount"] as num?)
            ?.toDouble(), // Handle numeric conversion
        vaAmount: (json["va_amount"] as num?)
            ?.toDouble(), // Handle numeric conversion
        subTotal: (json["sub_total"] as num?)
            ?.toDouble(), // Handle numeric conversion
        quantity: json["quantity"]?.toDouble(),
        rateTimestamp: json["rate_timestamp"],
        rate: (json["rate"] as num?)?.toDouble(), // Handle numeric conversion
        amount:
            (json["amount"] as num?)?.toDouble(), // Handle numeric conversion
        roundOff: (json["round_off"] as num?)
            ?.toDouble(), // Handle numeric conversion
        invoiceUrl: json["invoice_url"],
        deliveryUrl: json["delivery_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "purchase_id": purchaseId,
        "commodity": commodity,
        "user": user?.toJson(),
        "status": status,
        "category": category,
        "source": source,
        "completed_date": completedDate,
        "cancelled_date": cancelledDate,
        "invoice_no": invoiceNo,
        "igst_amount": igstAmount,
        "cgst_amount": cgstAmount,
        "sgst_amount": sgstAmount,
        "va_amount": vaAmount,
        "sub_total": subTotal,
        "quantity": quantity,
        "rate_timestamp": rateTimestamp,
        "rate": rate,
        "amount": amount,
        "round_off": roundOff,
        "invoice_url": invoiceUrl,
        "delivery_url": deliveryUrl,
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
  String? pincode;
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
