enum ActionType { page, category, collection }

enum ItemStatusEnum {
  all("ALL"),
  hold("HOLD"),
  delivered("DELIVERED");

  final String value;
  const ItemStatusEnum(this.value);

  static ItemStatusEnum? fromValue(String? value) {
    if (value == null) return null;

    try {
      return ItemStatusEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum PaymentStatusEnum {
  all("ALL"),
  pending("PENDING"),
  completed("COMPLETED");

  final String value;
  const PaymentStatusEnum(this.value);

  static PaymentStatusEnum? fromValue(String? value) {
    if (value == null) return null;

    try {
      return PaymentStatusEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum InvoiceStatusEnum {
  all("ALL"),
  cancelled("CANCELLED"),
  active("ACTIVE");

  final String value;
  const InvoiceStatusEnum(this.value);

  static InvoiceStatusEnum? fromValue(String? value) {
    if (value == null) return null;

    try {
      return InvoiceStatusEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum TransactionTypeEnum {
  exchange("EXCHANGE"),
  purchase("PURCHASE");

  final String value;
  const TransactionTypeEnum(this.value);

  static TransactionTypeEnum? fromValue(String? value) {
    if (value == null) return null;

    try {
      return TransactionTypeEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum CustomerReviewTypeEnum {
  merit("MERIT"),
  conflict("CONFLICT");

  final String value;
  const CustomerReviewTypeEnum(this.value);

  static CustomerReviewTypeEnum? fromValue(String? value) {
    if (value == null) return null;

    try {
      return CustomerReviewTypeEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum OtherEnum {
  hideNull("HIDE_NULL");

  final String value;
  const OtherEnum(this.value);

  static OtherEnum? fromValue(String? value) {
    if (value == null) return null;

    try {
      return OtherEnum.values.firstWhere(
        (e) => e.value == value,
      );
    } catch (_) {
      return null;
    }
  }
}

enum GenderEnum {
  male("M", "Male"),
  female("F", "Female");

  final String value; // for API
  final String label; // for UI

  const GenderEnum(this.value, this.label);

  static GenderEnum? fromValue(String? value) {
    if (value == null) return null;
    try {
      return GenderEnum.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
