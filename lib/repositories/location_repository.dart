import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracker/models/base_response.dart';
import 'package:location_tracker/models/location.dart';
import 'package:location_tracker/repositories/base_repository.dart';
import 'package:location_tracker/utils/constants.dart';
import 'package:location_tracker/utils/enums.dart';
import 'package:location_tracker/utils/typedefs.dart';

class LocationRepository extends BaseRepository {
  Future<BaseResponse<dynamic>> sentData(
    Position position,
    String username,
  ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final batteryLevel = await Battery().batteryLevel;

    final data = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'speed': position.speed,
      'head': position.heading,
      'username': username,
      'timestamp': timestamp,
      'battery': batteryLevel,
    };

    final response = await post<void>(
      ApiEndPoint.kApiLocation,
      data: data,
    );

    if (response.status == ResponseStatus.success) {
      return BaseResponse<dynamic>.success(null);
    }
    return BaseResponse<String>.failure(response.message);
  }

  // TODO: For offline mode
  // Future<BaseResponse<dynamic>> sentDataBatch(
  //   List<Position> positions,
  //   String username,
  // ) async {
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;

  //   final batteryLevel = await Battery().batteryLevel;

  //   final data = {
  //     'positions': positions,
  //     'username': username,
  //     'timestamp': timestamp,
  //     'battery': batteryLevel,
  //   };

  //   final response = await post<void>(
  //     ApiEndPoint.kApiLocationBatch,
  //     data: data,
  //   );

  //   if (response.status == ResponseStatus.success) {
  //     return BaseResponse<dynamic>.success(null);
  //   }
  //   return BaseResponse<String>.failure(response.message);
  // }

  Future<BaseResponse<List<Location>>> getHistory(
    String username, {
    String? date,
  }) async {
    final response = await get<MapString>(
      ApiEndPoint.kApiLocation,
      queryParameters: {
        'username': username,
        if (date != null) 'date': date,
      },
    );

    final result = responseWrapper<MapString>(response);
    final rawList = result['data'] as List<dynamic>;
    final list = List<MapString>.from(rawList).map(Location.fromJson).toList();

    return BaseResponse.success(list);
  }
}
