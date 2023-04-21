import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  Location(
    this.id,
    this.latlng,
    this.speed,
    this.head,
    this.timestamp,
    this.battery,
    this.user,
  );

  /// Converter from response map data to model
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// Converter from model to map data for request
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  final String id;

  final List<double> latlng;

  final double speed;

  final double head;

  final int timestamp;

  final int battery;

  final String user;
}
