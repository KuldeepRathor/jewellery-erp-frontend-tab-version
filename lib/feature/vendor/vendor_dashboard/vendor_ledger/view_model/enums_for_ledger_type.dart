enum TransactionType {
  purchase,
  purchaseReturn,
  sales,
  salesReturn,
  payment,
  receipt,
  unknown
}

class TransactionTypeStrings {
  static const String PURCHASE = "Purchase";
  static const String PURCHASE_RETURN = "Purchase Return";
  static const String SALES = "Sales";
  static const String SALES_RETURN = "Sales Return";
  static const String PAYMENT = "Payment";
  static const String RECEIPT = "Payment Receipt";
}

extension TransactionTypeHelper on TransactionType {
  static TransactionType fromString(String? typeString) {
    if (typeString == null) return TransactionType.unknown;

    switch (typeString) {
      case TransactionTypeStrings.PURCHASE:
        return TransactionType.purchase;
      case TransactionTypeStrings.PURCHASE_RETURN:
        return TransactionType.purchaseReturn;
      case TransactionTypeStrings.SALES:
        return TransactionType.sales;
      case TransactionTypeStrings.SALES_RETURN:
        return TransactionType.salesReturn;
      case TransactionTypeStrings.PAYMENT:
        return TransactionType.payment;
      case TransactionTypeStrings.RECEIPT:
        return TransactionType.receipt;
      default:
        return TransactionType.unknown;
    }
  }
}
