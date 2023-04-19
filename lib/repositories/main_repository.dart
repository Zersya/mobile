// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/flash_message_helper.dart';
import 'package:location_tracker/helpers/notification_helper.dart';
import 'package:location_tracker/utils/constants.dart';
import 'package:location_tracker/utils/get_it.dart';

/// Used to initialize the application in splashscreen
class MainRepository {
  /// The method is used to initialize the Application
  /// Setup the DI container, Dio, Hive and etc.
  Future<void> init(String lang) async {
    try {
      final dio = _setupDio(lang);

      GetItContainer.initializeConfig(dio);
      if (!kIsWeb) {
        await GetIt.I<NotificationHelper>().initialize();
      }
    } catch (e) {
      GetIt.I<FlashMessageHelper>()
          .showError(e.toString(), duration: const Duration(seconds: 15));
    }
  }

  Dio _setupDio(String lang, {bool isUseLogger = true}) {
    final options = BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(milliseconds: 16000),
      receiveTimeout: const Duration(milliseconds: 16000),
      sendTimeout: const Duration(milliseconds: 16000),
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Origin': '*'
      },
    );

    final dio = Dio(options);

    if (isUseLogger && kDebugMode) {
      dio.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          if (e.response != null && e.response!.statusCode == 401) {
            //TODO: logout
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
