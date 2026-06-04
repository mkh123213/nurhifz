import 'package:intl/intl.dart';

extension NumExt on num {
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    return NumberFormat.currency(symbol: symbol, decimalDigits: decimals)
        .format(this);
  }

  String toCompact() => NumberFormat.compact().format(this);

  String toPercent({int decimals = 0}) =>
      '${toStringAsFixed(decimals)}%';
}
