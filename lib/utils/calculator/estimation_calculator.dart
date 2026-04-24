// Enums for VA and MC calculation types
enum VAType { percentage, grams, none }

enum MCType { perGramOnGrossWeight, perGramOnNettWeight, perPiece, none }

// Convert VAType string to enum
VAType getVAType(String? wastageType) {
  if (wastageType == null) return VAType.none;
  return wastageType.toLowerCase() == '%' ? VAType.percentage : VAType.grams;
}

// Convert MCType string to enum
MCType getMCType(String? mcType) {
  if (mcType == null) return MCType.none;

  switch (mcType.toLowerCase()) {
    case 'gwt':
      return MCType.perGramOnGrossWeight;
    case 'nwt':
      return MCType.perGramOnNettWeight;
    default:
      return MCType.perPiece;
  }
}

// Class to store calculation inputs
class JewelryCalculationInputs {
  final double nettWeight;
  final VAType vaType;
  final double vaValue;
  final double metalRate;
  final double grossWeight;
  final MCType mcType;
  final double mcValue;
  final double stoneCost;
  final bool isGstApplicable;
  final double gstPercentage;
  final bool printGstInVA;

  JewelryCalculationInputs({
    required this.nettWeight,
    required this.vaType,
    required this.vaValue,
    required this.metalRate,
    required this.grossWeight,
    required this.mcType,
    required this.mcValue,
    required this.stoneCost,
    required this.isGstApplicable,
    required this.gstPercentage,
    required this.printGstInVA,
  });

  @override
  String toString() {
    return 'JewelryCalculationInputs('
        'nettWeight: $nettWeight, '
        'vaType: $vaType, '
        'vaValue: $vaValue, '
        'metalRate: $metalRate, '
        'grossWeight: $grossWeight, '
        'mcType: $mcType, '
        'mcValue: $mcValue, '
        'stoneCost: $stoneCost, '
        'isGstApplicable: $isGstApplicable, '
        'gstPercentage: $gstPercentage, '
        'printGstInVA: $printGstInVA)';
  }
}

// Class to store calculation results
class JewelryCalculationResults {
  final double vaInGrams;
  final double weightAfterVA;
  final double metalCost; // A
  final double makingCharge; // B
  final double stoneCost; // C
  final double subTotal;
  final double gstAmount;
  final double total;
  final double vaWithGST;

  // Display-related properties
  final double vaDisplayValue;
  final String vaDisplayUnit;
  final double mcDisplayValue;
  final String mcDisplayUnit;

  JewelryCalculationResults({
    required this.vaInGrams,
    required this.weightAfterVA,
    required this.metalCost,
    required this.makingCharge,
    required this.stoneCost,
    required this.subTotal,
    required this.gstAmount,
    required this.total,
    required this.vaWithGST,
    required this.vaDisplayValue,
    required this.vaDisplayUnit,
    required this.mcDisplayValue,
    required this.mcDisplayUnit,
  });

  @override
  String toString() {
    return 'JewelryCalculationResults('
        'vaInGrams: $vaInGrams, '
        'weightAfterVA: $weightAfterVA, '
        'metalCost: $metalCost, '
        'makingCharge: $makingCharge, '
        'stoneCost: $stoneCost, '
        'subTotal: $subTotal, '
        'gstAmount: $gstAmount, '
        'total: $total, '
        'vaWithGST: $vaWithGST, '
        'vaDisplayValue: $vaDisplayValue, '
        'vaDisplayUnit: $vaDisplayUnit, '
        'mcDisplayValue: $mcDisplayValue, '
        'mcDisplayUnit: $mcDisplayUnit)';
  }
}

// Complete report class
class JewelryCalculationReport {
  final JewelryCalculationInputs inputs;
  final JewelryCalculationResults calculations;

  JewelryCalculationReport({
    required this.inputs,
    required this.calculations,
  });

  @override
  String toString() {
    return 'JewelryCalculationReport(\n'
        'inputs: $inputs,\n'
        'calculations: $calculations\n'
        ')';
  }
}

class JewelryCalculator {
  // Core values
  double nettWeight;
  VAType vaType;
  double vaValue; // Either percentage or direct grams based on vaType
  double metalRate;
  double grossWeight;
  MCType mcType;
  double mcValue; // Value based on mcType (per gram or per piece)
  double stoneCost;
  bool isGstApplicable;
  double gstPercentage;
  bool printGstInVA;
  bool isPcRateOnly;

  bool isWeightPcRate;
  double costDiscount;

