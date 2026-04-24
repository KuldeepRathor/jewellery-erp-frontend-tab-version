import 'dart:convert';

class DailyReportResponse {
  Sales? sales;
  Purchase? purchase;
  CreditSummary? creditSummary;
  AdvanceBooking? jewelleryPlan;
  AdvanceBooking? advanceBooking;
  AdvanceBooking? orders;
  AdvanceBooking? repairs;

  DailyReportResponse({
    this.sales,
    this.purchase,
    this.creditSummary,
    this.jewelleryPlan,
    this.advanceBooking,
    this.orders,
    this.repairs,
  });

  factory DailyReportResponse.fromRawJson(String str) =>
      DailyReportResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DailyReportResponse.fromJson(Map<String, dynamic> json) =>
      DailyReportResponse(
        sales: json["sales"] == null ? null : Sales.fromJson(json["sales"]),
        purchase: json["purchase"] == null
            ? null
            : Purchase.fromJson(json["purchase"]),
        creditSummary: json["credit_summary"] == null
            ? null
            : CreditSummary.fromJson(json["credit_summary"]),
        jewelleryPlan: json["jewellery_plan"] == null
            ? null
            : AdvanceBooking.fromJson(json["jewellery_plan"]),
        advanceBooking: json["advance_booking"] == null
            ? null
            : AdvanceBooking.fromJson(json["advance_booking"]),
        orders: json["orders"] == null
            ? null
            : AdvanceBooking.fromJson(json["orders"]),
        repairs: json["repairs"] == null
            ? null
            : AdvanceBooking.fromJson(json["repairs"]),
      );

  Map<String, dynamic> toJson() => {
        "sales": sales?.toJson(),
        "purchase": purchase?.toJson(),
        "credit_summary": creditSummary?.toJson(),
        "jewellery_plan": jewelleryPlan?.toJson(),
        "advance_booking": advanceBooking?.toJson(),
        "orders": orders?.toJson(),
        "repairs": repairs?.toJson(),
      };
}

class AdvanceBooking {
  Billed? bookings;
  Billed? billed;
  Billed? cancelled;
  List<Transaction>? transactions;
  Billed? installments;
  Billed? orders;

  AdvanceBooking({
    this.bookings,
    this.billed,
    this.cancelled,
    this.transactions,
    this.installments,
    this.orders,
  });

