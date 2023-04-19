import 'package:location_tracker/utils/functions.dart';

extension CurrencyExtension on num? {
  /// Convert current object to string
  String get formatCurrency {
    if (this == null) {
      return 'Rp.0';
    }

    return currencyFormatter.format(this);
  }
}