  JewelryCalculator({
    required this.nettWeight,
    this.vaType = VAType.none,
    this.vaValue = 0,
    required this.metalRate,
    this.grossWeight = 0,
    this.mcType = MCType.none,
    this.mcValue = 0,
    this.stoneCost = 0,
    this.isGstApplicable = false,
    this.gstPercentage = 3.0,
    this.printGstInVA = false,
    this.costDiscount = 0,
    this.isPcRateOnly = false,
    this.isWeightPcRate = false,
  });

  // Calculate VA in grams
  double calculateVAInGrams() {
    switch (vaType) {
      case VAType.percentage:
        return nettWeight * (vaValue / 100);
      case VAType.grams:
        return vaValue;
      case VAType.none:
        return 0;
      // default:
      //   return 0;
    }
  }

  // Calculate weight after adding VA
  double calculateWeightAfterVA() {
    return nettWeight + calculateVAInGrams();
  }

  // Calculate metal cost (A)
  double calculateMetalCost() {
    double weightAfterVA = calculateWeightAfterVA();
    if (isPcRateOnly) {
      return metalRate;
    } else if (isWeightPcRate) {
      return metalRate;
    } else {
      return weightAfterVA * metalRate;
    }
  }

  // Calculate Making Charge (B)
  double calculateMakingCharge() {
    switch (mcType) {
      case MCType.perGramOnGrossWeight:
        if (grossWeight > 0) {
          return grossWeight * mcValue;
        }
        return 0;
      case MCType.perGramOnNettWeight:
        if (nettWeight > 0) {
          return nettWeight * mcValue;
        }
        return 0;
      case MCType.perPiece:
        return mcValue;
      case MCType.none:
        return 0;
      // default:
      //   return 0;
    }
  }

  // Calculate stone cost (C)
  double getStoneCost() {
    return stoneCost;
  }

  double getCostDiscount() {
    return costDiscount;
  }

  // Calculate subtotal (A + B + C - D)
  double calculateSubTotal() {
    double metalCost = calculateMetalCost(); // A (VA + netWeight)
    double makingCharge = calculateMakingCharge(); // B
    double stoneValue = getStoneCost(); // C
    double costDiscountValue = getCostDiscount(); // D
    return metalCost + makingCharge + stoneValue - costDiscountValue;
  }

  // Calculate total with GST
  double calculateTotal() {
    double subTotal = calculateSubTotal();

    if (isGstApplicable) {
      return subTotal + (subTotal * (gstPercentage / 100));
    } else {
      return subTotal;
    }
  }

  // If GST is to be printed in VA
  double calculateVAWithGST() {
    if (printGstInVA) {
      double subTotal = calculateSubTotal();
      double gstAmount = subTotal * (gstPercentage / 100);
      double vaWithGst = calculateVAInGrams() + (gstAmount / metalRate);

      return vaWithGst;
    }
    return calculateVAInGrams();
  }

  // Generate a detailed calculation report
  JewelryCalculationReport generateReport() {
    // Calculate all values
    double vaInGrams = calculateVAInGrams();
    double metalCost = calculateMetalCost();
    double makingCharge = calculateMakingCharge();
    double stoneValue = getStoneCost();
    double subTotal = calculateSubTotal();
    double gstAmount = isGstApplicable ? (subTotal * (gstPercentage / 100)) : 0;
    double total = calculateTotal();
    double weightAfterVA = calculateWeightAfterVA();
    double vaWithGST = printGstInVA ? calculateVAWithGST() : vaInGrams;

    // Create inputs object
    final inputs = JewelryCalculationInputs(
      nettWeight: nettWeight,
      vaType: vaType,
      vaValue: vaValue,
      metalRate: metalRate,
      grossWeight: grossWeight,
      mcType: mcType,
      mcValue: mcValue,
      stoneCost: stoneCost,
      isGstApplicable: isGstApplicable,
      gstPercentage: gstPercentage,
      printGstInVA: printGstInVA,
    );

    // Create calculations object
    final calculations = JewelryCalculationResults(
      vaInGrams: vaInGrams,
      weightAfterVA: weightAfterVA,
      metalCost: metalCost,
      makingCharge: makingCharge,
      stoneCost: stoneValue,
      subTotal: subTotal,
      gstAmount: gstAmount,
      total: total,
      vaWithGST: vaWithGST,
      vaDisplayValue: vaValue,
      vaDisplayUnit: vaType == VAType.percentage ? "%" : "gm",
      mcDisplayValue: mcValue,
      mcDisplayUnit: mcType == MCType.perPiece
          ? "per piece"
          : (mcType == MCType.perGramOnGrossWeight ? "per gwt" : "per nwt"),
    );

    // Return complete report
    return JewelryCalculationReport(
      inputs: inputs,
      calculations: calculations,
    );
  }
}
