import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to convert Firestore data to JSON
  Map<String, dynamic> _convertFirestoreData(Map<String, dynamic> data) {
    final converted = <String, dynamic>{};
    for (var entry in data.entries) {
      if (entry.value is Timestamp) {
        converted[entry.key] = (entry.value as Timestamp).toDate().toIso8601String();
      } else {
        converted[entry.key] = entry.value;
      }
    }
    return converted;
  }

  // Sites
  Stream<List<SiteModel>> getSitesStream(String ownerId) {
    return _firestore
        .collection('sites')
        .where('ownerId', isEqualTo: ownerId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SiteModel.fromJson({
                  'id': doc.id,
                  ..._convertFirestoreData(doc.data()),
                }))
            .toList());
  }

  Future<List<SiteModel>> getSites(String ownerId) async {
    final snapshot = await _firestore
        .collection('sites')
        .where('ownerId', isEqualTo: ownerId)
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => SiteModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList();
  }

  Future<void> addSite(SiteModel site) async {
    final docRef = _firestore.collection('sites').doc();
    final data = site.toJson();
    data.remove('id'); // Remove id from data as it's the document ID
    if (data['createdAt'] != null) {
      data['createdAt'] = Timestamp.fromDate(DateTime.parse(data['createdAt']));
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await docRef.set(data);
  }

  Future<void> updateSite(SiteModel site) async {
    if (site.id == null) return;
    final data = site.toJson();
    data.remove('id');
    if (data['createdAt'] != null) {
      data['createdAt'] = Timestamp.fromDate(DateTime.parse(data['createdAt']));
    }
    await _firestore.collection('sites').doc(site.id).update(data);
  }

  // Assignments
  Stream<List<AssignmentModel>> getAssignmentsStream(String? siteId) {
    Query query = _firestore.collection('assignments');
    if (siteId != null) {
      query = query.where('siteId', isEqualTo: siteId);
    }
    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => AssignmentModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList());
  }

  Future<List<AssignmentModel>> getAssignments(String? siteId) async {
    Query query = _firestore.collection('assignments');
    if (siteId != null) {
      query = query.where('siteId', isEqualTo: siteId);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AssignmentModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList();
  }

  Future<List<AssignmentModel>> getWorkerAssignments(String workerId) async {
    final snapshot = await _firestore
        .collection('assignments')
        .where('workerId', isEqualTo: workerId)
        .get();
    return snapshot.docs
        .map((doc) => AssignmentModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList();
  }

  Future<List<AssignmentModel>> getTodayAssignments(String workerId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('assignments')
        .where('workerId', isEqualTo: workerId)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('startTime', isLessThan: Timestamp.fromDate(tomorrow))
        .get();

    return snapshot.docs
        .map((doc) => AssignmentModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList();
  }

  Future<bool> isWorkerAlreadyAssigned(
      String siteId, String workerId, DateTime startTime, DateTime endTime) async {
    final snapshot = await _firestore
        .collection('assignments')
        .where('siteId', isEqualTo: siteId)
        .where('workerId', isEqualTo: workerId)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    for (var doc in snapshot.docs) {
      final assignment = AssignmentModel.fromJson({
        'id': doc.id,
        ..._convertFirestoreData(doc.data()),
      });

      // Check for time overlap
      if ((startTime.isBefore(assignment.endTime) &&
              endTime.isAfter(assignment.startTime)) ||
          (startTime.isAtSameMomentAs(assignment.startTime) ||
              endTime.isAtSameMomentAs(assignment.endTime))) {
        return true;
      }
    }
    return false;
  }

  Future<void> addAssignment(AssignmentModel assignment) async {
    final docRef = _firestore.collection('assignments').doc();
    final data = assignment.toJson();
    data.remove('id');
    // Convert DateTime strings to Timestamps
    if (data['startTime'] != null) {
      data['startTime'] = Timestamp.fromDate(DateTime.parse(data['startTime']));
    }
    if (data['endTime'] != null) {
      data['endTime'] = Timestamp.fromDate(DateTime.parse(data['endTime']));
    }
    if (data['createdAt'] != null) {
      data['createdAt'] = Timestamp.fromDate(DateTime.parse(data['createdAt']));
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await docRef.set(data);
  }

  Future<void> updateAssignment(AssignmentModel assignment) async {
    if (assignment.id == null) return;
    final data = assignment.toJson();
    data.remove('id');
    // Convert DateTime strings to Timestamps
    if (data['startTime'] != null) {
      data['startTime'] = Timestamp.fromDate(DateTime.parse(data['startTime']));
    }
    if (data['endTime'] != null) {
      data['endTime'] = Timestamp.fromDate(DateTime.parse(data['endTime']));
    }
    await _firestore.collection('assignments').doc(assignment.id).update(data);
  }

  // Time Logs
  Stream<List<TimeLogModel>> getTimeLogsStream(String? siteId, DateTime? startDate,
      DateTime? endDate) {
    Query query = _firestore.collection('timeLogs');
    if (siteId != null) {
      query = query.where('siteId', isEqualTo: siteId);
    }
    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }
    return query.orderBy('timestamp', descending: true).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => TimeLogModel.fromJson({
                  'id': doc.id,
                  ..._convertFirestoreData(doc.data()),
                }))
            .toList());
  }

  Future<List<TimeLogModel>> getTimeLogs(
      String? siteId, DateTime? startDate, DateTime? endDate) async {
    Query query = _firestore.collection('timeLogs');
    if (siteId != null) {
      query = query.where('siteId', isEqualTo: siteId);
    }
    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }
    final snapshot = await query.orderBy('timestamp', descending: true).get();
    return snapshot.docs
        .map((doc) => TimeLogModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList();
  }

  Future<void> addTimeLog(TimeLogModel timeLog) async {
    final docRef = _firestore.collection('timeLogs').doc();
    final data = timeLog.toJson();
    data.remove('id');
    // Convert DateTime strings to Timestamps
    if (data['timestamp'] != null) {
      data['timestamp'] = Timestamp.fromDate(DateTime.parse(data['timestamp']));
    }
    await docRef.set(data);
  }

  // Users/Workers
  Stream<List<UserModel>> getWorkersStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'worker')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromJson({
                  'id': doc.id,
                  ..._convertFirestoreData(doc.data()),
            }))
            .toList());
  }

  Future<List<UserModel>> getWorkers() async {
    final snapshot =
        await _firestore.collection('users').where('role', isEqualTo: 'worker').get();
    return snapshot.docs
        .map((doc) => UserModel.fromJson({
              'id': doc.id,
              ..._convertFirestoreData(doc.data()),
            }))
        .toList();
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson({
      'id': doc.id,
      ..._convertFirestoreData(doc.data()!),
    });
  }

  Future<void> addUser(UserModel user) async {
    if (user.id == null) return;
    final data = user.toJson();
    data.remove('id');
    if (data['createdAt'] != null) {
      data['createdAt'] = Timestamp.fromDate(DateTime.parse(data['createdAt']));
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await _firestore.collection('users').doc(user.id).set(data);
  }

  Future<void> updateUser(UserModel user) async {
    if (user.id == null) return;
    final data = user.toJson();
    data.remove('id');
    if (data['createdAt'] != null) {
      data['createdAt'] = Timestamp.fromDate(DateTime.parse(data['createdAt']));
    }
    await _firestore.collection('users').doc(user.id).update(data);
  }

  // Get checked-in count for a site
  Future<int> getCheckedInCount(String siteId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('timeLogs')
        .where('siteId', isEqualTo: siteId)
        .where('type', isEqualTo: 'checkin')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('timestamp', isLessThan: Timestamp.fromDate(tomorrow))
        .get();

    final checkedInWorkers = <String>{};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data['workerId'] != null) {
        checkedInWorkers.add(data['workerId'] as String);
      }
    }
    return checkedInWorkers.length;
  }
}

