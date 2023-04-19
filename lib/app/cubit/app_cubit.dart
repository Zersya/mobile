// ignore_for_file: unnecessary_statements, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/repositories/main_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.lang) : super(const AppLoading());

  final String lang;

  Future<void> init() async {
    final _service = MainRepository();
    await _service.init(lang);

    await refresh();
  }

  Future<void> refresh() async {
    emit(const AppLoading());

    await Future<void>.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();

    emit(const AppInitial());
  }
}

class HideNavigationBarCubit extends Cubit<bool> {
  HideNavigationBarCubit() : super(false);

  void updateState({required bool state}) {
    emit(state);
  }
}
