import 'package:flutter/material.dart';
import 'package:myliveevent/controller/event_%20controller.dart';

//import 'package:agora_rtc_engine/rtc_engine.dart';
//import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
//import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:myliveevent/theme/my_theme.dart';
//import 'package:myliveevent/ui/event/live/appId.dart';
import 'package:myliveevent/ui/event/video/flutter_camera.dart';

class UploadVideo extends StatefulWidget {
  UploadVideo({Key? key, required this.nom, required this.description, this.uidEvent, this.videoList, required this.playlist}) : super(key: key);

  String? nom;
  String? description;
  String? uidEvent;
  List? videoList;
  Map<String, dynamic>? playlist;

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FlutterCamera(
            color: Colors.transparent,
            onVideoRecorded: (value) async {
              final path = value.path;
              (widget.uidEvent == null ||widget.uidEvent == '')
              //first upload
              ? await EventController().addEvent(context: context, nom: widget.nom??'', description: widget.description??'', playlist: widget.playlist??{}, videoPath: path)
              // add only new video in event
              : await EventController().addVideoInEvent(context: context, uidEvent: widget.uidEvent!, videoList: widget.videoList!, videoPath: path);
            },),
        ],
      ),
    );
  }
}
