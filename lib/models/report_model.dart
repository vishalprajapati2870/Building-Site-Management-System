import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ReportModel {
  ReportModel({
    this.id,
    required this.siteId,
    required this.date,
    this.totalHours = 0,
    this.overtime = 0,
    this.attendanceRate = 0,
    this.workersPresent = 0,
    this.workersAssigned = 0,
    this.noShows = 0,
    this.validationIssues = 0,
    this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String?,
      siteId: json['siteId'] as String,
      date: DateTime.parse(json['date'] as String),
      totalHours: json['totalHours'] != null
          ? (json['totalHours'] as num).toDouble()
          : 0,
      overtime: json['overtime'] != null
          ? (json['overtime'] as num).toDouble()
          : 0,
      attendanceRate: json['attendanceRate'] != null
          ? (json['attendanceRate'] as num).toDouble()
          : 0,
      workersPresent: json['workersPresent'] as int? ?? 0,
      workersAssigned: json['workersAssigned'] as int? ?? 0,
      noShows: json['noShows'] as int? ?? 0,
      validationIssues: json['validationIssues'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  String? id;

  String siteId;

  DateTime date;

  double totalHours;

  double overtime;

  double attendanceRate;

  int workersPresent;

  int workersAssigned;

  int noShows;

  int validationIssues;

  DateTime? createdAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'siteId': siteId,
      'date': date.toIso8601String(),
      'totalHours': totalHours,
      'overtime': overtime,
      'attendanceRate': attendanceRate,
      'workersPresent': workersPresent,
      'workersAssigned': workersAssigned,
      'noShows': noShows,
      'validationIssues': validationIssues,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (createdAt != null) {
      data['createdAt'] = createdAt?.toIso8601String();
    }
    return data;
  }
}
