// ignore_for_file: avoid_print

import 'dart:math';

class DiscountItem {
  final double weight;
  final double va;
  final double mc;
  final String vaType;

  DiscountItem({
    required this.weight,
    required this.va,
    required this.mc,
    required this.vaType,
  });
}

class DiscountCalculator {
  /// Calculate the total discount amount for a list of items.
  ///
  /// [accumulatedWeight]: Total accumulated weight
  /// [accumulatedAmount]: Total accumulated amount
  /// [rate]: The rate per unit/gram
  /// [items]: List of items containing weight, va (value addition), mc (making charges), and va_type
  static double calculateDiscountForWeightBasedPlan({
    required double accumulatedWeight,
    required double accumulatedAmount,
    required double rate,
    required List<DiscountItem> items,
  }) {
    // TODO: add a check if the plan is completed once saket adds the correct api for fetching jewellery plan api
    // TODO: if plan is completed the do all the below calculations
    // TODO: else redeemable amount will be equal to the amount the user has paid till now
    print('accumulatedWeight: $accumulatedWeight');
    print('accumulatedAmount: $accumulatedAmount');
    print('rate: $rate');
    print('items: $items');
    print('--------------------------');

    double totalDiscountAmount = 0;
    double newAccumulatedWeight = accumulatedWeight;

    for (var item in items) {
      // Determine the calculation weight
      double calculationWeight = min(newAccumulatedWeight, item.weight);

      if (calculationWeight <= 0) {
        break; // Stop if no accumulated weight remains
      }

      // Recalculate remaining accumulated weight
      newAccumulatedWeight -= calculationWeight;

      // Perform VA conversion if va_type is "%"
      double va;
      if (item.vaType == '%') {
        va = calculationWeight * (item.va / 100);
      } else {
        va = item.va;
      }

      // Calculate VA discount
      double vaDiscount = va * rate;

      // Calculate MC discount
      double mcDiscount = item.mc * calculationWeight;

      // Calculate discount amount for the current item
      double discountAmount = vaDiscount + mcDiscount;

      // Add to the total discount amount
      totalDiscountAmount += discountAmount;
      print('vaDiscount: $vaDiscount');
      print('mcDiscount: $mcDiscount');
      print('discountAmount: $discountAmount');
    }

    // Calculate rate difference (previously discount_3)
    double rateDifference = (rate * accumulatedWeight) - accumulatedAmount;
    print('rateDifference: $rateDifference');

    // Add rate difference to the total discount amount
    // TODO: ask if we have to add amount
    totalDiscountAmount += rateDifference;

    return totalDiscountAmount;
  }

  static double calculateDiscountForAmountBasedPlan({
    required double accumulatedWeight,
    required double accumulatedAmount,
    required double rate,
    required List<DiscountItem> items,
  }) {
    // TODO: add a check if the plan is completed once saket adds the correct api for fetching jewellery plan api
    // TODO: if plan is completed the do all the below calculations
    // TODO: else redeemable amount will be equal to the amount the user has paid till now

    print('accumulatedWeight: $accumulatedWeight');
    print('accumulatedAmount: $accumulatedAmount');
    print('rate: $rate');
    print('items: $items');
    print('--------------------------');

    double totalDiscountAmount = 0;
    double newAccumulatedWeight = accumulatedWeight;

    for (var item in items) {
      // Determine the calculation weight
      double calculationWeight = min(newAccumulatedWeight, item.weight);

      if (calculationWeight <= 0) {
        break; // Stop if no accumulated weight remains
      }

      // Recalculate remaining accumulated weight
      newAccumulatedWeight -= calculationWeight;

      // Perform VA conversion if va_type is "%"
      double va;
      if (item.vaType == '%') {
        va = calculationWeight * (item.va / 100);
      } else {
        va = item.va;
      }

      // Calculate VA discount
      double vaDiscount = va * rate;

      // Calculate MC discount
      double mcDiscount = item.mc * calculationWeight;

      // Calculate discount amount for the current item
      double discountAmount = vaDiscount + mcDiscount;

      // Add to the total discount amount
      totalDiscountAmount += discountAmount;
      print('vaDiscount: $vaDiscount');
      print('mcDiscount: $mcDiscount');
      print('discountAmount: $discountAmount');
    }

    // // Calculate rate difference (previously discount_3)
    // double rateDifference = (rate * accumulatedWeight) - accumulatedAmount;
    // print('rateDifference: $rateDifference');

    // // Add rate difference to the total discount amount
    // totalDiscountAmount += rateDifference;

    return totalDiscountAmount;
  }
}
