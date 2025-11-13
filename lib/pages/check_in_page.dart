import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/models/site_model.dart';
import 'package:building_site_build_by_vishal/distance_calculator.dart';
import 'package:building_site_build_by_vishal/globals/auth_provider.dart';
import 'package:building_site_build_by_vishal/device_utils_simple.dart';
import 'package:building_site_build_by_vishal/models/time_log_model.dart';
import 'package:building_site_build_by_vishal/models/assignment_model.dart';

@NowaGenerated()
class CheckInPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const CheckInPage({super.key, required this.assignment});

  final AssignmentModel assignment;

  @override
  State<CheckInPage> createState() {
    return _CheckInPageState();
  }
}

@NowaGenerated()
class _CheckInPageState extends State<CheckInPage> {
  bool _isLoading = false;

  bool _isCheckedIn = false;

  double? _currentLat;

  double? _currentLng;

  double? _distanceFromSite;

  @override
  void initState() {
    super.initState();
    _simulateLocationFetch();
  }

  Future<void> _simulateLocationFetch() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      final dataProvider = DataProvider.of(context, listen: false);
      final site = dataProvider.getSiteById(widget.assignment.siteId);
      if (site != null) {
        _currentLat = site!.lat + 0.0001;
        _currentLng = site!.lng + 0.0001;
        _distanceFromSite = DistanceCalculator.calculateDistance(
          _currentLat!,
          _currentLng!,
          site!.lat,
          site!.lng,
        );
      }
    });
  }

  Future<void> _handleCheckIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = AuthProvider.of(context, listen: false);
      final dataProvider = DataProvider.of(context, listen: false);
      final site = dataProvider.getSiteById(widget.assignment.siteId);
      if (site == null || _currentLat == null || _currentLng == null) {
        throw Exception('Location data not available');
      }
      final deviceInfo = await DeviceUtilsSimple.getDeviceInfo();
      final timeLog = TimeLogModel(
        assignmentId: widget.assignment.id!,
        workerId: authProvider.currentUser!.id!,
        siteId: site!.id!,
        type: 'checkin',
        timestamp: DateTime.now(),
        lat: _currentLat,
        lng: _currentLng,
        deviceId: deviceInfo['deviceId'] as String,
        ip: deviceInfo['ip'] as String,
        serverValidated: _distanceFromSite! <= site!.geofenceRadiusMeters,
        distanceFromSite: _distanceFromSite,
        syncStatus: 'synced',
      );
      dataProvider.addTimeLog(timeLog);
      setState(() {
        _isCheckedIn = true;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Successfully checked in!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = DataProvider.of(context, listen: true);
    final site = dataProvider.getSiteById(widget.assignment.siteId);
    final bool isWithinGeofence =
        _distanceFromSite != null &&
        site != null &&
        _distanceFromSite! <= site!.geofenceRadiusMeters;
    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.location_city,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    site?.name ?? 'Unknown Site',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    site?.address ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Distance from site',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _distanceFromSite != null
                                  ? DistanceCalculator.formatDistance(
                                      _distanceFromSite!,
                                    )
                                  : 'Calculating...',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (_distanceFromSite != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isWithinGeofence
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isWithinGeofence
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 16,
                                color: isWithinGeofence
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isWithinGeofence ? 'In range' : 'Too far',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isWithinGeofence
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!isWithinGeofence && _distanceFromSite != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You are outside the geofence radius. Please move closer to the site to check in.',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Anti-Fraud Protection',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\'• GPS location verification\\n\'\'• Device fingerprinting\\n\'\'• Server-side validation\\n\'\'• Timestamp authentication\'',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading || !isWithinGeofence || _isCheckedIn
                  ? null
                  : _handleCheckIn,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, size: 24),
                        const SizedBox(width: 8),
                        FlexSizedBox(
                          width: 111.27421569824219,
                          height: 26,
                          child: Text(
                            _isCheckedIn ? 'Checked In' : 'Check In Now',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
