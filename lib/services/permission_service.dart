import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<PermissionStatus> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidVersion = int.tryParse(Platform.version.split('.').first) ?? 0;
      if (androidVersion >= 13) {
        return requestMediaPermissions();
      } else {
        return await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.request();
    }
    return PermissionStatus.granted;
  }

  static Future<PermissionStatus> requestMediaPermissions() async {
    return await Permission.photos.request();
  }

  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  static Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  static Future<Map<String, PermissionStatus>> getRequiredPermissions() async {
    final perms = <String, PermissionStatus>{};
    
    perms['Storage'] = await Permission.storage.status;
    perms['Photos'] = await Permission.photos.status;
    perms['Camera'] = await Permission.camera.status;
    
    if (Platform.isAndroid) {
      perms['Nearby Devices'] = await Permission.nearbyWifiDevices.status;
    }
    
    return perms;
  }

  static Future<bool> isStoragePermissionGranted() async {
    if (Platform.isAndroid) {
      final androidVersion = int.tryParse(Platform.version.split('.').first) ?? 0;
      if (androidVersion >= 13) {
        return await Permission.photos.isGranted;
      }
    }
    return await Permission.storage.isGranted;
  }

  static Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }
}
