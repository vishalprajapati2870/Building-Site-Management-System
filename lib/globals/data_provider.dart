import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';
import 'package:building_site_build_by_vishal/globals/demo_data.dart';
import 'package:building_site_build_by_vishal/services/firebase_service.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class DataProvider extends ChangeNotifier {
  DataProvider() {
    _firebaseService = FirebaseService();
  }

  factory DataProvider.of(BuildContext context, {bool listen = false}) {
    return Provider.of<DataProvider>(context, listen: listen);
  }

  late final FirebaseService _firebaseService;
  List<SiteModel> _sites = [];
  List<AssignmentModel> _assignments = [];
  List<TimeLogModel> _timeLogs = [];
  List<UserModel> _workers = [];
  bool _isLoading = false;
  bool _mockDataSeeded = false;
  bool _useFirebase = true;

  FirebaseService get firebaseService => _firebaseService;
  List<SiteModel> get sites => _sites;
  List<AssignmentModel> get assignments => _assignments;
  List<TimeLogModel> get timeLogs => _timeLogs;
  List<UserModel> get workers => _workers;
  bool get isLoading => _isLoading;

  Future<void> loadData(UserModel user) async {
    if (_useFirebase) {
      await _loadFromFirebase(user);
    } else {
      initializeMockData(user.role == 'owner' ? user.id! : DemoData.primaryOwner.id!);
    }
  }

  Future<void> _loadFromFirebase(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (user.role == 'owner') {
        // Load sites for owner
        _sites = await _firebaseService.getSites(user.id!);
        // Listen to sites stream
        _firebaseService.getSitesStream(user.id!).listen((sites) {
          _sites = sites;
          notifyListeners();
        });
      }

      // Load workers
      _workers = await _firebaseService.getWorkers();
      _firebaseService.getWorkersStream().listen((workers) {
        _workers = workers;
        notifyListeners();
      });

      // Load assignments
      if (user.role == 'owner') {
        _assignments = await _firebaseService.getAssignments(null);
        _firebaseService.getAssignmentsStream(null).listen((assignments) {
          _assignments = assignments;
          notifyListeners();
        });
      } else {
        _assignments = await _firebaseService.getWorkerAssignments(user.id!);
        _firebaseService.getAssignmentsStream(null).listen((assignments) {
          _assignments = assignments.where((a) => a.workerId == user.id).toList();
          notifyListeners();
        });
      }

      // Load time logs
      _timeLogs = await _firebaseService.getTimeLogs(null, null, null);
      _firebaseService.getTimeLogsStream(null, null, null).listen((timeLogs) {
        _timeLogs = timeLogs;
        notifyListeners();
      });
    } catch (e) {
      // Fallback to mock data on error
      _useFirebase = false;
      initializeMockData(user.role == 'owner' ? user.id! : DemoData.primaryOwner.id!);
    }

    _isLoading = false;
    notifyListeners();
  }

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

  Future<void> addSite(SiteModel site) async {
    if (_useFirebase) {
      await _firebaseService.addSite(site);
      // Stream will update automatically
    } else {
      _sites.add(site);
      notifyListeners();
    }
  }

  Future<void> updateSite(SiteModel site) async {
    if (_useFirebase) {
      await _firebaseService.updateSite(site);
      // Stream will update automatically
    } else {
      final int index = _sites.indexWhere((s) => s.id == site.id);
      if (index != -1) {
        _sites[index] = site;
        notifyListeners();
      }
    }
  }

  Future<void> addAssignment(AssignmentModel assignment) async {
    if (_useFirebase) {
      await _firebaseService.addAssignment(assignment);
      // Stream will update automatically
    } else {
      _assignments.add(assignment);
      notifyListeners();
    }
  }

  Future<void> addTimeLog(TimeLogModel timeLog) async {
    if (_useFirebase) {
      await _firebaseService.addTimeLog(timeLog);
      // Stream will update automatically
    } else {
      _timeLogs.add(timeLog);
      notifyListeners();
    }
  }

  Future<List<AssignmentModel>> getWorkerAssignments(String workerId) async {
    if (_useFirebase) {
      return await _firebaseService.getWorkerAssignments(workerId);
    }
    return _assignments.where((a) => a.workerId == workerId).toList();
  }

  Future<List<AssignmentModel>> getTodayAssignments(String workerId) async {
    if (_useFirebase) {
      return await _firebaseService.getTodayAssignments(workerId);
    }
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

  Future<int> getCheckedInCount(String siteId) async {
    if (_useFirebase) {
      return await _firebaseService.getCheckedInCount(siteId);
    }
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
