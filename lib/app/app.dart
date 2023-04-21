import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_tracker/app/cubit/app_cubit.dart';
import 'package:location_tracker/gen/colors.gen.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';
import 'package:location_tracker/utils/get_it.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

///MainApp
class App extends StatefulWidget {
  ///Constructor for main flutter app
  const App({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final ColorScheme _colorSchemeLight = const ColorScheme(
    brightness: Brightness.light,
    primary: ColorName.primary,
    primaryContainer: ColorName.primaryContainer,
    secondary: ColorName.secondary,
    secondaryContainer: ColorName.secondaryContainer,
    background: ColorName.background,
    error: ColorName.error,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: ColorName.primary,
    onSurface: ColorName.textPrimary,
    onBackground: ColorName.textPrimary,
    onError: ColorName.error,
  );

  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();

    GetItContainer.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppCubit('id')..init(),
        ),
      ],
      child: _AppBody(colorScheme: _colorSchemeLight),
    );
  }
}

class _AppBody extends StatelessWidget {
  const _AppBody({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;

    if (state is AppLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final appRouter = GetIt.I<NavigationHelper>().goRouter;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp.router(
        title: 'Qazwa Mobile',
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        routeInformationProvider: appRouter.routeInformationProvider,
        routeInformationParser: appRouter.routeInformationParser,
        routerDelegate: appRouter.routerDelegate,
        theme: ThemeData(
          colorScheme: colorScheme,
          primaryColor: colorScheme.primary,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
              titleMedium: TextStyle(
                color: ColorName.textPrimary,
              ),
              titleSmall: TextStyle(
                color: ColorName.textSecondary,
                fontSize: 11,
              ),
              headlineSmall: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorName.textPrimary,
              ),
              titleLarge: TextStyle(
                color: ColorName.textPrimary,
              ),
              bodyMedium: TextStyle(
                color: ColorName.textPrimary,
              ),
              bodyLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorName.textSecondary,
              ),
              bodySmall: TextStyle(
                color: ColorName.textSecondary,
              ),
            ),
          ),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
