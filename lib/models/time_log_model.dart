import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class TimeLogModel {
  TimeLogModel({
    this.id,
    required this.assignmentId,
    required this.workerId,
    required this.siteId,
    required this.type,
    required this.timestamp,
    this.lat,
    this.lng,
    this.photoPath,
    this.deviceId,
    this.ip,
    this.serverValidated = false,
    this.validationNotes,
    this.distanceFromSite,
    this.syncStatus = 'synced',
    this.localPhotoPath,
  });

  factory TimeLogModel.fromJson(Map<String, dynamic> json) {
    return TimeLogModel(
      id: json['id'] as String?,
      assignmentId: json['assignmentId'] as String,
      workerId: json['workerId'] as String,
      siteId: json['siteId'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
      photoPath: json['photoPath'] as String?,
      deviceId: json['deviceId'] as String?,
      ip: json['ip'] as String?,
      serverValidated: json['serverValidated'] as bool? ?? false,
      validationNotes: json['validationNotes'] as String?,
      distanceFromSite: json['distanceFromSite'] != null
          ? (json['distanceFromSite'] as num).toDouble()
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      localPhotoPath: json['localPhotoPath'] as String?,
    );
  }

  String? id;

  String assignmentId;

  String workerId;

  String siteId;

  String type;

  DateTime timestamp;

  double? lat;

  double? lng;

  String? photoPath;

  String? deviceId;

  String? ip;

  bool serverValidated;

  String? validationNotes;

  double? distanceFromSite;

  String syncStatus;

  String? localPhotoPath;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'assignmentId': assignmentId,
      'workerId': workerId,
      'siteId': siteId,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'serverValidated': serverValidated,
      'syncStatus': syncStatus,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (lat != null) {
      data['lat'] = lat;
    }
    if (lng != null) {
      data['lng'] = lng;
    }
    if (photoPath != null) {
      data['photoPath'] = photoPath;
    }
    if (deviceId != null) {
      data['deviceId'] = deviceId;
    }
    if (ip != null) {
      data['ip'] = ip;
    }
    if (validationNotes != null) {
      data['validationNotes'] = validationNotes;
    }
    if (distanceFromSite != null) {
      data['distanceFromSite'] = distanceFromSite;
    }
    if (localPhotoPath != null) {
      data['localPhotoPath'] = localPhotoPath;
    }
    return data;
  }
}
