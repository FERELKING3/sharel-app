import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Platform-agnostic mDNS service registration wrapper using native APIs
/// - Android: NsdManager (Bonjour/mDNS)
/// - iOS: NetService (Bonjour)
class NativeMdnsService {
  static const platform = MethodChannel('com.sharel.app/mdns');

  /// Publish a service on the local network using native mDNS
  /// Android: uses NsdManager.registerService()
  /// iOS: uses NetService.publish()
  /// 
  /// Returns true if registration succeeded, false otherwise (graceful fallback)
  static Future<bool> publishService({
    required String serviceName,
    required String serviceType, // e.g., '_sharel._tcp'
    required int port,
    Map<String, String>? txtRecords,
  }) async {
    if (!_isSupported) {
      debugPrint('[NativeMdnsService] Platform not supported (requires mobile)');
      return false;
    }

    try {
      debugPrint('[NativeMdnsService] Publishing $serviceType on port $port');
      final result = await platform.invokeMethod<bool>(
        'publishService',
        {
          'serviceName': serviceName,
          'serviceType': serviceType,
          'port': port,
          'txtRecords': txtRecords ?? {},
        },
      );
      debugPrint('[NativeMdnsService] Publish result: $result');
      return result ?? false;
    } catch (e) {
      debugPrint('[NativeMdnsService] Failed to publish: $e');
      return false; // Graceful fallback to UDP
    }
  }

  /// Stop publishing the service
  static Future<void> unpublishService() async {
    if (!_isSupported) return;

    try {
      debugPrint('[NativeMdnsService] Stopping service publication');
      await platform.invokeMethod('unpublishService');
    } catch (e) {
      debugPrint('[NativeMdnsService] Error stopping service: $e');
    }
  }

  static bool get _isSupported =>
      identical(defaultTargetPlatform, TargetPlatform.android) ||
      identical(defaultTargetPlatform, TargetPlatform.iOS);
}
