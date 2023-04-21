import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:location_tracker/app/app.dart';
import 'package:location_tracker/app/app_bloc_observer.dart';
import 'package:location_tracker/firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

final providers = [
  GoogleProvider(clientId: DefaultFirebaseOptions.ios.iosClientId ?? ''),
];

Future<void> main() async {
  await dotenv.load();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders(providers, app: firebaseApp);

  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  timeago.setLocaleMessages('id', timeago.IdMessages());

  Bloc.observer = AppBlocObserver();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn =
            'https://943ef574caf5476b98bfcb7690a7b1d8@o1194000.ingest.sentry.io/4505047042883584'
        ..environment = kReleaseMode ? 'production' : 'development'
        ..tracesSampleRate = 0.35;
    },
    appRunner: () => runApp(const App()),
  );
}
