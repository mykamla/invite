import 'dart:convert';
import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myliveevent/enumeration/msg_type.dart';
import 'package:myliveevent/model/chat.dart';
import 'package:myliveevent/model/event.dart';
import 'package:myliveevent/model/user.dart';
import 'package:myliveevent/provider/chat_state.dart';
import 'package:myliveevent/storage/pref.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatUI extends StatelessWidget {
  ChatUI({this.eventId, super.key});

  int? eventId;

  @override
  Widget build(BuildContext context) => const ChatPage();
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  MyPrefferences pref = MyPrefferences();

  @override
  Widget build(BuildContext context) {

    var chatState = Provider.of<ChatState>(context, listen: false);
    List<Map<String, dynamic>> messages = chatState.messages;

    return Scaffold(
        body: AnimatedList(
          initialItemCount: messages.length,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return BubbleNormal(text: messages[index]['msg'],);
          },)
    );
  }

  void _addMessage(Map<String, dynamic> message) {
    var msg = Provider.of<ChatState>(context, listen: false);
    msg.messages.insert(0, message);
  }

  void _sendMessage(Map<String, dynamic> message) async {
    Map<String, dynamic> user = await pref.getUser();
    Map<String, dynamic> event = await pref.getEvent();
    final textMessage = {
      "id": const Uuid().v4(),
      "msg": message['msg'],
      "type": MsgType.sent,
      "sender": User.fromJson(user),
      "time": DateTime.now(),
      "event": Event.fromJson(event)
    };

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = List<Map<String, dynamic>>.from(jsonDecode(response));
    var msg = Provider.of<ChatState>(context, listen: false);
    msg.messages = messages;
  }
}