import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class SiteModel {
  SiteModel({
    this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.geofenceRadiusMeters = 100,
    this.qrToken,
    this.qrTokenGeneratedAt,
    this.createdAt,
    this.isActive = true,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      geofenceRadiusMeters: json['geofenceRadiusMeters'] != null
          ? (json['geofenceRadiusMeters'] as num).toDouble()
          : 100,
      qrToken: json['qrToken'] as String?,
      qrTokenGeneratedAt: json['qrTokenGeneratedAt'] != null
          ? DateTime.parse(json['qrTokenGeneratedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  String? id;

  String ownerId;

  String name;

  String address;

  double lat;

  double lng;

  double geofenceRadiusMeters;

  String? qrToken;

  DateTime? qrTokenGeneratedAt;

  DateTime? createdAt;

  bool isActive;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'geofenceRadiusMeters': geofenceRadiusMeters,
      'isActive': isActive,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (qrToken != null) {
      data['qrToken'] = qrToken;
    }
    if (qrTokenGeneratedAt != null) {
      data['qrTokenGeneratedAt'] = qrTokenGeneratedAt?.toIso8601String();
    }
    if (createdAt != null) {
      data['createdAt'] = createdAt?.toIso8601String();
    }
    return data;
  }
}
