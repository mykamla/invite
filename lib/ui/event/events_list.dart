import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/model/event.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/event/map/direction/show_directions.dart';
import 'package:myliveevent/ui/event/map/direction/show_marker.dart';
import 'package:myliveevent/util/functions.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/widget/rotate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:myliveevent/ui/event/map/direction/maps_sheet.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EventsList extends StatefulWidget {
  EventsList({required this.event, Key? key}) : super(key: key);
  Map<String, dynamic>? event;

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList>  with SingleTickerProviderStateMixin{

  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    print('@ok3');
    vt();
    print('@ok4');
    super.initState();
  }

  int selectedTabIndex = 0;
  List? thumbnails = [];
  vt() async {
    print('@ok2');
    (widget.event!['videoLink'] as List).forEach((element) async {
      await VideoThumbnail.thumbnailFile(
        //  video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          video: element,
          thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
      ).then((value) =>

          setState(() {
            thumbnails!.add({'link': element, 'thumbnail': value});
          })



      );
    });
    print('@ok3');
    print(thumbnails!.length);
  }


  Widget wr(List thumbnails, event) {
    print('@ok1');
    return Wrap(
        key: _myListKey,
        spacing: 5,
        runSpacing: 5,
        children: thumbnails.map((item) => FadeAnimation(
      child: Stack(
          alignment: Alignment.center,
          children: [
            Image.file(File(item['thumbnail'])),
            Opacity(opacity: 0.7, child: IconButton(
              color: YellowColor,
              splashRadius: 40,
              iconSize: 40,
              icon: Icon(CupertinoIcons.play_circle_fill),
              onPressed: (){

                Navigator.pushNamed(context, '/read_video', arguments:{
                  "oneVideoLink": item['link'],
                  "videoLink": event['videoLink'],
                  "nomEvent": event['nomEvent'],
                });

              },),)
          ],
        )
    )).toList());
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> event = widget.event!;
  //  print('@@@lop');
  //  print(event);

    var eventState = Provider.of<EventState>(context, listen: false);

    return Scaffold(
      backgroundColor: PrimaryColor,
        floatingActionButton: FloatingActionButton(
          foregroundColor: PinkColor,
          tooltip: 'Ajouter une nouvelle vidéo',
          onPressed: () {
            Navigator.pushNamed(context, '/upload_video' , arguments:{
              "organisateur" : event['organisateur'],
              "uidEvent" : event['uidEvent'],
              "videoList" :event['videoLink']
            });
          },
          child: Icon(Icons.add_circle_outline),
          backgroundColor: PrimaryColor400,
        ),
        appBar: AppBar(
          title: Text(event['nomEvent']),
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, size: 30),
            onPressed: () {
              Navigator.pop(context);
              },
          ),
          actions: [
            /*
            IconButton(
              icon: Icon(CupertinoIcons.music_note_list, size: 30, color: YellowColor,),
              onPressed: (){},),
            */
            IconButton(
              icon: Icon(CupertinoIcons.chat_bubble_text_fill, size: 30, color: YellowColor,),
                onPressed: (){
                  Navigator.pushNamed(context, '/chat_page',
                  arguments: {
                    'uidEvent': widget.event!['uidEvent'],
                    'email' : eventState.email,
                    'nomUser': eventState.nomUser,
                    'nomEvent': event['nomEvent']
                  });
              }
                ,)
          ],
        ),
      body:Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Container(
              height: MediaQuery.of(context).size.height * 1,
              child: SingleChildScrollView(
                  child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex:0,
                    child: Row(
                      children: [
                        ((!(event.containsKey('playlist')) ? '' : (event['playlist']?['images']?[0]??'').toString()).isNotEmpty)
                            ? Expanded(
                            flex: 0,
                            child: GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80.0),
                                child: Rotate(
                                  child: CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill,
                                    imageUrl: event['playlist']?['images']?[0]??'',
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Loading(),
                                    errorWidget: (context, url, error) => SizedBox(),
                                  )
                                )
                              ),
                              onTap: () async {
                                final Uri _url = Uri.parse(event['playlist']['uri']);
                                try{
                                  // Launch the url which will open Spotify
                                  launchUrl(_url);
                                }catch(e){}

                              },
                            )
                        )
                            : SizedBox(),
                        SizedBox(width: 5,),
                        Expanded(
                            child: TextScroll(
                              (!(event.containsKey('playlist')) ? '' : (event['playlist']['name']??'')),
                              mode: TextScrollMode.bouncing,
                              velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                              delayBefore: Duration(milliseconds: 500),
                              numberOfReps: 5,
                              pauseBetween: Duration(milliseconds: 50),
                              style: TextStyle(color: YellowColor),
                              textAlign: TextAlign.left,
                              selectable: true,
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    flex: 0,
                    child: Container(
                      // width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: Text(event['description'], style: TextStyle(color: Colors.white),),
                      decoration: BoxDecoration(
                        color: PrimaryColor200,
                        //  border: Border.all(color: PrimaryColorLight),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),),
                  SizedBox(height: 10,),
                  Expanded(
                      flex: 0,
                      child: Center(child: thumbnails!.length > 0 ? wr(thumbnails!, event) : Loading())
                  )
                ],
              ))
          )
      )
    );
  }

}
enum LaunchMode { marker, directions }