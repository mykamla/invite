import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/controller/event_%20controller.dart';

//import 'package:agora_rtc_engine/rtc_engine.dart';
//import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
//import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/theme/theme.dart';
//import 'package:myliveevent/ui/event/live/appId.dart';
import 'package:myliveevent/ui/event/video/flutter_camera.dart';
import 'package:myliveevent/widget/loading.dart';

// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';


class ReadVideo extends StatefulWidget {
  ReadVideo({Key? key,
    required this.nomUser,
    required this.email,
    required this.videoLink,
    required this.dateDebut,
    required this.dateFin,
    required this.vueMax,
    required this.nomEvent,
    required this.description,
    required this.organisateur}) : super(key: key);

  String? nomUser;
  String? email;
  String? videoLink;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? vueMax;
  String? nomEvent;
  String? description;
  String? organisateur;


  @override
  State<StatefulWidget> createState() {
    return _ReadVideoState();
  }
}

class _ReadVideoState extends State<ReadVideo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }


  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
/*
  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];
  */

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.videoLink!, videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true));
    _videoPlayerController2 = VideoPlayerController.network(widget.videoLink!, videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true));
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];


    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay: bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      hideControlsTimer: const Duration(seconds: 1),

    );
  }

//  int currPlayIndex = 0;

  /*
  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }
  */
  @override
  Widget build(BuildContext context) {
/*
    final uint8list = await VideoThumbnail.thumbnailFile(
        video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.WEBP,
    maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 75,
    );

    */

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.nomEvent ?? ''),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                    ? Chewie(
                  controller: _chewieController!,
                )
                    : Stack(
                  alignment: Alignment.center,
                  children: [
                    Loading(),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[

              ],
            ),
          ],
        ),
      );
  }
}