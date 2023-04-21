import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/location_helper.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<LocationHelper>().getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }

        if (snapshot.hasData) {
          final data = snapshot.data;

          return MapboxMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(data?.latitude ?? 0, data?.longitude ?? 0),
              zoom: 13,
            ),
            accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
          );
        }

        return const Center(
          child: Text('No data'),
        );
      },
    );
  }
}
