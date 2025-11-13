import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class DeviceUtilsSimple {
  DeviceUtilsSimple._();

  static Future<String> getDeviceId() async {
    return 'device_${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<String> getDeviceIP() async {
    return 'unknown';
  }

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final String deviceId = await getDeviceId();
    final String ip = await getDeviceIP();
    return {
      'deviceId': deviceId,
      'ip': ip,
      'platform': 'mobile',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
