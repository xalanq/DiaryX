// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_analysis_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AIAnalysisTemplate {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  IconData get icon => throw _privateConstructorUsedError;
  String get prompt => throw _privateConstructorUsedError;
  List<AnalysisTimePeriod> get availableTimePeriods =>
      throw _privateConstructorUsedError;

  /// Create a copy of AIAnalysisTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIAnalysisTemplateCopyWith<AIAnalysisTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIAnalysisTemplateCopyWith<$Res> {
  factory $AIAnalysisTemplateCopyWith(
    AIAnalysisTemplate value,
    $Res Function(AIAnalysisTemplate) then,
  ) = _$AIAnalysisTemplateCopyWithImpl<$Res, AIAnalysisTemplate>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    IconData icon,
    String prompt,
    List<AnalysisTimePeriod> availableTimePeriods,
  });
}

/// @nodoc
class _$AIAnalysisTemplateCopyWithImpl<$Res, $Val extends AIAnalysisTemplate>
    implements $AIAnalysisTemplateCopyWith<$Res> {
  _$AIAnalysisTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIAnalysisTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? prompt = null,
    Object? availableTimePeriods = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as IconData,
            prompt: null == prompt
                ? _value.prompt
                : prompt // ignore: cast_nullable_to_non_nullable
                      as String,
            availableTimePeriods: null == availableTimePeriods
                ? _value.availableTimePeriods
                : availableTimePeriods // ignore: cast_nullable_to_non_nullable
                      as List<AnalysisTimePeriod>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIAnalysisTemplateImplCopyWith<$Res>
    implements $AIAnalysisTemplateCopyWith<$Res> {
  factory _$$AIAnalysisTemplateImplCopyWith(
    _$AIAnalysisTemplateImpl value,
    $Res Function(_$AIAnalysisTemplateImpl) then,
  ) = __$$AIAnalysisTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    IconData icon,
    String prompt,
    List<AnalysisTimePeriod> availableTimePeriods,
  });
}

/// @nodoc
class __$$AIAnalysisTemplateImplCopyWithImpl<$Res>
    extends _$AIAnalysisTemplateCopyWithImpl<$Res, _$AIAnalysisTemplateImpl>
    implements _$$AIAnalysisTemplateImplCopyWith<$Res> {
  __$$AIAnalysisTemplateImplCopyWithImpl(
    _$AIAnalysisTemplateImpl _value,
    $Res Function(_$AIAnalysisTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIAnalysisTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? prompt = null,
    Object? availableTimePeriods = null,
  }) {
    return _then(
      _$AIAnalysisTemplateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as IconData,
        prompt: null == prompt
            ? _value.prompt
            : prompt // ignore: cast_nullable_to_non_nullable
                  as String,
        availableTimePeriods: null == availableTimePeriods
            ? _value._availableTimePeriods
            : availableTimePeriods // ignore: cast_nullable_to_non_nullable
                  as List<AnalysisTimePeriod>,
      ),
    );
  }
}

/// @nodoc

class _$AIAnalysisTemplateImpl implements _AIAnalysisTemplate {
  const _$AIAnalysisTemplateImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.prompt,
    final List<AnalysisTimePeriod> availableTimePeriods = const [
      AnalysisTimePeriod.lastWeek,
      AnalysisTimePeriod.lastMonth,
      AnalysisTimePeriod.lastSixMonths,
      AnalysisTimePeriod.custom,
    ],
  }) : _availableTimePeriods = availableTimePeriods;

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final IconData icon;
  @override
  final String prompt;
  final List<AnalysisTimePeriod> _availableTimePeriods;
  @override
  @JsonKey()
  List<AnalysisTimePeriod> get availableTimePeriods {
    if (_availableTimePeriods is EqualUnmodifiableListView)
      return _availableTimePeriods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTimePeriods);
  }

  @override
  String toString() {
    return 'AIAnalysisTemplate(id: $id, title: $title, description: $description, icon: $icon, prompt: $prompt, availableTimePeriods: $availableTimePeriods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIAnalysisTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality().equals(
              other._availableTimePeriods,
              _availableTimePeriods,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    icon,
    prompt,
    const DeepCollectionEquality().hash(_availableTimePeriods),
  );

  /// Create a copy of AIAnalysisTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIAnalysisTemplateImplCopyWith<_$AIAnalysisTemplateImpl> get copyWith =>
      __$$AIAnalysisTemplateImplCopyWithImpl<_$AIAnalysisTemplateImpl>(
        this,
        _$identity,
      );
}

abstract class _AIAnalysisTemplate implements AIAnalysisTemplate {
  const factory _AIAnalysisTemplate({
    required final String id,
    required final String title,
    required final String description,
    required final IconData icon,
    required final String prompt,
    final List<AnalysisTimePeriod> availableTimePeriods,
  }) = _$AIAnalysisTemplateImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  IconData get icon;
  @override
  String get prompt;
  @override
  List<AnalysisTimePeriod> get availableTimePeriods;

  /// Create a copy of AIAnalysisTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIAnalysisTemplateImplCopyWith<_$AIAnalysisTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
