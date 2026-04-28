/*
 * esc_pos_utils
 * Created by Andrey U.
 *
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

enum PosAlign { left, center, right }

enum PosCutMode { full, partial }

enum PosFontType { fontA, fontB }

enum PosDrawer { pin2, pin5 }

/// Choose image printing function
/// bitImageRaster: GS v 0 (obsolete)
/// graphics: GS ( L
enum PosImageFn { bitImageRaster, graphics }

List<PosTextSize> posFontSizes = [
  PosTextSize.size1,
  PosTextSize.size2,
  PosTextSize.size3,
  PosTextSize.size4,
  PosTextSize.size5,
  PosTextSize.size6,
  PosTextSize.size7,
  PosTextSize.size8,
];

class PosTextSize {
  const PosTextSize._internal(this.value);
  final int value;
  static const size1 = PosTextSize._internal(1);
  static const size2 = PosTextSize._internal(2);
  static const size3 = PosTextSize._internal(3);
  static const size4 = PosTextSize._internal(4);
  static const size5 = PosTextSize._internal(5);
  static const size6 = PosTextSize._internal(6);
  static const size7 = PosTextSize._internal(7);
  static const size8 = PosTextSize._internal(8);

  static int decSize(PosTextSize height, PosTextSize width) =>
      16 * (width.value - 1) + (height.value - 1);

  static PosTextSize fromValue(int? value) {
    switch (value) {
      case 1:
        return PosTextSize.size1;
      case 2:
        return PosTextSize.size2;
      case 3:
        return PosTextSize.size3;
      case 4:
        return PosTextSize.size4;
      case 5:
        return PosTextSize.size5;
      case 6:
        return PosTextSize.size6;
      case 7:
        return PosTextSize.size7;
      case 8:
        return PosTextSize.size8;
      default:
        return PosTextSize.size1;
    }
  }

  static String title(PosTextSize posTextSize) {
    switch (posTextSize) {
      case PosTextSize.size1:
        return 'Size1';
      case PosTextSize.size2:
        return 'Size2';
      case PosTextSize.size3:
        return 'Size3';
      case PosTextSize.size4:
        return 'Size4';
      case PosTextSize.size5:
        return 'Size5';
      case PosTextSize.size6:
        return 'Size6';
      case PosTextSize.size7:
        return 'Size7';
      case PosTextSize.size8:
        return 'Size8';
      default:
        return 'none';
    }
  }
}

class PaperSize {
  const PaperSize._internal(this.value);
  final int value;
  static const mm58 = PaperSize._internal(1);
  static const mm80 = PaperSize._internal(2);
  static const mm70 = PaperSize._internal(3);

  String get name {
    switch (value) {
      case 1:
        return '58 mm';
      case 2:
        return '80 mm';
      case 3:
        return '70 mm';
      default:
        throw ArgumentError("Invalid Paper Size");
    }
  }

  int get width {
    switch (value) {
      case 1:
        return 372;
      case 2:
        return 558;
      default:
        return 488;
    }
  }

  static PaperSize fromWidth(int width) {
    switch (width) {
      case 372:
        return mm58;
      case 558:
        return mm80;
      default:
        return mm70;
    }
  }
}

class PosBeepDuration {
  const PosBeepDuration._internal(this.value);
  final int value;
  static const beep50ms = PosBeepDuration._internal(1);
  static const beep100ms = PosBeepDuration._internal(2);
  static const beep150ms = PosBeepDuration._internal(3);
  static const beep200ms = PosBeepDuration._internal(4);
  static const beep250ms = PosBeepDuration._internal(5);
  static const beep300ms = PosBeepDuration._internal(6);
  static const beep350ms = PosBeepDuration._internal(7);
  static const beep400ms = PosBeepDuration._internal(8);
  static const beep450ms = PosBeepDuration._internal(9);
}
