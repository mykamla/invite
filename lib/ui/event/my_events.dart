import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geo_hash/geohash.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:myliveevent/ui/event/map/direction/maps_sheet.dart';

class MyEvents extends StatefulWidget {
  MyEvents({required this.uid, required this.nomUser, required this.email, required this.photo, Key? key}) : super(key: key);
  String? uid;
  String? nomUser;
  String? email;
  String? photo;

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> with AutomaticKeepAliveClientMixin<MyEvents>{
  final TextEditingController message = new TextEditingController();

  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
  }

  int selectedTabIndex = 0;

  List<Widget> widgets = [ShowMarker(), ShowDirections()];


  Future<Map<String,dynamic>> myPos(context) async {
    Map<String,dynamic> pos = {};
    await AppConstants().myPosition(context).then((value) {

      pos['latitude'] = value['latitude'];
      pos['longitude'] = value['longitude'];
    });
    return pos;

  }

  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _eventStream = FirebaseFirestore.instance
        .collection('events')
        .where('organisateur', isEqualTo: widget.email)
        .orderBy('date_debut', descending: true)
        .snapshots();
    return Scaffold(
        backgroundColor: PrimaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _eventStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("something is wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Loading(),
                );
              }

              return Container(
                  height: MediaQuery.of(context).size.height * 0.79,
                  child: AnimatedList(
                    key: _myListKey,
                    initialItemCount: snapshot.data != null ? snapshot.data!.docs.length : 0,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    reverse: false,
                    itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                      QueryDocumentSnapshot event = snapshot.data!.docs[index];
                      String nomEvent = event['nom'];
                      String description = event['description'];
                      DateTime dateDebut = DateTime.fromMillisecondsSinceEpoch((event['date_debut'] ?? 0).millisecondsSinceEpoch);
                      DateTime dateFin = DateTime.fromMillisecondsSinceEpoch((event['date_fin'] ?? 0).millisecondsSinceEpoch);
                      int vueMax = event['vue_max']??0;
                      List videoLink = event['video_link'];
                      double latitude= event['position']['latitude'];
                      double longitude= event['position']['longitude'];
                      String organisateur = event['organisateur'];


                      return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(nomEvent,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            Text(description, maxLines: 2, softWrap: true, style: TextStyle(color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis),),
                                            Text(Functions().utcToLocal(dateDebut.toString()),
                                              style: TextStyle(fontSize: 12),),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor200,
                                          //  border: Border.all(color: PrimaryColorLight),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0)
                                          ),),
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(0.0),
                                height: MediaQuery.of(context).size.height * 0.1,
                                child: Material(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0),),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/event_list',
                                          arguments: {'event': {
                                            'nomEvent': nomEvent,
                                            'description': description,
                                            'dateDebut': dateDebut,
                                            'vueMax': vueMax,
                                            'videoLink' : videoLink,
                                            'organisateur' : organisateur,
                                            'id': event.id,
                                            'nomUser': widget.nomUser
                                          }
                                          }
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          )

                      );
                    },)
              );

            },
          )
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  
}