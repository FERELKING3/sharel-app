// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferRequest _$TransferRequestFromJson(Map<String, dynamic> json) =>
    _TransferRequest(
      requestId: json['requestId'] as String,
      deviceName: json['deviceName'] as String,
      deviceId: json['deviceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TransferRequestToJson(_TransferRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'deviceName': instance.deviceName,
      'deviceId': instance.deviceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
    };

_TransferApproval _$TransferApprovalFromJson(Map<String, dynamic> json) =>
    _TransferApproval(
      requestId: json['requestId'] as String,
      approved: json['approved'] as bool,
      respondedAt: DateTime.parse(json['respondedAt'] as String),
      rememberDevice: json['rememberDevice'] as bool? ?? false,
    );

Map<String, dynamic> _$TransferApprovalToJson(_TransferApproval instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'approved': instance.approved,
      'respondedAt': instance.respondedAt.toIso8601String(),
      'rememberDevice': instance.rememberDevice,
    };

_TrustedDevice _$TrustedDeviceFromJson(Map<String, dynamic> json) =>
    _TrustedDevice(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      deviceFingerprint: json['deviceFingerprint'] as String,
      trustedSince: DateTime.parse(json['trustedSince'] as String),
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
    );

Map<String, dynamic> _$TrustedDeviceToJson(_TrustedDevice instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'deviceFingerprint': instance.deviceFingerprint,
      'trustedSince': instance.trustedSince.toIso8601String(),
      'lastUsed': instance.lastUsed?.toIso8601String(),
    };
