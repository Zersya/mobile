import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/flash_message_helper.dart';
import 'package:location_tracker/helpers/location_helper.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';
import 'package:location_tracker/helpers/notification_helper.dart';

/// Container for DI
class GetItContainer {
  /// Initialize the DI Contanier in MainApp
  static void initialize() {
    GetIt.I.registerSingleton<NavigationHelper>(NavigationHelper());
    GetIt.I.registerSingleton<LocationHelper>(LocationHelper());
    GetIt.I.registerSingleton<FlashMessageHelper>(FlashMessageHelper());

    GetIt.I
        .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

    GetIt.I.registerSingleton<NotificationHelper>(NotificationHelper());

    GetIt.I.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin(),
    );
  }

  /// Initialize the DI Container in SplashScreen
  static void initializeConfig(Dio dio) {
    GetIt.I.registerSingleton<Dio>(dio);
  }
}
