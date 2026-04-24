class WebStoreDropDownStatusItem {
  String? id;

  String? status;

  WebStoreDropDownStatusItem({this.id, this.status});

  WebStoreDropDownStatusItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";

    status = json['status'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    data['status'] = status;
    return data;
  }
}
