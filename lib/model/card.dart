import 'package:xendit_ios/util/validator.dart';

/// Credit Card
class XCardIos {
  /// Credit Card Number
  final String creditCardNumber;

  /// Credit Card CVN
  final String creditCardCVN;

  /// Card Expiration Month
  final String expirationMonth;

  /// Card Expiration Year
  final String expirationYear;

  XCardIos({
    required String creditCardNumber,
    required String creditCardCVN,
    required this.expirationMonth,
    required this.expirationYear,
  })  : creditCardNumber = CardValidator.cleanCardNumber(creditCardNumber),
        creditCardCVN = CardValidator.cleanCvn(creditCardCVN);

  /// Convert XCardIos to Map
  Map<String, dynamic> to() => <String, dynamic>{
        'creditCardNumber': creditCardNumber,
        'creditCardCVN': creditCardCVN,
        'expirationMonth': expirationMonth,
        'expirationYear': expirationYear,
      };
}
