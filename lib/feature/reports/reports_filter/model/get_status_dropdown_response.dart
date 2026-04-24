// Response wrapper for the list
class GetStatusDropdownResponse {
  List<StatusItem>? statuses;

  GetStatusDropdownResponse({this.statuses});

  factory GetStatusDropdownResponse.fromJson(List<dynamic> json) =>
      GetStatusDropdownResponse(
        statuses: json.map((item) => StatusItem.fromJson(item)).toList(),
      );
}

// Single status item model
class StatusItem {
  String? id;
  String? status;

  StatusItem({
    this.id,
    this.status,
  });

  factory StatusItem.fromJson(Map<String, dynamic> json) => StatusItem(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };
}
