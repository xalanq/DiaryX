// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIConfig _$AIConfigFromJson(Map<String, dynamic> json) {
  return _AIConfig.fromJson(json);
}

/// @nodoc
mixin _$AIConfig {
  AIServiceType get serviceType => throw _privateConstructorUsedError;
  String? get ollamaUrl => throw _privateConstructorUsedError;
  String? get ollamaModel => throw _privateConstructorUsedError;
  String? get gemmaModelPath => throw _privateConstructorUsedError;
  bool get enableBackgroundProcessing => throw _privateConstructorUsedError;
  Duration get requestTimeout => throw _privateConstructorUsedError;
  Map<String, dynamic> get additionalParams =>
      throw _privateConstructorUsedError;

  /// Serializes this AIConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIConfigCopyWith<AIConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIConfigCopyWith<$Res> {
  factory $AIConfigCopyWith(AIConfig value, $Res Function(AIConfig) then) =
      _$AIConfigCopyWithImpl<$Res, AIConfig>;
  @useResult
  $Res call({
    AIServiceType serviceType,
    String? ollamaUrl,
    String? ollamaModel,
    String? gemmaModelPath,
    bool enableBackgroundProcessing,
    Duration requestTimeout,
    Map<String, dynamic> additionalParams,
  });
}

/// @nodoc
class _$AIConfigCopyWithImpl<$Res, $Val extends AIConfig>
    implements $AIConfigCopyWith<$Res> {
  _$AIConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceType = null,
    Object? ollamaUrl = freezed,
    Object? ollamaModel = freezed,
    Object? gemmaModelPath = freezed,
    Object? enableBackgroundProcessing = null,
    Object? requestTimeout = null,
    Object? additionalParams = null,
  }) {
    return _then(
      _value.copyWith(
            serviceType: null == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as AIServiceType,
            ollamaUrl: freezed == ollamaUrl
                ? _value.ollamaUrl
                : ollamaUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            ollamaModel: freezed == ollamaModel
                ? _value.ollamaModel
                : ollamaModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            gemmaModelPath: freezed == gemmaModelPath
                ? _value.gemmaModelPath
                : gemmaModelPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            enableBackgroundProcessing: null == enableBackgroundProcessing
                ? _value.enableBackgroundProcessing
                : enableBackgroundProcessing // ignore: cast_nullable_to_non_nullable
                      as bool,
            requestTimeout: null == requestTimeout
                ? _value.requestTimeout
                : requestTimeout // ignore: cast_nullable_to_non_nullable
                      as Duration,
            additionalParams: null == additionalParams
                ? _value.additionalParams
                : additionalParams // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIConfigImplCopyWith<$Res>
    implements $AIConfigCopyWith<$Res> {
  factory _$$AIConfigImplCopyWith(
    _$AIConfigImpl value,
    $Res Function(_$AIConfigImpl) then,
  ) = __$$AIConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AIServiceType serviceType,
    String? ollamaUrl,
    String? ollamaModel,
    String? gemmaModelPath,
    bool enableBackgroundProcessing,
    Duration requestTimeout,
    Map<String, dynamic> additionalParams,
  });
}

/// @nodoc
class __$$AIConfigImplCopyWithImpl<$Res>
    extends _$AIConfigCopyWithImpl<$Res, _$AIConfigImpl>
    implements _$$AIConfigImplCopyWith<$Res> {
  __$$AIConfigImplCopyWithImpl(
    _$AIConfigImpl _value,
    $Res Function(_$AIConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceType = null,
    Object? ollamaUrl = freezed,
    Object? ollamaModel = freezed,
    Object? gemmaModelPath = freezed,
    Object? enableBackgroundProcessing = null,
    Object? requestTimeout = null,
    Object? additionalParams = null,
  }) {
    return _then(
      _$AIConfigImpl(
        serviceType: null == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as AIServiceType,
        ollamaUrl: freezed == ollamaUrl
            ? _value.ollamaUrl
            : ollamaUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        ollamaModel: freezed == ollamaModel
            ? _value.ollamaModel
            : ollamaModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        gemmaModelPath: freezed == gemmaModelPath
            ? _value.gemmaModelPath
            : gemmaModelPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        enableBackgroundProcessing: null == enableBackgroundProcessing
            ? _value.enableBackgroundProcessing
            : enableBackgroundProcessing // ignore: cast_nullable_to_non_nullable
                  as bool,
        requestTimeout: null == requestTimeout
            ? _value.requestTimeout
            : requestTimeout // ignore: cast_nullable_to_non_nullable
                  as Duration,
        additionalParams: null == additionalParams
            ? _value._additionalParams
            : additionalParams // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIConfigImpl implements _AIConfig {
  const _$AIConfigImpl({
    this.serviceType = AIServiceType.mock,
    this.ollamaUrl,
    this.ollamaModel,
    this.gemmaModelPath,
    this.enableBackgroundProcessing = true,
    this.requestTimeout = const Duration(seconds: 30),
    final Map<String, dynamic> additionalParams = const {},
  }) : _additionalParams = additionalParams;

  factory _$AIConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIConfigImplFromJson(json);

  @override
  @JsonKey()
  final AIServiceType serviceType;
  @override
  final String? ollamaUrl;
  @override
  final String? ollamaModel;
  @override
  final String? gemmaModelPath;
  @override
  @JsonKey()
  final bool enableBackgroundProcessing;
  @override
  @JsonKey()
  final Duration requestTimeout;
  final Map<String, dynamic> _additionalParams;
  @override
  @JsonKey()
  Map<String, dynamic> get additionalParams {
    if (_additionalParams is EqualUnmodifiableMapView) return _additionalParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_additionalParams);
  }

  @override
  String toString() {
    return 'AIConfig(serviceType: $serviceType, ollamaUrl: $ollamaUrl, ollamaModel: $ollamaModel, gemmaModelPath: $gemmaModelPath, enableBackgroundProcessing: $enableBackgroundProcessing, requestTimeout: $requestTimeout, additionalParams: $additionalParams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIConfigImpl &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.ollamaUrl, ollamaUrl) ||
                other.ollamaUrl == ollamaUrl) &&
            (identical(other.ollamaModel, ollamaModel) ||
                other.ollamaModel == ollamaModel) &&
            (identical(other.gemmaModelPath, gemmaModelPath) ||
                other.gemmaModelPath == gemmaModelPath) &&
            (identical(
                  other.enableBackgroundProcessing,
                  enableBackgroundProcessing,
                ) ||
                other.enableBackgroundProcessing ==
                    enableBackgroundProcessing) &&
            (identical(other.requestTimeout, requestTimeout) ||
                other.requestTimeout == requestTimeout) &&
            const DeepCollectionEquality().equals(
              other._additionalParams,
              _additionalParams,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    serviceType,
    ollamaUrl,
    ollamaModel,
    gemmaModelPath,
    enableBackgroundProcessing,
    requestTimeout,
    const DeepCollectionEquality().hash(_additionalParams),
  );

  /// Create a copy of AIConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIConfigImplCopyWith<_$AIConfigImpl> get copyWith =>
      __$$AIConfigImplCopyWithImpl<_$AIConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIConfigImplToJson(this);
  }
}

abstract class _AIConfig implements AIConfig {
  const factory _AIConfig({
    final AIServiceType serviceType,
    final String? ollamaUrl,
    final String? ollamaModel,
    final String? gemmaModelPath,
    final bool enableBackgroundProcessing,
    final Duration requestTimeout,
    final Map<String, dynamic> additionalParams,
  }) = _$AIConfigImpl;

  factory _AIConfig.fromJson(Map<String, dynamic> json) =
      _$AIConfigImpl.fromJson;

  @override
  AIServiceType get serviceType;
  @override
  String? get ollamaUrl;
  @override
  String? get ollamaModel;
  @override
  String? get gemmaModelPath;
  @override
  bool get enableBackgroundProcessing;
  @override
  Duration get requestTimeout;
  @override
  Map<String, dynamic> get additionalParams;

  /// Create a copy of AIConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIConfigImplCopyWith<_$AIConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
