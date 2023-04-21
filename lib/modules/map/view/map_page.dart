import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/flash_message_helper.dart';
import 'package:location_tracker/helpers/location_helper.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';
import 'package:location_tracker/models/location.dart';
import 'package:location_tracker/repositories/location_repository.dart';
import 'package:location_tracker/utils/functions.dart';
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
        return;
      }
    }

    final repo = LocationRepository();
    final result = await repo.getHistory(username);
    final position = await helper.getCurrentLocation();

    emit(
      state.copyWith(
        position: position,
        locations: result.data as List<Location>,
      ),
    );

    await GetIt.I<LocationHelper>().registerOnLocationChanged();
  }
}

class _LocationState extends Equatable {
  const _LocationState({
    required this.isHasPermissionService,
    required this.position,
    required this.locations,
  });

  factory _LocationState.initial() {
    return const _LocationState(
      isHasPermissionService: false,
      position: null,
      locations: null,
    );
  }

  final Position? position;
  final bool isHasPermissionService;
  final List<Location>? locations;

  @override
  List<Object?> get props => [position, isHasPermissionService, locations];

  _LocationState copyWith({
    Position? position,
    bool? isHasPermissionService,
    List<Location>? locations,
  }) {
    return _LocationState(
      position: position ?? this.position,
      isHasPermissionService:
          isHasPermissionService ?? this.isHasPermissionService,
      locations: locations ?? this.locations,
    );
  }
}

class MapPage extends StatelessWidget with WidgetsBindingObserver {
  const MapPage({super.key});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final locationHelper = GetIt.I<LocationHelper>();
    switch (state) {
      case AppLifecycleState.resumed:
        locationHelper.registerOnLocationChanged();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        locationHelper.cancelOnLocationChanged();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        GetIt.I<LocationHelper>().cancelOnLocationChanged();
        GetIt.I<NavigationHelper>().pop();

        return Future.value(false);
      },
      child: Scaffold(
        body: BlocProvider(
          create: (context) => _LocationCubit()..init(),
          child: _MapContentWidget(),
        ),
      ),
    );
  }
}

class _MapContentWidget extends StatefulWidget {
  @override
  State<_MapContentWidget> createState() => _MapContentWidgetState();
}

class _MapContentWidgetState extends State<_MapContentWidget> {
  MapboxMapController? controller;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<_LocationCubit>().state;

    if (!state.isHasPermissionService) {
      return const Center(
        child: Text('No permission'),
      );
    }

    if (state.isHasPermissionService &&
        state.position != null &&
        state.locations != null) {
      return MapboxMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            state.locations?.first.latlng[0] ?? 0,
            state.locations?.first.latlng[1] ?? 0,
          ),
          zoom: 13,
        ),
        myLocationEnabled: true,
        accessToken: dotenv.env['MAPBOX_DOWNLOADS_TOKEN'],
        styleString: 'mapbox://styles/zeinersyad/clgqth186000901qy712a816i',
        onStyleLoadedCallback: () {
          if (controller == null) {
            return;
          }

          controller!.addLine(
            LineOptions(
              geometry: state.locations!
                  .map((e) => LatLng(e.latlng[0], e.latlng[1]))
                  .toList(),
              lineColor: '#3bb2d0',
              lineWidth: 3,
              lineOpacity: 0.8,
            ),
          );
        },
        onMapCreated: (controller) {
          this.controller = controller;
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
