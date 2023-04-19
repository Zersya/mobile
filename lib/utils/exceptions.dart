import 'package:location_tracker/utils/typedefs.dart';

class CustomExceptionMap implements Exception {
  CustomExceptionMap(this.cause);
  MapString cause;
}

class CustomExceptionString implements Exception {
  CustomExceptionString(this.cause, {this.exception});

  String cause;
  Exception? exception;

  @override
  String toString() {
    return cause;
  }
}
