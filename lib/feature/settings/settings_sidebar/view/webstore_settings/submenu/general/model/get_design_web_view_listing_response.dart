import 'dart:convert';

class GetDesignWebViewListingResponse {
  List<GetDesignWebViewValue>? values;

  GetDesignWebViewListingResponse({
    this.values,
  });

  factory GetDesignWebViewListingResponse.fromRawJson(String str) =>
      GetDesignWebViewListingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignWebViewListingResponse.fromJson(Map<String, dynamic> json) =>
      GetDesignWebViewListingResponse(
        values: json["values"] == null
            ? []
            : List<GetDesignWebViewValue>.from(
                json["values"]!.map((x) => GetDesignWebViewValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetDesignWebViewValue {
  String? id;
  String? name;
  String? code;
  bool? isWebstore;

  GetDesignWebViewValue({
    this.id,
    this.name,
    this.code,
    this.isWebstore,
  });

  factory GetDesignWebViewValue.fromRawJson(String str) =>
      GetDesignWebViewValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignWebViewValue.fromJson(Map<String, dynamic> json) =>
      GetDesignWebViewValue(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        isWebstore: json["is_webstore"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "is_webstore": isWebstore,
      };
}
