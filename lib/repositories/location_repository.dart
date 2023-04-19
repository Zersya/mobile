import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracker/models/base_response.dart';
import 'package:location_tracker/services/api_services.dart';
import 'package:location_tracker/utils/constants.dart';
import 'package:location_tracker/utils/enums.dart';

class LocationRepository extends ApiServices {
  Future<BaseResponse> sentData(Position position) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final batteryLevel = await Battery().batteryLevel;

    final queryParams = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'speed': position.speed,
      'head': position.heading,
      'username': 'sintia',
      'timestamp': timestamp,
      'battery': batteryLevel,
    };

    final response = await post<void>(ApiEndPoint.kApiLocation,
        queryParameters: queryParams);

    if (response.status == ResponseStatus.success) {
      return BaseResponse<dynamic>.success(null);
    }
    return BaseResponse<String>.failure(response.message);
  }
}
