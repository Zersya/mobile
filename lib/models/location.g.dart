// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      json['id'] as String,
      (json['latlng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['speed'] as num).toDouble(),
      (json['head'] as num).toDouble(),
      json['timestamp'] as int,
      json['battery'] as int,
      json['user'] as String,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'latlng': instance.latlng,
      'speed': instance.speed,
      'head': instance.head,
      'timestamp': instance.timestamp,
      'battery': instance.battery,
      'user': instance.user,
    };
