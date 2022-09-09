// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chat _$$_ChatFromJson(Map<String, dynamic> json) => _$_Chat(
      id: json['id'] as String?,
      msg: json['msg'] as String?,
      type: $enumDecodeNullable(_$MsgTypeEnumMap, json['type']),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      sender: json['sender'] == null
          ? null
          : User.fromJson(json['sender'] as Map<String, dynamic>),
      event: json['event'] == null
          ? null
          : Event.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ChatToJson(_$_Chat instance) => <String, dynamic>{
      'id': instance.id,
      'msg': instance.msg,
      'type': _$MsgTypeEnumMap[instance.type],
      'time': instance.time?.toIso8601String(),
      'sender': instance.sender,
      'event': instance.event,
    };

const _$MsgTypeEnumMap = {
  MsgType.sent: 'sent',
  MsgType.receive: 'receive',
  MsgType.timetag: 'timetag',
};
