import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_service.dart';
import './role_provider.dart';

final storagePermissionProvider = FutureProvider((ref) async {
  return await PermissionService.isStoragePermissionGranted();
});

final cameraPermissionProvider = FutureProvider((ref) async {
  return await PermissionService.isCameraPermissionGranted();
});

/// Get required permissions based on transfer role and context
/// context options: 'preparation' (network only), 'selection', 'qr_scan', 'default' (legacy)
final requiredPermissionsProvider = FutureProvider.family<Map<String, PermissionStatus>, String>(
  (ref, context) async {
    final role = ref.watch(transferRoleProvider);
    final isSender = role == TransferRole.sender;
    return await PermissionService.getRequiredPermissions(
      isSender: isSender,
      context: context,
    );
  },
);

/// Legacy provider for backward compatibility - uses 'default' context
final requiredPermissionsProviderLegacy = FutureProvider((ref) async {
  final role = ref.watch(transferRoleProvider);
  final isSender = role == TransferRole.sender;
  return await PermissionService.getRequiredPermissions(isSender: isSender);
});

final requestStoragePermissionProvider = FutureProvider((ref) async {
  return await PermissionService.requestStoragePermission();
});

final requestCameraPermissionProvider = FutureProvider((ref) async {
  return await PermissionService.requestCameraPermission();
});

