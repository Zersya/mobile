import 'package:location_tracker/models/base_response.dart';
import 'package:location_tracker/utils/enums.dart';
import 'package:location_tracker/utils/exceptions.dart';
import 'package:location_tracker/utils/typedefs.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ResponseWrapper {
  static T guard<T>(
    ResponseOfRequest<dynamic> response, {
    void Function(Object e)? onError,
  }) {
    assert(
      T == MapString || T == List || T == String,
      'T must be MapString or List or String',
    );

    try {
      if (response.status == ResponseStatus.success) {
        final data = response.data! as T;

        return data;
      }
      throw CustomExceptionString(
        response.message ?? 'Unknown error',
        exception: response.exception,
      );
    } catch (e) {
      if (e is CustomExceptionString) {
        if (e.exception != null) {
          Sentry.captureException(e.exception);
        }

        onError?.call(e);
        rethrow;
      }

      onError?.call(e);
      rethrow;
    }
  }
}
