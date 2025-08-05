// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LLMServiceConfig _$LLMServiceConfigFromJson(Map<String, dynamic> json) {
  return _LLMServiceConfig.fromJson(json);
}

/// @nodoc
mixin _$LLMServiceConfig {
  String get baseUrl => throw _privateConstructorUsedError;
  String get modelName => throw _privateConstructorUsedError;
  String? get apiKey => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;
  Duration get timeout => throw _privateConstructorUsedError;

  /// Serializes this LLMServiceConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LLMServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LLMServiceConfigCopyWith<LLMServiceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LLMServiceConfigCopyWith<$Res> {
  factory $LLMServiceConfigCopyWith(
    LLMServiceConfig value,
    $Res Function(LLMServiceConfig) then,
  ) = _$LLMServiceConfigCopyWithImpl<$Res, LLMServiceConfig>;
  @useResult
  $Res call({
    String baseUrl,
    String modelName,
    String? apiKey,
    Map<String, dynamic> parameters,
    Duration timeout,
  });
}

/// @nodoc
class _$LLMServiceConfigCopyWithImpl<$Res, $Val extends LLMServiceConfig>
    implements $LLMServiceConfigCopyWith<$Res> {
  _$LLMServiceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LLMServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? modelName = null,
    Object? apiKey = freezed,
    Object? parameters = null,
    Object? timeout = null,
  }) {
    return _then(
      _value.copyWith(
            baseUrl: null == baseUrl
                ? _value.baseUrl
                : baseUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            modelName: null == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                      as String,
            apiKey: freezed == apiKey
                ? _value.apiKey
                : apiKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            parameters: null == parameters
                ? _value.parameters
                : parameters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            timeout: null == timeout
                ? _value.timeout
                : timeout // ignore: cast_nullable_to_non_nullable
                      as Duration,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LLMServiceConfigImplCopyWith<$Res>
    implements $LLMServiceConfigCopyWith<$Res> {
  factory _$$LLMServiceConfigImplCopyWith(
    _$LLMServiceConfigImpl value,
    $Res Function(_$LLMServiceConfigImpl) then,
  ) = __$$LLMServiceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String baseUrl,
    String modelName,
    String? apiKey,
    Map<String, dynamic> parameters,
    Duration timeout,
  });
}

/// @nodoc
class __$$LLMServiceConfigImplCopyWithImpl<$Res>
    extends _$LLMServiceConfigCopyWithImpl<$Res, _$LLMServiceConfigImpl>
    implements _$$LLMServiceConfigImplCopyWith<$Res> {
  __$$LLMServiceConfigImplCopyWithImpl(
    _$LLMServiceConfigImpl _value,
    $Res Function(_$LLMServiceConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LLMServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? modelName = null,
    Object? apiKey = freezed,
    Object? parameters = null,
    Object? timeout = null,
  }) {
    return _then(
      _$LLMServiceConfigImpl(
        baseUrl: null == baseUrl
            ? _value.baseUrl
            : baseUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        modelName: null == modelName
            ? _value.modelName
            : modelName // ignore: cast_nullable_to_non_nullable
                  as String,
        apiKey: freezed == apiKey
            ? _value.apiKey
            : apiKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        parameters: null == parameters
            ? _value._parameters
            : parameters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        timeout: null == timeout
            ? _value.timeout
            : timeout // ignore: cast_nullable_to_non_nullable
                  as Duration,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LLMServiceConfigImpl implements _LLMServiceConfig {
  const _$LLMServiceConfigImpl({
    required this.baseUrl,
    required this.modelName,
    this.apiKey,
    final Map<String, dynamic> parameters = const {},
    this.timeout = const Duration(seconds: 30),
  }) : _parameters = parameters;

  factory _$LLMServiceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LLMServiceConfigImplFromJson(json);

  @override
  final String baseUrl;
  @override
  final String modelName;
  @override
  final String? apiKey;
  final Map<String, dynamic> _parameters;
  @override
  @JsonKey()
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  @JsonKey()
  final Duration timeout;

  @override
  String toString() {
    return 'LLMServiceConfig(baseUrl: $baseUrl, modelName: $modelName, apiKey: $apiKey, parameters: $parameters, timeout: $timeout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LLMServiceConfigImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            const DeepCollectionEquality().equals(
              other._parameters,
              _parameters,
            ) &&
            (identical(other.timeout, timeout) || other.timeout == timeout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    baseUrl,
    modelName,
    apiKey,
    const DeepCollectionEquality().hash(_parameters),
    timeout,
  );

  /// Create a copy of LLMServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LLMServiceConfigImplCopyWith<_$LLMServiceConfigImpl> get copyWith =>
      __$$LLMServiceConfigImplCopyWithImpl<_$LLMServiceConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LLMServiceConfigImplToJson(this);
  }
}

abstract class _LLMServiceConfig implements LLMServiceConfig {
  const factory _LLMServiceConfig({
    required final String baseUrl,
    required final String modelName,
    final String? apiKey,
    final Map<String, dynamic> parameters,
    final Duration timeout,
  }) = _$LLMServiceConfigImpl;

  factory _LLMServiceConfig.fromJson(Map<String, dynamic> json) =
      _$LLMServiceConfigImpl.fromJson;

  @override
  String get baseUrl;
  @override
  String get modelName;
  @override
  String? get apiKey;
  @override
  Map<String, dynamic> get parameters;
  @override
  Duration get timeout;

  /// Create a copy of LLMServiceConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LLMServiceConfigImplCopyWith<_$LLMServiceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
