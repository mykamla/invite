import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/media_recorder.dart';
import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart';
import 'package:myliveevent/ui/event/live/appId.dart';

import '../../chat/chatpage.dart';

class Broadcast extends StatefulWidget {

  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  final TextEditingController message = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  AgoraClient agoraClient = AgoraClient(agoraConnectionData: AgoraConnectionData(appId: appId, channelName: channelName), enabledPermission: [Permission.camera, Permission.microphone]);


  @override
  void dispose() {
    super.dispose();
    agoraClient.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoViewer(client: agoraClient),
          AgoraVideoButtons(client: agoraClient,
            autoHideButtons: false,
          )
        ],
      )
    );
  }
}