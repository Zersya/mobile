import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:location_tracker/gen/colors.gen.dart';
import 'package:location_tracker/modules/login/view/login_page.dart';
import 'package:location_tracker/modules/map/view/map_page.dart';
import 'package:location_tracker/modules/profile/view/profile_page.dart';
import 'package:location_tracker/modules/splash/view/splash_page.dart';

class GoRouterObserver extends NavigatorObserver {
  GoRouterObserver({required this.analytics});
  final FirebaseAnalytics analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    analytics.setCurrentScreen(screenName: route.settings.name);
  }
}

class NavigationHelper {
  final GoRouter goRouter = GoRouter(
    initialLocation: '/',
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );

          const overlayColor = ColorName.primary;
          const systemBarColors = SystemUiOverlayStyle(
            systemNavigationBarColor: overlayColor,
            statusBarColor: overlayColor,
          );
          SystemChrome.setSystemUIOverlayStyle(systemBarColors);

          return child;
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'splashpage',
            builder: (context, routerState) => const SplashPage(),
          ),
          GoRoute(
            path: '/login',
            name: 'loginpage',
            builder: (context, routerState) {
              return const LoginPage();
            },
          ),
          GoRoute(
            path: '/map',
            name: 'mappage',
            builder: (context, routerState) {
              return const MapPage();
            },
          ),
          GoRoute(
            path: '/profile',
            name: 'profilepage',
            builder: (context, routerState) {
              return const ProfilePage();
            },
          ),
        ],
      )
    ],
  );

  void pop() {
    if (goRouter.canPop()) goRouter.pop();
  }

  void go(String location, {Object? extra}) {
    goRouter.go(location, extra: extra);
  }

  void goNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    goRouter.goNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  void pushNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    goRouter.pushNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  void replaceNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    goRouter.replaceNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  void goToLogin() {
    goNamed('loginpage');
  }

  void goToMap() {
    goNamed('mappage');
  }

  void goToProfile() {
    goNamed('profilepage');
  }
}

// create rooute extends Page<T> with transition
class CustomPageRouteBuilder<T> extends Page<T> {
  const CustomPageRouteBuilder({
    required this.child,
    required this.transitionsBuilder,
    super.name,
    super.arguments,
    super.key,
  });

  final Widget child;
  final RouteTransitionsBuilder transitionsBuilder;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: transitionsBuilder,
    );
  }
}
