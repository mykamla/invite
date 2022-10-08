import 'dart:async';

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
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:myliveevent/ui/event/map/direction/maps_sheet.dart';

class Events extends StatefulWidget {
  Events({required this.uid, required this.nomUser, required this.email, required this.photo, Key? key}) : super(key: key);
  String? uid;
  String? nomUser;
  String? email;
  String? photo;

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with  AutomaticKeepAliveClientMixin<Events> {
  final TextEditingController message = new TextEditingController();

  final _myListKey = GlobalKey<AnimatedListState>();

  Stream<QuerySnapshot>? _eventStream;

  @override
  void initState() {
    _eventStream = FirebaseFirestore.instance
        .collection('events')
    //  .where('live', isEqualTo: true)
        .orderBy('date_debut', descending: true)
        .limit(200)
        .snapshots();
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
/*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Launcher Demo'),
        ),
        body: widgets[selectedTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTabIndex,
          onTap: (newTabIndex) => setState(() {
            selectedTabIndex = newTabIndex;
          }),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop),
              label: 'Marker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions),
              label: 'Directions',
            ),
          ],
        ),
      ),
    );
  }
*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: FutureBuilder(
          future: myPos(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> pos) {

            return StreamBuilder<QuerySnapshot>(
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
                        Map<String, dynamic> playlist = event['playlist'] ?? {};
                        String uidEvent = event.id;

                        final startCoordinate;
                        if(pos.hasData) {
                          startCoordinate = Location(pos.data['latitude'], pos.data['longitude']);
                        }else {
                          startCoordinate = Location(0, 0);
                        }

                        final endCoordinate = Location(latitude, longitude);

                        /// Create a new haversine object
                        final haversineDistance = HaversineDistance();

                        /// Then calculate the distance between the two location objects and set a unit.
                        /// You can select between KM/MILES/METERS/NMI
                        String? dist;
                        String? unit;
                        if(pos.hasData) {
                          dist = haversineDistance.haversine(
                              startCoordinate, endCoordinate, Unit.METER)
                              .floor()
                              .toString();
                          unit = 'm';
                          if(dist.length >= 4) {
                            dist = haversineDistance.haversine(
                              startCoordinate, endCoordinate, Unit.KM)
                              .floor()
                              .toString();
                            unit = 'KM';
                          }
                        }else {
                          dist = '...';
                          unit = '';
                        }

                        var eventState = Provider.of<EventState>(context, listen: false);

                        WidgetsBinding.instance.addPostFrameCallback((_){
                          eventState.dist = dist??'';
                          eventState.unit = unit??'';
                        });

                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
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
                                            Text(description, maxLines: 2, softWrap: true, style: TextStyle(color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis),)
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor200,
                                          //  border: Border.all(color: PrimaryColorLight),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),
                                          ),),
                                      )
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 3),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Icon(CupertinoIcons.map_pin, color: PinkColor, size: 20,),
                                                        dist != '...'
                                                            ? Text('${dist} ${unit}', style: TextStyle(fontSize: 20, color: PinkColor),)
                                                            : LoadingAnimationWidget.waveDots(
                                                          color: PinkColor,
                                                          size: 30,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex:0,
                                              child: Text(Functions().utcToLocal(dateDebut.toString()),
                                                style: TextStyle(fontSize: 10),),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: YellowColor,
                                          //  border: Border.all(color: PrimaryColorLight),
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(8.0),
                                          ),),

                                      )
                                  )
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
                                            'uidEvent': uidEvent,
                                            'description': description,
                                            'dateDebut': dateDebut,
                                            'vueMax': vueMax,
                                            'videoLink' : videoLink,
                                            'organisateur' : organisateur,
                                            'playlist': playlist,
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
            );
          },
        ),
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

}