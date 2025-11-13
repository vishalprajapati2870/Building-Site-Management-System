import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class AssignmentModel {
  AssignmentModel({
    this.id,
    required this.siteId,
    required this.workerId,
    required this.assignedBy,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
    this.siteName,
    this.workerName,
    this.createdAt,
    this.syncStatus = 'synced',
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String?,
      siteId: json['siteId'] as String,
      workerId: json['workerId'] as String,
      assignedBy: json['assignedBy'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: json['status'] as String? ?? 'pending',
      siteName: json['siteName'] as String?,
      workerName: json['workerName'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
    );
  }

  String? id;

  String siteId;

  String workerId;

  String assignedBy;

  DateTime startTime;

  DateTime endTime;

  String status;

  String? siteName;

  String? workerName;

  DateTime? createdAt;

  String syncStatus;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'siteId': siteId,
      'workerId': workerId,
      'assignedBy': assignedBy,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'syncStatus': syncStatus,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (siteName != null) {
      data['siteName'] = siteName;
    }
    if (workerName != null) {
      data['workerName'] = workerName;
    }
    if (createdAt != null) {
      data['createdAt'] = createdAt?.toIso8601String();
    }
    return data;
  }
}
