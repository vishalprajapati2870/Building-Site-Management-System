import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class AppConstants {
  AppConstants._();

  static const String usersCollection = 'users';

  static const String sitesCollection = 'sites';

  static const String assignmentsCollection = 'assignments';

  static const String timeLogsCollection = 'timeLogs';

  static const String availabilitiesCollection = 'availabilities';

  static const String leavesCollection = 'leaves';

  static const String reportsCollection = 'reports';

  static const String roleOwner = 'owner';

  static const String roleWorker = 'worker';

  static const String statusPending = 'pending';

  static const String statusConfirmed = 'confirmed';

  static const String statusCompleted = 'completed';

  static const String statusCancelled = 'cancelled';

  static const String typeCheckIn = 'checkin';

  static const String typeCheckOut = 'checkout';

  static const String syncStatusSynced = 'synced';

  static const String syncStatusPending = 'pending';

  static const String syncStatusFailed = 'failed';

  static const double defaultGeofenceRadiusMeters = 100;

  static const int qrTokenRotationMinutes = 60;

  static const String offlineActionsBox = 'offline_actions';

  static const String cacheBox = 'cache';
}