  factory AdvanceBooking.fromRawJson(String str) =>
      AdvanceBooking.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdvanceBooking.fromJson(Map<String, dynamic> json) => AdvanceBooking(
        bookings:
            json["bookings"] == null ? null : Billed.fromJson(json["bookings"]),
        billed: json["billed"] == null ? null : Billed.fromJson(json["billed"]),
        cancelled: json["cancelled"] == null
            ? null
            : Billed.fromJson(json["cancelled"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
        installments: json["installments"] == null
            ? null
            : Billed.fromJson(json["installments"]),
        orders: json["orders"] == null ? null : Billed.fromJson(json["orders"]),
      );

  Map<String, dynamic> toJson() => {
        "bookings": bookings?.toJson(),
        "billed": billed?.toJson(),
        "cancelled": cancelled?.toJson(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
        "installments": installments?.toJson(),
        "orders": orders?.toJson(),
      };
}

class Billed {
  int? invoiceCount;
  String? amount;
  String? weight;
  String? grossWeight;
  String? averageRate;

  Billed({
    this.invoiceCount,
    this.amount,
    this.weight,
    this.grossWeight,
    this.averageRate,
  });

  factory Billed.fromRawJson(String str) => Billed.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Billed.fromJson(Map<String, dynamic> json) => Billed(
        invoiceCount: json["invoice_count"],
        amount: json["amount"],
        weight: json["weight"],
        grossWeight: json["gross_weight"],
        averageRate: json["average_rate"],
      );

  Map<String, dynamic> toJson() => {
        "invoice_count": invoiceCount,
        "amount": amount,
        "weight": weight,
        "gross_weight": grossWeight,
        "average_rate": averageRate,
      };
}

class Transaction {
  String? type;
  String? amount;

  Transaction({
    this.type,
    this.amount,
  });

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        type: json["type"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "amount": amount,
      };
}

class OldMetal {
  String? code;
  String? desc;
  int? pcs;
  String? gWt;
  String? nWt;
  String? amount;
  String? avgRatePerGm;

  OldMetal({
    this.code,
    this.desc,
    this.pcs,
    this.gWt,
    this.nWt,
    this.amount,
    this.avgRatePerGm,
  });

  factory OldMetal.fromRawJson(String str) =>
      OldMetal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OldMetal.fromJson(Map<String, dynamic> json) => OldMetal(
        code: json["code"],
        desc: json["desc"],
        pcs: json["pcs"],
        gWt: json["g_wt"],
        nWt: json["n_wt"],
        amount: json["amount"],
        avgRatePerGm: json["avg_rate_per_gm"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "desc": desc,
        "pcs": pcs,
        "g_wt": gWt,
        "n_wt": nWt,
        "amount": amount,
        "avg_rate_per_gm": avgRatePerGm,
      };
}

class CreditSummary {
  Customer? vendor;
  Customer? customer;

  CreditSummary({
    this.vendor,
    this.customer,
  });

  factory CreditSummary.fromRawJson(String str) =>
      CreditSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditSummary.fromJson(Map<String, dynamic> json) => CreditSummary(
        vendor:
            json["vendor"] == null ? null : Customer.fromJson(json["vendor"]),
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "vendor": vendor?.toJson(),
        "customer": customer?.toJson(),
      };
}

class Customer {
  String? opening;
  String? todayCredit;
  String? todayDebit;
  String? closing;

  Customer({
    this.opening,
    this.todayCredit,
    this.todayDebit,
    this.closing,
  });

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        opening: json["opening"],
        todayCredit: json["today_credit"],
        todayDebit: json["today_debit"],
        closing: json["closing"],
      );

  Map<String, dynamic> toJson() => {
        "opening": opening,
        "today_credit": todayCredit,
        "today_debit": todayDebit,
        "closing": closing,
      };
}

class Purchase {
  Billed? vendorPurchase;
  Billed? customerPurchase;
  Billed? correctionWeight;
  Billed? cancelledInvoice;
  Billed? purchaseReturn;
  List<Transaction>? transactions;

  Purchase({
    this.vendorPurchase,
    this.customerPurchase,
    this.correctionWeight,
    this.cancelledInvoice,
    this.purchaseReturn,
    this.transactions,
  });

  factory Purchase.fromRawJson(String str) =>
      Purchase.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        vendorPurchase: json["vendor_purchase"] == null
            ? null
            : Billed.fromJson(json["vendor_purchase"]),
        customerPurchase: json["customer_purchase"] == null
            ? null
            : Billed.fromJson(json["customer_purchase"]),
        correctionWeight: json["correction_weight"] == null
            ? null
            : Billed.fromJson(json["correction_weight"]),
        cancelledInvoice: json["cancelled_invoice"] == null
            ? null
            : Billed.fromJson(json["cancelled_invoice"]),
        purchaseReturn: json["purchase_return"] == null
            ? null
            : Billed.fromJson(json["purchase_return"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vendor_purchase": vendorPurchase?.toJson(),
        "customer_purchase": customerPurchase?.toJson(),
        "correction_weight": correctionWeight?.toJson(),
        "cancelled_invoice": cancelledInvoice?.toJson(),
        "purchase_return": purchaseReturn?.toJson(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Sales {
  String? balance;
  String? advance;
  Billed? totalSales;
  Billed? totalOldGold;
  Billed? correctionWeight;
  Billed? cancelledInvoice;
  Billed? salesReturn;
  List<Transaction>? transactions;
  List<OldMetal>? oldMetals;

  Sales({
    this.balance,
    this.advance,
    this.totalSales,
    this.totalOldGold,
    this.correctionWeight,
    this.cancelledInvoice,
    this.salesReturn,
    this.transactions,
    this.oldMetals,
  });

  factory Sales.fromRawJson(String str) => Sales.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
        balance: json["balance"],
        advance: json["advance"],
        totalSales: json["total_sales"] == null
            ? null
            : Billed.fromJson(json["total_sales"]),
        totalOldGold: json["total_old_gold"] == null
            ? null
            : Billed.fromJson(json["total_old_gold"]),
        correctionWeight: json["correction_weight"] == null
            ? null
            : Billed.fromJson(json["correction_weight"]),
        cancelledInvoice: json["cancelled_invoice"] == null
            ? null
            : Billed.fromJson(json["cancelled_invoice"]),
        salesReturn: json["sales_return"] == null
            ? null
            : Billed.fromJson(json["sales_return"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
        oldMetals: json["old_metals"] == null
            ? []
            : List<OldMetal>.from(
                json["old_metals"]!.map((x) => OldMetal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "advance": advance,
        "total_sales": totalSales?.toJson(),
        "total_old_gold": totalOldGold?.toJson(),
        "correction_weight": correctionWeight?.toJson(),
        "cancelled_invoice": cancelledInvoice?.toJson(),
        "sales_return": salesReturn?.toJson(),
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
        "old_metals": oldMetals == null
            ? []
            : List<dynamic>.from(oldMetals!.map((x) => x.toJson())),
      };
}
