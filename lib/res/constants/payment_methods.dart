// lib/constants/payment_constants.dart
class PaymentConstants {
  PaymentConstants._();

  // Payment method mappings
  static const Map<String, String> paymentMethods = {
    'CASH': 'Cash',
    'CHEQUE': 'Chq',
    'CARD': 'CC/DC',
    'BANK_TRANSFER': 'RTGS/NEFT',
    'UPI/IMPS': 'UPI/IMPS',
    'CHIT': 'Chit',
  };

  // Payment method keys (for easier access)
  static const String cashKey = 'CASH';
  static const String chequeKey = 'CHEQUE';
  static const String cardKey = 'CARD';
  static const String bankTransferKey = 'BANK_TRANSFER';
  static const String upiImpsKey = 'UPI/IMPS';
  static const String chitKey = 'CHIT';
  static const String neftRtgsMethod = 'NEFT/RTGS';

  // Zero amount representations
  static const List<String> zeroAmounts = ['0', '0.00'];
}
