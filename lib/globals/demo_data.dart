import 'package:building_site_build_by_vishal/app_constants.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';

class DemoData {
  DemoData._();

  static final Map<String, _DemoUserRecord> _demoUsers = {
    'owner@demo.com': _DemoUserRecord(
      user: UserModel(
        id: 'owner_demo',
        name: 'Amelia Stone',
        email: 'owner@demo.com',
        role: AppConstants.roleOwner,
        createdAt: DateTime(2024, 1, 15),
      ),
      password: 'password',
    ),
    'worker@demo.com': _DemoUserRecord(
      user: UserModel(
        id: 'worker_john',
        name: 'John Smith',
        email: 'worker@demo.com',
        role: AppConstants.roleWorker,
        skills: const ['Carpentry', 'Masonry'],
        hourlyRate: 35,
        createdAt: DateTime(2024, 2, 2),
      ),
      password: 'password',
    ),
    'worker2@demo.com': _DemoUserRecord(
      user: UserModel(
        id: 'worker_maria',
        name: 'Maria Garcia',
        email: 'worker2@demo.com',
        role: AppConstants.roleWorker,
        skills: const ['Electrical', 'Plumbing'],
        hourlyRate: 42,
        createdAt: DateTime(2024, 2, 18),
      ),
      password: 'password',
    ),
    'worker3@demo.com': _DemoUserRecord(
      user: UserModel(
        id: 'worker_james',
        name: 'James Wilson',
        email: 'worker3@demo.com',
        role: AppConstants.roleWorker,
        skills: const ['Welding', 'Heavy Equipment'],
        hourlyRate: 38,
        createdAt: DateTime(2024, 3, 3),
      ),
      password: 'password',
    ),
  };

  static String normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  static UserModel? userForEmail(String email) {
    final record = _demoUsers[normalizeEmail(email)];
    if (record == null) {
      return null;
    }
    return record.user.clone();
  }

  static String? passwordForEmail(String email) {
    return _demoUsers[normalizeEmail(email)]?.password;
  }

  static List<UserModel> get workers {
    return _demoUsers.values
        .where((record) => record.user.role == AppConstants.roleWorker)
        .map((record) => record.user.clone())
        .toList(growable: false);
  }

  static List<UserModel> get owners {
    return _demoUsers.values
        .where((record) => record.user.role == AppConstants.roleOwner)
        .map((record) => record.user.clone())
        .toList(growable: false);
  }

  static UserModel get primaryOwner {
    return owners.first;
  }

  static List<SiteModel> buildSites(String ownerId) {
    final DateTime now = DateTime.now();
    return [
      SiteModel(
        id: 'site_downtown',
        ownerId: ownerId,
        name: 'Downtown Construction Site',
        address: '123 Main St, City',
        lat: 37.7749,
        lng: -122.4194,
        geofenceRadiusMeters: 150,
        createdAt: now.subtract(const Duration(days: 28)),
        isActive: true,
      ),
      SiteModel(
        id: 'site_riverside',
        ownerId: ownerId,
        name: 'Riverside Building Project',
        address: '456 River Rd, City',
        lat: 37.7849,
        lng: -122.4094,
        geofenceRadiusMeters: 200,
        createdAt: now.subtract(const Duration(days: 21)),
        isActive: true,
      ),
      SiteModel(
        id: 'site_midtown',
        ownerId: ownerId,
        name: 'Midtown Office Complex',
        address: '789 Central Ave, City',
        lat: 37.7642,
        lng: -122.431,
        geofenceRadiusMeters: 120,
        createdAt: now.subtract(const Duration(days: 14)),
        isActive: true,
      ),
    ];
  }

  static List<AssignmentModel> initialAssignments(String ownerId) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = today.add(const Duration(days: 1));
    return [
      AssignmentModel(
        id: 'assignment_demo_1',
        siteId: 'site_downtown',
        workerId: 'worker_john',
        assignedBy: ownerId,
        startTime: today.add(const Duration(hours: 8)),
        endTime: today.add(const Duration(hours: 16)),
        status: AppConstants.statusConfirmed,
        createdAt: now.subtract(const Duration(hours: 16)),
      ),
      AssignmentModel(
        id: 'assignment_demo_2',
        siteId: 'site_riverside',
        workerId: 'worker_maria',
        assignedBy: ownerId,
        startTime: tomorrow.add(const Duration(hours: 7, minutes: 30)),
        endTime: tomorrow.add(const Duration(hours: 15, minutes: 30)),
        status: AppConstants.statusPending,
        createdAt: now.subtract(const Duration(hours: 20)),
      ),
    ];
  }

  static List<TimeLogModel> initialTimeLogs() {
    final DateTime now = DateTime.now();
    final DateTime yesterday = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
    return [
      TimeLogModel(
        id: 'timelog_demo_1',
        assignmentId: 'assignment_demo_1',
        workerId: 'worker_john',
        siteId: 'site_downtown',
        type: AppConstants.typeCheckIn,
        timestamp: yesterday.add(const Duration(hours: 7, minutes: 45)),
        serverValidated: true,
      ),
      TimeLogModel(
        id: 'timelog_demo_2',
        assignmentId: 'assignment_demo_1',
        workerId: 'worker_john',
        siteId: 'site_downtown',
        type: AppConstants.typeCheckOut,
        timestamp: yesterday.add(const Duration(hours: 16, minutes: 5)),
        serverValidated: true,
      ),
    ];
  }
}

class _DemoUserRecord {
  const _DemoUserRecord({required this.user, required this.password});

  final UserModel user;

  final String password;
}
