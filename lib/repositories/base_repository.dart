import 'package:location_tracker/models/base_response.dart';
import 'package:location_tracker/services/api_services.dart';
import 'package:location_tracker/utils/wrappers/response_wrapper.dart';

abstract class BaseRepository extends ApiServices {
  T responseWrapper<T>(
    ResponseOfRequest<dynamic> response, {
    void Function(Object e)? onError,
  }) =>
      ResponseWrapper.guard(response, onError: onError);
}
