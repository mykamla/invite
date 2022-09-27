import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/model/event.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/ui/event/map/direction/show_directions.dart';
import 'package:myliveevent/ui/event/map/direction/show_marker.dart';
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

class _EventsState extends State<Events> {
  final TextEditingController message = new TextEditingController();

  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
  }


  int selectedTabIndex = 0;

  List<Widget> widgets = [ShowMarker(), ShowDirections()];

  final Stream<QuerySnapshot> _eventStream = FirebaseFirestore.instance
      .collection('events')
    //  .where('live', isEqualTo: true)
      .orderBy('date_debut', descending: true)
      .limit(200)
      .snapshots();


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
      body: FutureBuilder(
        future: myPos(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> pos) {

          if(pos.hasData){
            var eventState = Provider.of<EventState>(context, listen: false);
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _eventStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("something is wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.hexagonDots(
                    color: Colors.red,
                    size: 40,
                  ),
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
                      String videoLink = event['video_link'];
                      double latitude= event['position']['latitude'];
                      double longitude= event['position']['longitude'];
                      String organisateur = event['organisateur'];

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
                        dist = 'Calcul...';
                        unit = '';
                      }


                      return ListTile(
                        title: Text(nomEvent),
                        subtitle: Text(description),
                        leading: IconButton(
                            color: Colors.redAccent,
                            iconSize: 20,
                            onPressed: (){
                              Navigator.pushNamed(context, '/read_video' , arguments:{
                                "nomUser" : widget.nomUser,
                                "email" : widget.email,
                                "videoLink": videoLink,
                                "dateDebut": dateDebut,
                                "dateFin": dateFin,
                                "vueMax": vueMax,
                                "nomEvent" : nomEvent,
                                "description" : description,
                                "organisateur" : organisateur,
                              });
                            },
                            icon: Icon(Icons.live_tv_outlined)),
                        trailing: SizedBox(
                            height: 25,
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red, width: .1)
                                        )
                                    )

                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on_outlined, color: Colors.redAccent, size: 15,),
                                    Text('${dist} ${unit}', style: TextStyle(fontSize: 10, color: Colors.redAccent),),
                                  ],
                                ),
                                onPressed: () async {
                                  if(dist!.length != null || dist.length != 0){
                                    MapsSheet.show(
                                      context: context,
                                      onMapTap: (map) {
                                        map.showDirections(
                                            destination: Coords(
                                              latitude,
                                              longitude,
                                            ),
                                            // destinationTitle: destinationTitle,
                                            origin: Coords(pos.data['latitude'], pos.data['longitude']),
                                            originTitle: 'Ma position',
                                            //  waypoints: waypoints,
                                            directionsMode: DirectionsMode.driving
                                        );
                                      },
                                    );
                                  }
                                },),
                            )
                        ),

                        onTap: (){},

                      );
                    },)
              );

            },
          );
        },

      )
    );
  }



}
enum LaunchMode { marker, directions }