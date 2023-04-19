import 'package:intl/intl.dart';

/// Currency format for Rupiah ( IDR )
NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'id',
  decimalDigits: 0,
  name: 'Rp. ',
  symbol: 'Rp. ',
);

NumberFormat currencyFormatterIDR = NumberFormat.currency(
  locale: 'id',
  decimalDigits: 0,
  name: 'IDR ',
  symbol: 'IDR ',
);

/// Currency format for Rupiah ( IDR )
NumberFormat currencyFormatterNoLeading =
    NumberFormat.currency(locale: 'id', decimalDigits: 0, name: '', symbol: '');
