enum PartyType {
  customer,
  vendor,
}

extension PartyTypeExtension on PartyType {
  String get name {
    switch (this) {
      case PartyType.customer:
        return 'customer';
      case PartyType.vendor:
        return 'vendor';
    }
  }
}

enum StoneRateType { CT, GM, PC }

const String ADD_NEW = "+ Add New";

const List<String> mcUnits = ["nwt", "gwt", "pcs"];
const List<String> vaUnits = ["%", "gm"];

enum MakingChargesOption { VaMc, WeightRate, WeightPcRate, PcRate }

extension MakingChargesOptionExtension on MakingChargesOption {
  String get name {
    switch (this) {
      case MakingChargesOption.VaMc:
        return 'VA, MC';
      case MakingChargesOption.WeightPcRate:
        return 'Weight, PC rate';

      case MakingChargesOption.WeightRate:
        return 'Weight, Rate/gm';
      case MakingChargesOption.PcRate:
        return 'PC Rate';
    }
  }

  String get id {
    switch (this) {
      case MakingChargesOption.VaMc:
        return '1';

      case MakingChargesOption.WeightRate:
        return '2';

      case MakingChargesOption.WeightPcRate:
        return '3';

      case MakingChargesOption.PcRate:
        return '4';
    }
  }
}

const String NOVENDOR = "NONE";
const double DROPDOWN_OPTIONS_MAX_WIDTH = 400;

const double DROPDOWN_OPTIONS_MIN_WIDTH = 200;
