import 'package:nowa_runtime/nowa_runtime.dart';
import 'dart:math';

@NowaGenerated()
class DistanceCalculator {
  DistanceCalculator._();

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000;
    final double lat1Rad = lat1 * pi / 180;
    final double lat2Rad = lat2 * pi / 180;
    final double lon1Rad = lon1 * pi / 180;
    final double lon2Rad = lon2 * pi / 180;
    final double x = (lon2Rad - lon1Rad) * cos((lat1Rad + lat2Rad) / 2);
    final double y = lat2Rad - lat1Rad;
    final double distance = sqrt(x * x + y * y) * earthRadius;
    return distance;
  }

  static bool isWithinGeofence({
    required double userLat,
    required double userLon,
    required double siteLat,
    required double siteLon,
    required double radiusMeters,
  }) {
    final double distance = calculateDistance(
      userLat,
      userLon,
      siteLat,
      siteLon,
    );
    return distance <= radiusMeters;
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }
}
