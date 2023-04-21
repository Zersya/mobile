import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/flash_message_helper.dart';
import 'package:location_tracker/repositories/location_repository.dart';
import 'package:location_tracker/utils/exceptions.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LocationHelper {
  // ignore: cancel_subscriptions
  StreamSubscription<UserAccelerometerEvent>? streamOnUserAccelerometerChange;
  StreamSubscription<Position>? streamOnLocationDataChange;

  Future<bool> initPermissions() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      const msg = 'Need to activate location service';
      GetIt.I<FlashMessageHelper>().showError(msg);

      throw CustomExceptionString(msg);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const msg = 'Need to accept location permission';
        GetIt.I<FlashMessageHelper>().showError(msg);

        throw CustomExceptionString(msg);
      }
    }

    final isGranted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    return serviceEnabled && isGranted;
  }

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition();
  }

  Future<bool> isHasPermissionService() async {
    final permission = await Geolocator.checkPermission();

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> registerOnLocationChanged() async {
    if (streamOnUserAccelerometerChange != null &&
        streamOnLocationDataChange != null) return;

    final username =
        FirebaseAuth.instance.currentUser?.displayName?.replaceAll(' ', '-') ??
            'unknown';
    final repo = LocationRepository();

    var isOnSent = false;

    streamOnUserAccelerometerChange =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) async {
      if (!isOnSent) {
        isOnSent = true;

        final now = DateTime.now();
        final seconds = now.millisecondsSinceEpoch ~/ 1000;
        final curLocation = await getCurrentLocation();

        if (event.x.round() >= 2 || event.z.round() >= 2) {
          if (seconds % 30 == 0) {
            await repo.sentData(curLocation, username);
          }
        } else {
          if (seconds % 3600 == 0) {
            await repo.sentData(curLocation, username);
          }
        }
        await Future<void>.delayed(const Duration(seconds: 1));
        isOnSent = false;
      }
    });

    var initLocation = await getCurrentLocation();

    streamOnLocationDataChange =
        Geolocator.getPositionStream().listen((event) async {
      final distanceMeter = Geolocator.distanceBetween(
        initLocation.latitude,
        initLocation.longitude,
        event.latitude,
        event.longitude,
      );
      if (!isOnSent) {
        isOnSent = true;

        if (distanceMeter.round() >= 500) {
          await repo.sentData(event, username);
          initLocation = event;
        }

        await Future<void>.delayed(const Duration(seconds: 1));
        isOnSent = false;
      }
    });
  }

  void pauseOnLocationChanged() {
    if (streamOnLocationDataChange != null) {
      streamOnLocationDataChange!.pause();
    }
    if (streamOnUserAccelerometerChange != null) {
      streamOnUserAccelerometerChange!.pause();
    }
  }

  void cancelOnLocationChanged() {
    if (streamOnLocationDataChange != null) {
      streamOnLocationDataChange!.cancel();
      streamOnLocationDataChange = null;
    }
    if (streamOnUserAccelerometerChange != null) {
      streamOnUserAccelerometerChange!.cancel();
      streamOnUserAccelerometerChange = null;
    }
  }
}
