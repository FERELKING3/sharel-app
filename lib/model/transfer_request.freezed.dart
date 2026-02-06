// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferRequest {

 String get requestId; String get deviceName; String get deviceId; DateTime get createdAt; String? get description;
/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferRequestCopyWith<TransferRequest> get copyWith => _$TransferRequestCopyWithImpl<TransferRequest>(this as TransferRequest, _$identity);

  /// Serializes this TransferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,deviceName,deviceId,createdAt,description);

@override
String toString() {
  return 'TransferRequest(requestId: $requestId, deviceName: $deviceName, deviceId: $deviceId, createdAt: $createdAt, description: $description)';
}


}

/// @nodoc
abstract mixin class $TransferRequestCopyWith<$Res>  {
  factory $TransferRequestCopyWith(TransferRequest value, $Res Function(TransferRequest) _then) = _$TransferRequestCopyWithImpl;
@useResult
$Res call({
 String requestId, String deviceName, String deviceId, DateTime createdAt, String? description
});




}
/// @nodoc
class _$TransferRequestCopyWithImpl<$Res>
    implements $TransferRequestCopyWith<$Res> {
  _$TransferRequestCopyWithImpl(this._self, this._then);

  final TransferRequest _self;
  final $Res Function(TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? deviceName = null,Object? deviceId = null,Object? createdAt = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferRequest].
extension TransferRequestPatterns on TransferRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransferRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  String deviceName,  String deviceId,  DateTime createdAt,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.requestId,_that.deviceName,_that.deviceId,_that.createdAt,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  String deviceName,  String deviceId,  DateTime createdAt,  String? description)  $default,) {final _that = this;
switch (_that) {
case _TransferRequest():
return $default(_that.requestId,_that.deviceName,_that.deviceId,_that.createdAt,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  String deviceName,  String deviceId,  DateTime createdAt,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.requestId,_that.deviceName,_that.deviceId,_that.createdAt,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferRequest implements TransferRequest {
  const _TransferRequest({required this.requestId, required this.deviceName, required this.deviceId, required this.createdAt, this.description});
  factory _TransferRequest.fromJson(Map<String, dynamic> json) => _$TransferRequestFromJson(json);

@override final  String requestId;
@override final  String deviceName;
@override final  String deviceId;
@override final  DateTime createdAt;
@override final  String? description;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferRequestCopyWith<_TransferRequest> get copyWith => __$TransferRequestCopyWithImpl<_TransferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,deviceName,deviceId,createdAt,description);

@override
String toString() {
  return 'TransferRequest(requestId: $requestId, deviceName: $deviceName, deviceId: $deviceId, createdAt: $createdAt, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TransferRequestCopyWith<$Res> implements $TransferRequestCopyWith<$Res> {
  factory _$TransferRequestCopyWith(_TransferRequest value, $Res Function(_TransferRequest) _then) = __$TransferRequestCopyWithImpl;
@override @useResult
$Res call({
 String requestId, String deviceName, String deviceId, DateTime createdAt, String? description
});




}
/// @nodoc
class __$TransferRequestCopyWithImpl<$Res>
    implements _$TransferRequestCopyWith<$Res> {
  __$TransferRequestCopyWithImpl(this._self, this._then);

  final _TransferRequest _self;
  final $Res Function(_TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? deviceName = null,Object? deviceId = null,Object? createdAt = null,Object? description = freezed,}) {
  return _then(_TransferRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TransferApproval {

 String get requestId; bool get approved; DateTime get respondedAt; bool get rememberDevice;
/// Create a copy of TransferApproval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferApprovalCopyWith<TransferApproval> get copyWith => _$TransferApprovalCopyWithImpl<TransferApproval>(this as TransferApproval, _$identity);

  /// Serializes this TransferApproval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferApproval&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.rememberDevice, rememberDevice) || other.rememberDevice == rememberDevice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,approved,respondedAt,rememberDevice);

@override
String toString() {
  return 'TransferApproval(requestId: $requestId, approved: $approved, respondedAt: $respondedAt, rememberDevice: $rememberDevice)';
}


}

/// @nodoc
abstract mixin class $TransferApprovalCopyWith<$Res>  {
  factory $TransferApprovalCopyWith(TransferApproval value, $Res Function(TransferApproval) _then) = _$TransferApprovalCopyWithImpl;
@useResult
$Res call({
 String requestId, bool approved, DateTime respondedAt, bool rememberDevice
});




}
/// @nodoc
class _$TransferApprovalCopyWithImpl<$Res>
    implements $TransferApprovalCopyWith<$Res> {
  _$TransferApprovalCopyWithImpl(this._self, this._then);

  final TransferApproval _self;
  final $Res Function(TransferApproval) _then;

/// Create a copy of TransferApproval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? approved = null,Object? respondedAt = null,Object? rememberDevice = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,respondedAt: null == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime,rememberDevice: null == rememberDevice ? _self.rememberDevice : rememberDevice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferApproval].
extension TransferApprovalPatterns on TransferApproval {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferApproval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferApproval() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferApproval value)  $default,){
final _that = this;
switch (_that) {
case _TransferApproval():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferApproval value)?  $default,){
final _that = this;
switch (_that) {
case _TransferApproval() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  bool approved,  DateTime respondedAt,  bool rememberDevice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferApproval() when $default != null:
return $default(_that.requestId,_that.approved,_that.respondedAt,_that.rememberDevice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  bool approved,  DateTime respondedAt,  bool rememberDevice)  $default,) {final _that = this;
switch (_that) {
case _TransferApproval():
return $default(_that.requestId,_that.approved,_that.respondedAt,_that.rememberDevice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  bool approved,  DateTime respondedAt,  bool rememberDevice)?  $default,) {final _that = this;
switch (_that) {
case _TransferApproval() when $default != null:
return $default(_that.requestId,_that.approved,_that.respondedAt,_that.rememberDevice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferApproval implements TransferApproval {
  const _TransferApproval({required this.requestId, required this.approved, required this.respondedAt, this.rememberDevice = false});
  factory _TransferApproval.fromJson(Map<String, dynamic> json) => _$TransferApprovalFromJson(json);

@override final  String requestId;
@override final  bool approved;
@override final  DateTime respondedAt;
@override@JsonKey() final  bool rememberDevice;

/// Create a copy of TransferApproval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferApprovalCopyWith<_TransferApproval> get copyWith => __$TransferApprovalCopyWithImpl<_TransferApproval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferApprovalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferApproval&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.rememberDevice, rememberDevice) || other.rememberDevice == rememberDevice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestId,approved,respondedAt,rememberDevice);

@override
String toString() {
  return 'TransferApproval(requestId: $requestId, approved: $approved, respondedAt: $respondedAt, rememberDevice: $rememberDevice)';
}


}

/// @nodoc
abstract mixin class _$TransferApprovalCopyWith<$Res> implements $TransferApprovalCopyWith<$Res> {
  factory _$TransferApprovalCopyWith(_TransferApproval value, $Res Function(_TransferApproval) _then) = __$TransferApprovalCopyWithImpl;
@override @useResult
$Res call({
 String requestId, bool approved, DateTime respondedAt, bool rememberDevice
});




}
/// @nodoc
class __$TransferApprovalCopyWithImpl<$Res>
    implements _$TransferApprovalCopyWith<$Res> {
  __$TransferApprovalCopyWithImpl(this._self, this._then);

  final _TransferApproval _self;
  final $Res Function(_TransferApproval) _then;

/// Create a copy of TransferApproval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? approved = null,Object? respondedAt = null,Object? rememberDevice = null,}) {
  return _then(_TransferApproval(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,respondedAt: null == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime,rememberDevice: null == rememberDevice ? _self.rememberDevice : rememberDevice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TrustedDevice {

 String get deviceId; String get deviceName; String get deviceFingerprint; DateTime get trustedSince; DateTime? get lastUsed;
/// Create a copy of TrustedDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrustedDeviceCopyWith<TrustedDevice> get copyWith => _$TrustedDeviceCopyWithImpl<TrustedDevice>(this as TrustedDevice, _$identity);

  /// Serializes this TrustedDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrustedDevice&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint)&&(identical(other.trustedSince, trustedSince) || other.trustedSince == trustedSince)&&(identical(other.lastUsed, lastUsed) || other.lastUsed == lastUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceName,deviceFingerprint,trustedSince,lastUsed);

@override
String toString() {
  return 'TrustedDevice(deviceId: $deviceId, deviceName: $deviceName, deviceFingerprint: $deviceFingerprint, trustedSince: $trustedSince, lastUsed: $lastUsed)';
}


}

/// @nodoc
abstract mixin class $TrustedDeviceCopyWith<$Res>  {
  factory $TrustedDeviceCopyWith(TrustedDevice value, $Res Function(TrustedDevice) _then) = _$TrustedDeviceCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceName, String deviceFingerprint, DateTime trustedSince, DateTime? lastUsed
});




}
/// @nodoc
class _$TrustedDeviceCopyWithImpl<$Res>
    implements $TrustedDeviceCopyWith<$Res> {
  _$TrustedDeviceCopyWithImpl(this._self, this._then);

  final TrustedDevice _self;
  final $Res Function(TrustedDevice) _then;

/// Create a copy of TrustedDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceName = null,Object? deviceFingerprint = null,Object? trustedSince = null,Object? lastUsed = freezed,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,deviceFingerprint: null == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String,trustedSince: null == trustedSince ? _self.trustedSince : trustedSince // ignore: cast_nullable_to_non_nullable
as DateTime,lastUsed: freezed == lastUsed ? _self.lastUsed : lastUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrustedDevice].
extension TrustedDevicePatterns on TrustedDevice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrustedDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrustedDevice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrustedDevice value)  $default,){
final _that = this;
switch (_that) {
case _TrustedDevice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrustedDevice value)?  $default,){
final _that = this;
switch (_that) {
case _TrustedDevice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String deviceName,  String deviceFingerprint,  DateTime trustedSince,  DateTime? lastUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrustedDevice() when $default != null:
return $default(_that.deviceId,_that.deviceName,_that.deviceFingerprint,_that.trustedSince,_that.lastUsed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String deviceName,  String deviceFingerprint,  DateTime trustedSince,  DateTime? lastUsed)  $default,) {final _that = this;
switch (_that) {
case _TrustedDevice():
return $default(_that.deviceId,_that.deviceName,_that.deviceFingerprint,_that.trustedSince,_that.lastUsed);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String deviceName,  String deviceFingerprint,  DateTime trustedSince,  DateTime? lastUsed)?  $default,) {final _that = this;
switch (_that) {
case _TrustedDevice() when $default != null:
return $default(_that.deviceId,_that.deviceName,_that.deviceFingerprint,_that.trustedSince,_that.lastUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrustedDevice implements TrustedDevice {
  const _TrustedDevice({required this.deviceId, required this.deviceName, required this.deviceFingerprint, required this.trustedSince, this.lastUsed});
  factory _TrustedDevice.fromJson(Map<String, dynamic> json) => _$TrustedDeviceFromJson(json);

@override final  String deviceId;
@override final  String deviceName;
@override final  String deviceFingerprint;
@override final  DateTime trustedSince;
@override final  DateTime? lastUsed;

/// Create a copy of TrustedDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrustedDeviceCopyWith<_TrustedDevice> get copyWith => __$TrustedDeviceCopyWithImpl<_TrustedDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrustedDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrustedDevice&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint)&&(identical(other.trustedSince, trustedSince) || other.trustedSince == trustedSince)&&(identical(other.lastUsed, lastUsed) || other.lastUsed == lastUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceName,deviceFingerprint,trustedSince,lastUsed);

@override
String toString() {
  return 'TrustedDevice(deviceId: $deviceId, deviceName: $deviceName, deviceFingerprint: $deviceFingerprint, trustedSince: $trustedSince, lastUsed: $lastUsed)';
}


}

/// @nodoc
abstract mixin class _$TrustedDeviceCopyWith<$Res> implements $TrustedDeviceCopyWith<$Res> {
  factory _$TrustedDeviceCopyWith(_TrustedDevice value, $Res Function(_TrustedDevice) _then) = __$TrustedDeviceCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String deviceName, String deviceFingerprint, DateTime trustedSince, DateTime? lastUsed
});




}
/// @nodoc
class __$TrustedDeviceCopyWithImpl<$Res>
    implements _$TrustedDeviceCopyWith<$Res> {
  __$TrustedDeviceCopyWithImpl(this._self, this._then);

  final _TrustedDevice _self;
  final $Res Function(_TrustedDevice) _then;

/// Create a copy of TrustedDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceName = null,Object? deviceFingerprint = null,Object? trustedSince = null,Object? lastUsed = freezed,}) {
  return _then(_TrustedDevice(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,deviceFingerprint: null == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String,trustedSince: null == trustedSince ? _self.trustedSince : trustedSince // ignore: cast_nullable_to_non_nullable
as DateTime,lastUsed: freezed == lastUsed ? _self.lastUsed : lastUsed // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
