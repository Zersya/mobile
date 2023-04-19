import 'package:location_tracker/utils/extensions/string_extension.dart';

extension EnumExtension on Enum {
  String get toStringValue {
    return name.capitalize;
  }
}
