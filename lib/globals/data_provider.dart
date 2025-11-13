import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';
import 'package:building_site_build_by_vishal/globals/demo_data.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class DataProvider extends ChangeNotifier {
  DataProvider();

  factory DataProvider.of(BuildContext context, {bool listen = false}) {
    return Provider.of<DataProvider>(context, listen: listen);
  }

  List<SiteModel> _sites = [];

  List<SiteModel> get sites {
    return _sites;
  }

  List<AssignmentModel> _assignments = [];

  List<AssignmentModel> get assignments {
    return _assignments;
  }

  List<TimeLogModel> _timeLogs = [];

  List<TimeLogModel> get timeLogs {
    return _timeLogs;
  }

  List<UserModel> _workers = [];

  List<UserModel> get workers {
    return _workers;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  bool _mockDataSeeded = false;

  void initializeMockData(String ownerId) {
    if (_mockDataSeeded) {
      return;
    }
    _sites = DemoData.buildSites(ownerId);
    _workers = DemoData.workers;
    _assignments = DemoData.initialAssignments(ownerId);
    _timeLogs = DemoData.initialTimeLogs();
    _mockDataSeeded = true;
    notifyListeners();
  }

  void addSite(SiteModel site) {
    _sites.add(site);
    notifyListeners();
  }

  void updateSite(SiteModel site) {
    final int index = _sites.indexWhere((s) => s.id == site.id);
    if (index != -1) {
      _sites[index] = site;
      notifyListeners();
    }
  }

  void addAssignment(AssignmentModel assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  void addTimeLog(TimeLogModel timeLog) {
    _timeLogs.add(timeLog);
    notifyListeners();
  }

  List<AssignmentModel> getWorkerAssignments(String workerId) {
    return _assignments.where((a) => a.workerId == workerId).toList();
  }

  List<AssignmentModel> getTodayAssignments(String workerId) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return _assignments
        .where(
          (a) =>
              a.workerId == workerId &&
              a.startTime.isAfter(today) &&
              a.startTime.isBefore(today.add(const Duration(days: 1))),
        )
        .toList();
  }

  SiteModel? getSiteById(String siteId) {
    try {
      return _sites.firstWhere((s) => s.id == siteId);
    } catch (e) {
      return null;
    }
  }

  int getCheckedInCount(String siteId) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<TimeLogModel> todayCheckIns = _timeLogs
        .where(
          (log) =>
              log.siteId == siteId &&
              log.type == 'checkin' &&
              log.timestamp.isAfter(today),
        )
        .toList();
    final Set<String> checkedInWorkers = {};
    for (final log in todayCheckIns) {
      checkedInWorkers.add(log.workerId);
    }
    return checkedInWorkers.length;
  }
}
