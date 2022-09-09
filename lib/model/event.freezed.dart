// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  int? get id => throw _privateConstructorUsedError;
  String? get nom => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  DateTime? get date_debut => throw _privateConstructorUsedError;
  DateTime? get date_fin => throw _privateConstructorUsedError;
  bool? get live => throw _privateConstructorUsedError;
  int? get vue_max => throw _privateConstructorUsedError;
  int? get vue_en_cours => throw _privateConstructorUsedError;
  String? get longitude => throw _privateConstructorUsedError;
  String? get latitude => throw _privateConstructorUsedError;
  User? get organisateur => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      String? nom,
      String? description,
      String? code,
      DateTime? date_debut,
      DateTime? date_fin,
      bool? live,
      int? vue_max,
      int? vue_en_cours,
      String? longitude,
      String? latitude,
      User? organisateur});

  $UserCopyWith<$Res>? get organisateur;
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  final Event _value;
  // ignore: unused_field
  final $Res Function(Event) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? nom = freezed,
    Object? description = freezed,
    Object? code = freezed,
    Object? date_debut = freezed,
    Object? date_fin = freezed,
    Object? live = freezed,
    Object? vue_max = freezed,
    Object? vue_en_cours = freezed,
    Object? longitude = freezed,
    Object? latitude = freezed,
    Object? organisateur = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      nom: nom == freezed
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      date_debut: date_debut == freezed
          ? _value.date_debut
          : date_debut // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date_fin: date_fin == freezed
          ? _value.date_fin
          : date_fin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      live: live == freezed
          ? _value.live
          : live // ignore: cast_nullable_to_non_nullable
              as bool?,
      vue_max: vue_max == freezed
          ? _value.vue_max
          : vue_max // ignore: cast_nullable_to_non_nullable
              as int?,
      vue_en_cours: vue_en_cours == freezed
          ? _value.vue_en_cours
          : vue_en_cours // ignore: cast_nullable_to_non_nullable
              as int?,
      longitude: longitude == freezed
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: latitude == freezed
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      organisateur: organisateur == freezed
          ? _value.organisateur
          : organisateur // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }

  @override
  $UserCopyWith<$Res>? get organisateur {
    if (_value.organisateur == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.organisateur!, (value) {
      return _then(_value.copyWith(organisateur: value));
    });
  }
}

/// @nodoc
abstract class _$$_EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$_EventCopyWith(_$_Event value, $Res Function(_$_Event) then) =
      __$$_EventCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      String? nom,
      String? description,
      String? code,
      DateTime? date_debut,
      DateTime? date_fin,
      bool? live,
      int? vue_max,
      int? vue_en_cours,
      String? longitude,
      String? latitude,
      User? organisateur});

  @override
  $UserCopyWith<$Res>? get organisateur;
}

/// @nodoc
class __$$_EventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res>
    implements _$$_EventCopyWith<$Res> {
  __$$_EventCopyWithImpl(_$_Event _value, $Res Function(_$_Event) _then)
      : super(_value, (v) => _then(v as _$_Event));

  @override
  _$_Event get _value => super._value as _$_Event;

  @override
  $Res call({
    Object? id = freezed,
    Object? nom = freezed,
    Object? description = freezed,
    Object? code = freezed,
    Object? date_debut = freezed,
    Object? date_fin = freezed,
    Object? live = freezed,
    Object? vue_max = freezed,
    Object? vue_en_cours = freezed,
    Object? longitude = freezed,
    Object? latitude = freezed,
    Object? organisateur = freezed,
  }) {
    return _then(_$_Event(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      nom: nom == freezed
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      date_debut: date_debut == freezed
          ? _value.date_debut
          : date_debut // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      date_fin: date_fin == freezed
          ? _value.date_fin
          : date_fin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      live: live == freezed
          ? _value.live
          : live // ignore: cast_nullable_to_non_nullable
              as bool?,
      vue_max: vue_max == freezed
          ? _value.vue_max
          : vue_max // ignore: cast_nullable_to_non_nullable
              as int?,
      vue_en_cours: vue_en_cours == freezed
          ? _value.vue_en_cours
          : vue_en_cours // ignore: cast_nullable_to_non_nullable
              as int?,
      longitude: longitude == freezed
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: latitude == freezed
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String?,
      organisateur: organisateur == freezed
          ? _value.organisateur
          : organisateur // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Event implements _Event {
  const _$_Event(
      {this.id,
      this.nom,
      this.description,
      this.code,
      this.date_debut,
      this.date_fin,
      this.live,
      this.vue_max,
      this.vue_en_cours,
      this.longitude,
      this.latitude,
      this.organisateur});

  factory _$_Event.fromJson(Map<String, dynamic> json) =>
      _$$_EventFromJson(json);

  @override
  final int? id;
  @override
  final String? nom;
  @override
  final String? description;
  @override
  final String? code;
  @override
  final DateTime? date_debut;
  @override
  final DateTime? date_fin;
  @override
  final bool? live;
  @override
  final int? vue_max;
  @override
  final int? vue_en_cours;
  @override
  final String? longitude;
  @override
  final String? latitude;
  @override
  final User? organisateur;

  @override
  String toString() {
    return 'Event(id: $id, nom: $nom, description: $description, code: $code, date_debut: $date_debut, date_fin: $date_fin, live: $live, vue_max: $vue_max, vue_en_cours: $vue_en_cours, longitude: $longitude, latitude: $latitude, organisateur: $organisateur)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Event &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.nom, nom) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality()
                .equals(other.date_debut, date_debut) &&
            const DeepCollectionEquality().equals(other.date_fin, date_fin) &&
            const DeepCollectionEquality().equals(other.live, live) &&
            const DeepCollectionEquality().equals(other.vue_max, vue_max) &&
            const DeepCollectionEquality()
                .equals(other.vue_en_cours, vue_en_cours) &&
            const DeepCollectionEquality().equals(other.longitude, longitude) &&
            const DeepCollectionEquality().equals(other.latitude, latitude) &&
            const DeepCollectionEquality()
                .equals(other.organisateur, organisateur));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(nom),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(date_debut),
      const DeepCollectionEquality().hash(date_fin),
      const DeepCollectionEquality().hash(live),
      const DeepCollectionEquality().hash(vue_max),
      const DeepCollectionEquality().hash(vue_en_cours),
      const DeepCollectionEquality().hash(longitude),
      const DeepCollectionEquality().hash(latitude),
      const DeepCollectionEquality().hash(organisateur));

  @JsonKey(ignore: true)
  @override
  _$$_EventCopyWith<_$_Event> get copyWith =>
      __$$_EventCopyWithImpl<_$_Event>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {final int? id,
      final String? nom,
      final String? description,
      final String? code,
      final DateTime? date_debut,
      final DateTime? date_fin,
      final bool? live,
      final int? vue_max,
      final int? vue_en_cours,
      final String? longitude,
      final String? latitude,
      final User? organisateur}) = _$_Event;

  factory _Event.fromJson(Map<String, dynamic> json) = _$_Event.fromJson;

  @override
  int? get id;
  @override
  String? get nom;
  @override
  String? get description;
  @override
  String? get code;
  @override
  DateTime? get date_debut;
  @override
  DateTime? get date_fin;
  @override
  bool? get live;
  @override
  int? get vue_max;
  @override
  int? get vue_en_cours;
  @override
  String? get longitude;
  @override
  String? get latitude;
  @override
  User? get organisateur;
  @override
  @JsonKey(ignore: true)
  _$$_EventCopyWith<_$_Event> get copyWith =>
      throw _privateConstructorUsedError;
}
