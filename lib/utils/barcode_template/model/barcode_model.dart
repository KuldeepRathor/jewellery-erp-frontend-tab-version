class BarcodeModel {
  final String barCode;
  final int count;
  final int fontSize;
  final String fontFamily;
  final bool showNumber;
  final String? itemName;
  final String? itemCode;
  final String? weight;
  final String? purity;
  final String? weightGroup;
  final String? netQyt;

  BarcodeModel({
    this.weightGroup,
    this.itemName,
    this.itemCode,
    this.purity,
    this.weight,
    required this.barCode,
    this.count = 2,
    this.showNumber = false,
    this.netQyt,
    this.fontSize = 8,
    this.fontFamily = 'Mulish',
  });
}
