// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Event _$$_EventFromJson(Map<String, dynamic> json) => _$_Event(
      id: json['id'] as int?,
      nom: json['nom'] as String?,
      description: json['description'] as String?,
      channel: json['channel'] as String?,
      date_debut: json['date_debut'] == null
          ? null
          : DateTime.parse(json['date_debut'] as String),
      date_fin: json['date_fin'] == null
          ? null
          : DateTime.parse(json['date_fin'] as String),
      live: json['live'] as bool?,
      vue_max: json['vue_max'] as int?,
      vue_en_cours: json['vue_en_cours'] as int?,
      position: json['position'] as Map<String, dynamic>?,
      organisateur: json['organisateur'] as String?,
    );

Map<String, dynamic> _$$_EventToJson(_$_Event instance) => <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'description': instance.description,
      'channel': instance.channel,
      'date_debut': instance.date_debut?.toIso8601String(),
      'date_fin': instance.date_fin?.toIso8601String(),
      'live': instance.live,
      'vue_max': instance.vue_max,
      'vue_en_cours': instance.vue_en_cours,
      'position': instance.position,
      'organisateur': instance.organisateur,
    };
