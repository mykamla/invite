import 'package:flutter/material.dart';
import 'package:myliveevent/controller/event_%20controller.dart';

//import 'package:agora_rtc_engine/rtc_engine.dart';
//import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
//import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:myliveevent/theme/my_theme.dart';
//import 'package:myliveevent/ui/event/live/appId.dart';
import 'package:myliveevent/ui/event/video/flutter_camera.dart';
import 'package:myliveevent/widget/loading.dart';

class SendingVideo extends StatefulWidget {
  SendingVideo({Key? key, required this.nom}) : super(key: key);
  String? nom;

  @override
  _SendingVideoState createState() => _SendingVideoState();
}

class _SendingVideoState extends State<SendingVideo> {

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
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: [
              Loading(iconColor: PrimaryColor300),
              Container(
                child: Text('Envoie de la video', style: TextStyle(color: PrimaryColor),),
              )
            ],
          )

        ],
      ),
    );
  }

}
