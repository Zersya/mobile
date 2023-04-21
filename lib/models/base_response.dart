// ignore_for_file: overridden_fields

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/flash_message_helper.dart';
import 'package:location_tracker/models/meta.dart';
import 'package:location_tracker/utils/enums.dart';
import 'package:location_tracker/utils/typedefs.dart';
import 'package:logger/logger.dart';

/// Base class for handle response of dio request
class ResponseOfRequest<T> extends BaseResponse<T> {
  /// Constructor that able to use attribute parent
  ResponseOfRequest({
    required ResponseStatus super.status,
    super.message,
    super.meta,
    super.data,
    super.exception,
  });

  factory ResponseOfRequest.success({
    required dynamic data,
  }) {
    Meta? meta;
    String? strMsg;
    var status = false;

    if (data is List) {
      return ResponseOfRequest<T>(
        status: ResponseStatus.success,
        meta: meta,
        data: data,
        message: strMsg,
      );
    } else if (data is Map) {
      data as Map<String, dynamic>;

      if (data.containsKey('message')) {
        if (data['message'] is String) {
          strMsg = data['message'] as String;
        } 
      }

      if (data.containsKey('meta')) {
        final tempMeta = data['meta'] as MapString;
        if (tempMeta.containsKey('current_page') &&
            tempMeta.containsKey('last_page') &&
            tempMeta.containsKey('per_page') &&
            tempMeta.containsKey('total')) {
          meta = Meta.fromJson(data['meta'] as MapString);
        }
      }

      if (data.containsKey('code')) {
        status = data['code'] as int >= 200 && data['code'] as int < 300;

        return ResponseOfRequest(
          status: status ? ResponseStatus.success : ResponseStatus.failed,
          meta: meta,
          data: data,
          message: strMsg,
        );
      }

      return ResponseOfRequest(
        status: ResponseStatus.success,
        meta: meta,
        data: data,
        message: strMsg,
      );
    } else if (data is String) {
      return ResponseOfRequest(
        status: ResponseStatus.success,
        meta: meta,
        data: data,
        message: strMsg,
      );
    }

    return ResponseOfRequest(
      status: ResponseStatus.failed,
      meta: meta,
      message: strMsg,
    );
  }

  factory ResponseOfRequest.error({
    DioError? error,
    dynamic data,
  }) {
    Logger().e(error ?? data);

    if (error != null) {
      if (error.response != null) {
        if (error.response!.statusCode == 401) {
          return ResponseOfRequest(
            message: 'Unauthorized',
            status: ResponseStatus.failed,
          );
        }
      }
    }
    String? strMsg;

    if (data is String) {
      strMsg = data.replaceAll('["', '').replaceAll('"]', '');
      GetIt.I<FlashMessageHelper>().showError(strMsg);

      return ResponseOfRequest(
        message: error?.message ?? strMsg,
        status: ResponseStatus.failed,
      );
    }

    if (data is List) {
      if (data.isNotEmpty) {
        strMsg = data.first.toString();
        GetIt.I<FlashMessageHelper>().showError(strMsg);

        return ResponseOfRequest(
          message: error?.message ?? strMsg,
          status: ResponseStatus.failed,
        );
      }
    }

    if (data == null || data is! MapString) {
      if (error?.response == null) {
        strMsg = 'Connection error';
        GetIt.I<FlashMessageHelper>().showError(strMsg);

        return ResponseOfRequest(
          message: strMsg,
          status: ResponseStatus.failed,
        );
      }

      strMsg = 'Something went wrong';
      GetIt.I<FlashMessageHelper>().showError(strMsg);

      return ResponseOfRequest(
        message: error?.message ?? strMsg,
        status: ResponseStatus.failed,
        exception: error,
      );
    }

    if (data.containsKey('message')) {
      if (data['message'] is String) {
        strMsg = data['message'] as String;
      }
    }

    GetIt.I<FlashMessageHelper>().showError(strMsg);

    return ResponseOfRequest(
      data: data,
      message: strMsg,
      status: ResponseStatus.failed,
    );
  }

  /// Getter the status code of the response.
  // bool? statusCode;
}

/// Base class for all the response API, with generic data type on [data].
class BaseResponse<T> {
  /// Base constructor for all casted response.
  BaseResponse({
    this.data,
    this.status,
    this.meta,
    this.message,
    this.exception,
  });

  /// Success response state
  factory BaseResponse.success(T data, {Meta? meta}) {
    return BaseResponse<T>(
      data: data,
      status: ResponseStatus.success,
      meta: meta,
    );
  }

  /// Fail response state
  factory BaseResponse.failure(String? message) {
    return BaseResponse<T>(message: message, status: ResponseStatus.failed);
  }

  /// Getter the response status success, failure
  ResponseStatus? status;

  /// Getter the response message.
  String? message;

  /// Getter the response meta, for meta List.
  Meta? meta;

  /// Getter the response data.
  dynamic data;

  /// Exceptions
  Exception? exception;
}
