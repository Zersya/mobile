import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/flash_message_helper.dart';
import 'package:location_tracker/helpers/location_helper.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class _LocationCubit extends Cubit<_LocationState> {
  _LocationCubit() : super(_LocationState.initial());

  Future<void> init() async {
    final helper = GetIt.I<LocationHelper>();
    final isHasPermissionService = await helper.isHasPermissionService();

    emit(state.copyWith(isHasPermissionService: isHasPermissionService));

    if (!isHasPermissionService) {
      final result = await helper.initPermissions();
      emit(state.copyWith(isHasPermissionService: result));

      if (result) {
        final position = await helper.getCurrentLocation();
        emit(state.copyWith(position: position));
      } else {
        GetIt.I<NavigationHelper>().pop();
        GetIt.I<FlashMessageHelper>().showError('No permission');
      }
    } else {
      final position = await helper.getCurrentLocation();
      emit(state.copyWith(position: position));
    }
  }
}

class _LocationState extends Equatable {
  const _LocationState({
    required this.isHasPermissionService,
    required this.position,
  });

  factory _LocationState.initial() {
    return const _LocationState(
      isHasPermissionService: false,
      position: null,
    );
  }

  final Position? position;
  final bool isHasPermissionService;

  @override
  List<Object?> get props => [position, isHasPermissionService];

  _LocationState copyWith({
    Position? position,
    bool? isHasPermissionService,
  }) {
    return _LocationState(
      position: position ?? this.position,
      isHasPermissionService:
          isHasPermissionService ?? this.isHasPermissionService,
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _LocationCubit()..init(),
        child: const _MapContentWidget(),
      ),
    );
  }
}

class _MapContentWidget extends StatelessWidget {
  const _MapContentWidget();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<_LocationCubit>().state;

    if (!state.isHasPermissionService) {
      return const Center(
        child: Text('No permission'),
      );
    }

    if (state.isHasPermissionService && state.position != null) {
      final data = state.position;
      return MapboxMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(data?.latitude ?? 0, data?.longitude ?? 0),
          zoom: 13,
        ),
        accessToken: dotenv.env['MAPBOX_DOWNLOADS_TOKEN'],
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
