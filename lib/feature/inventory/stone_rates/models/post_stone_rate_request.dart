import 'dart:convert';

class PostStoneRateRequest {
  String? code;
  String? name;
  String? rateType;
  String? rate;
  String? color;
  String? cut;
  String? clarity;
  String? buyBackPercentage;
  String? organizationId;
  String? ornamentId;
  bool? change_existing_rate;
  bool? isOther;
  PostStoneRateRequest({
    this.code,
    this.name,
    this.rateType,
    this.rate,
    this.color,
    this.cut,
    this.clarity,
    this.buyBackPercentage,
    this.organizationId,
    this.ornamentId,
    this.change_existing_rate,
    this.isOther,
  });

  factory PostStoneRateRequest.fromRawJson(String str) =>
      PostStoneRateRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostStoneRateRequest.fromJson(Map<String, dynamic> json) =>
      PostStoneRateRequest(
        code: json["code"],
        name: json["name"],
        rateType: json["rate_type"],
        rate: json["rate"],
        color: json["color"],
        cut: json["cut"],
        clarity: json["clarity"],
        buyBackPercentage: json["buy_back_percentage"],
        organizationId: json["organization_id"],
        ornamentId: json["ornament_id"],
        change_existing_rate: json["change_existing_rate"],
        isOther: json["is_other"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "rate_type": rateType,
        "rate": rate,
        "color": color,
        "cut": cut,
        "clarity": clarity,
        "buy_back_percentage": buyBackPercentage,
        "organization_id": organizationId,
        "ornament_id": ornamentId,
        "change_existing_rate": change_existing_rate,
        "is_other": isOther,
      };
}
