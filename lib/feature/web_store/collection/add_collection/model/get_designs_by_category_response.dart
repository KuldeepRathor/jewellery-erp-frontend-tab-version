import 'dart:convert';

class GetDesignByCategoryResponse {
  List<GetDesignByCategoryValue>? values;

  GetDesignByCategoryResponse({
    this.values,
  });

  factory GetDesignByCategoryResponse.fromRawJson(String str) =>
      GetDesignByCategoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignByCategoryResponse.fromJson(Map<String, dynamic> json) =>
      GetDesignByCategoryResponse(
        values: json["values"] == null
            ? []
            : List<GetDesignByCategoryValue>.from(json["values"]!
                .map((x) => GetDesignByCategoryValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class GetDesignByCategoryValue {
  String? id;
  String? code;
  String? name;
  String? type;
  String? metalType;

  GetDesignByCategoryValue({
    this.id,
    this.code,
    this.name,
    this.type,
    this.metalType,
  });

  factory GetDesignByCategoryValue.fromRawJson(String str) =>
      GetDesignByCategoryValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetDesignByCategoryValue.fromJson(Map<String, dynamic> json) =>
      GetDesignByCategoryValue(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        type: json["type"],
        metalType: json["metal_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "type": type,
        "metal_type": metalType,
      };
}
