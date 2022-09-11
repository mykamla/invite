import 'package:agora_rtm/agora_rtm.dart';
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

class Live extends StatefulWidget {
  Live({required this.channelName, this.uid});
  String? channelName;
  final int? uid; // it isn't uid from Firebase auth

  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  final TextEditingController message = new TextEditingController();

  @override
  void initState() {
    super.initState();
    initalizeAgora();
  }


  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  List<int> _users = [];
  Future<void> initalizeAgora() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
   // _engine.joinChannel(null, 'test', optionalInfo, optionalUid)
    _client  = await AgoraRtmClient.createInstance(appId);

    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    //Callback for the RTC Engine
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: ((channel, uid, elapsed) =>
          setState((){
            _users.add(uid);
          })
      )
    ));

    //Callback for the RTC Client
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Private message from" + peerId+": " + (message.text));
      };

    _client?.onConnectionStateChanged = (int state, int reason) {
      print("Connection state changed" + state.toString() +" reason " + reason.toString());
    if(state == 5){
      _channel?.leave();
      _client?.logout();
      _client?.destroy();
      print("Lougout");
    }
    };

    //Join the  RTM and RTC channels
    await _client?.login(null, widget.uid.toString());
    _channel = await _client?.createChannel(widget.channelName!);
    await _channel?.join();
    await _engine.joinChannel(null, widget.channelName!, null, widget.uid!);

    //Callback for Rtm channel
    _channel?.onMemberJoined = (AgoraRtmMember member) {
      print("Member joined: " + member.userId +", channel " + member.channelId);
    };

    _channel?.onMemberLeft = (AgoraRtmMember member) {
      print("Member left: " + member.userId +", channel " + member.channelId);
    };

    _channel?.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
      //todo implement this
      print("Public message from: " + member.userId +": " + (message.text));
    };

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: AssetImage(
              "assets/bart.jpg",
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            child: ChatPage(email: "email@email.com", codeEvent: 'event code',),
          )
        ],
      )
    );
  }
}