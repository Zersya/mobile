// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:io' show SocketException;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/models/base_response.dart';
import 'package:location_tracker/utils/constants.dart';
import 'package:location_tracker/utils/exceptions.dart';
import 'package:location_tracker/utils/typedefs.dart';
import 'package:retry/retry.dart';

/// Base class for all the requests
class ApiServices {
  final _dio = GetIt.I<Dio>();

  /// GET the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequest<T>> get<T>(
    String api, {
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.get<T>(
        api,
        queryParameters: currentQueryParameters,
        options: Options(headers: currentHeaders),
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// POST the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequest<T>> post<T>(
    String api, {
    dynamic data,
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await retry(
        () => _dio.post<T>(
          api,
          data: data,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// PUT the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequestMap> put<T>(
    String api, {
    dynamic data,
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await retry(
        () => _dio.put<T>(
          api,
          data: data,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// PATCH the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequestMap> patch<T>(
    String api, {
    dynamic data,
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await retry(
        () => _dio.patch<T>(
          api,
          data: data,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }

  /// DELETE the data with the given parameters
  /// it can handle any of pre request that will always require for example
  /// get token from secure storage or get the logged in user id
  Future<ResponseOfRequest<T>> delete<T>(
    String api, {
    dynamic data,
    MapString? queryParameters,
    MapString? headers,
  }) async {
    try {
      final token =
          await GetIt.I<FlutterSecureStorage>().read(key: kAccessToken);

      final currentHeaders = <String, dynamic>{};

      final currentQueryParameters = <String, dynamic>{};

      if (headers != null) {
        currentHeaders.addAll(headers);
      }

      if (queryParameters != null) {
        currentQueryParameters.addAll(queryParameters);
      }

      if (token != null) {
        currentHeaders['Authorization'] = 'Bearer $token';
      }

      final response = await retry(
        () => _dio.delete<T>(
          api,
          data: data,
          queryParameters: currentQueryParameters,
          options: Options(headers: currentHeaders),
        ),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      return ResponseOfRequest.success(data: response.data);
    } on DioError catch (e) {
      return ResponseOfRequest.error(
        data: e.response?.data,
        error: e,
      );
    } on CustomExceptionMap catch (e) {
      return ResponseOfRequest.error(data: e.cause);
    } on Exception {
      return ResponseOfRequest.error();
    }
  }
}
