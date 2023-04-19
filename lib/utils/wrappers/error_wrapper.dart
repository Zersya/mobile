import 'package:location_tracker/models/base_response.dart';
import 'package:location_tracker/utils/exceptions.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorWrapper {
  static Future<BaseResponse<T>> asyncGuard<T>(
    Future<BaseResponse<T>> Function() f, {
    void Function(Object e)? onError,
  }) async {
    try {
      return await f();
    } catch (e) {
      if (e is CustomExceptionString) {
        if (e.exception != null) {
          await Sentry.captureException(e.exception);
        }

        onError?.call(e);
        rethrow;
      }

      await Sentry.captureException(e);

      onError?.call(e);
      rethrow;
    }
  }
}
