import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  String get format => DateFormat('dd MMMM yyyy', 'id').format(this);

  String get simpleFormat => DateFormat('dd/MM/yy', 'id').format(this);
  String get requestFormat => DateFormat('yyyy-mm-dd', 'id').format(this);
  String get ddyyFormat => DateFormat('dd/yy', 'id').format(this);
  String get dayFromNow {
    final now = DateTime.now();
    final diff = now.difference(this).inDays.abs();
    return diff.toString();
  }
}

extension DateFormatExtensionNull on DateTime? {
  String get format {
    if (this != null) {
      return DateFormat('dd MMMM yyyy', 'id').format(this!);
    }
    return ' - ';
  }

  String get requestFormat {
    if (this != null) {
      return DateFormat('yyyy-MM-dd', 'id').format(this!);
    }

    return ' - ';
  }

  String get ddyyFormat {
    if (this != null) {
      return DateFormat('dd/yy', 'id').format(this!);
    }

    return ' - ';
  }
}
