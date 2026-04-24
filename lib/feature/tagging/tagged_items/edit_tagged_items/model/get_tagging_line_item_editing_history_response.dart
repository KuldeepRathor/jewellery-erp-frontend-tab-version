import 'dart:convert';

class GetTaggingLineItemEditHistoryResponse {
  String? taggingLineItemId;
  List<EditHistory>? editHistory;
  int? totalCount;

  GetTaggingLineItemEditHistoryResponse({
    this.taggingLineItemId,
    this.editHistory,
    this.totalCount,
  });

  factory GetTaggingLineItemEditHistoryResponse.fromRawJson(String str) =>
      GetTaggingLineItemEditHistoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTaggingLineItemEditHistoryResponse.fromJson(
          Map<String, dynamic> json) =>
      GetTaggingLineItemEditHistoryResponse(
        taggingLineItemId: json["tagging_line_item_id"],
        editHistory: json["edit_history"] == null
            ? []
            : List<EditHistory>.from(
                json["edit_history"]!.map((x) => EditHistory.fromJson(x))),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "tagging_line_item_id": taggingLineItemId,
        "edit_history": editHistory == null
            ? []
            : List<dynamic>.from(editHistory!.map((x) => x.toJson())),
        "total_count": totalCount,
      };
}

class EditHistory {
  String? id;
  String? roleId;
  String? roleReadableId;
  String? flow;
  String? editField;
  String? editFieldName;
  String? oldValue;
  String? newValue;
  dynamic oldRelationId;
  dynamic newRelationId;
  DateTime? createdAt;
  String? displayText;

  EditHistory({
    this.id,
    this.roleId,
    this.roleReadableId,
    this.flow,
    this.editField,
    this.editFieldName,
    this.oldValue,
    this.newValue,
    this.oldRelationId,
    this.newRelationId,
    this.createdAt,
    this.displayText,
  });

  factory EditHistory.fromRawJson(String str) =>
      EditHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditHistory.fromJson(Map<String, dynamic> json) => EditHistory(
        id: json["id"],
        roleId: json["role_id"],
        roleReadableId: json["role_readable_id"],
        flow: json["flow"],
        editField: json["edit_field"],
        editFieldName: json["edit_field_name"],
        oldValue: json["old_value"],
        newValue: json["new_value"],
        oldRelationId: json["old_relation_id"],
        newRelationId: json["new_relation_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        displayText: json["display_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "role_readable_id": roleReadableId,
        "flow": flow,
        "edit_field": editField,
        "edit_field_name": editFieldName,
        "old_value": oldValue,
        "new_value": newValue,
        "old_relation_id": oldRelationId,
        "new_relation_id": newRelationId,
        "created_at": createdAt?.toIso8601String(),
        "display_text": displayText,
      };
}
