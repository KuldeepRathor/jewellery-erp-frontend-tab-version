import 'package:flutter/material.dart';

class StoneDetailsTableData {
  TextEditingController name;
  TextEditingController stone_code;
  TextEditingController carat_weight;
  TextEditingController pcs;
  TextEditingController rate;
  TextEditingController total;
  String weightUnit;
  String? id;
  String? previousUnitBeforePC;
  List<FocusNode> tableFocusNodes = [
    FocusNode(
      canRequestFocus: true,
      descendantsAreFocusable: true,
      descendantsAreTraversable: true,
    ),
    FocusNode(canRequestFocus: true),
    FocusNode(canRequestFocus: true),
    FocusNode(canRequestFocus: true),
    FocusNode(canRequestFocus: true),
    FocusNode(canRequestFocus: true),
  ];

  String weightUnitFromBackend;
  bool isOtherStone;
  StoneDetailsTableData({
    required this.name,
    TextEditingController? stone_code,
    required this.carat_weight,
    required this.pcs,
    required this.rate,
    required this.total,
    this.weightUnit = 'CT',
    this.weightUnitFromBackend = 'CT',
    this.previousUnitBeforePC,
    required this.id,
    this.isOtherStone = false,
  }) : stone_code = stone_code ?? TextEditingController();

  Map<String, dynamic> toJsonValue() {
    return {
      'name': name.text,
      'stone_code': stone_code.text,
      'carat_weight': carat_weight.text,
      'weight_unit': weightUnit,
      'pcs': pcs.text,
      'rate': rate.text,
      'total': total.text,
    };
  }
}
