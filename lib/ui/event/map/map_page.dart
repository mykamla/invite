import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/widget/rotate.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  MapPage({required this.uid, required this.nomUser, required this.email, required this.photo, Key? key}) : super(key: key);
  String? uid;
  String? nomUser;
  String? email;
  String? photo;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MapPage> {
  final pageController = PageController();
  int selectedIndex = 0;

  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  var currentLocation;


  final Stream<QuerySnapshot> _eventStream = FirebaseFirestore.instance
      .collection('events')
      .orderBy('date_debut', descending: true)
      .limit(1000)
      .snapshots();


  @override
  Widget build(BuildContext context) {
    AppConstants().myPosition(context);
    var eventState = Provider.of<EventState>(context, listen: false);
    var currentLocation =  LatLng(eventState.latitude, eventState.longitude);
    return Scaffold(
      backgroundColor: PrimaryColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("something is wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loading()
            );
          }

          var event = snapshot.data!.docs;
          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  minZoom: 5,
                  maxZoom: 200,
                  zoom: 15,
              //    center: currentLocation,
                  center: LatLng(event[0]['position']['latitude'], event[0]['position']['longitude']),
                ),
                layers: [
                  TileLayerOptions(
                    backgroundColor: PrimaryColor,
                    urlTemplate:
                    "https://api.mapbox.com/styles/v1/kamla/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                    additionalOptions: {
                      'mapStyleId': AppConstants.mapBoxStyleId,
                      'accessToken': AppConstants.mapBoxAccessToken,
                    },
                  ),
                  MarkerLayerOptions(
                    markers: [
                 //     for (int i = 0; i < mapMarkers.length; i++)
                      for (int i = 0; i < event.length; i++)
                        Marker(
                          height: 40,
                          width: 40,
                     //     point: mapMarkers[i].location ?? AppConstants.myLocation,
                          point: LatLng(event[i]['position']['latitude'], event[i]['position']['longitude']),
                          builder: (_) {
                            return GestureDetector(
                              onTap: () {
                                pageController.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                selectedIndex = i;
                            //    currentLocation = mapMarkers[i].location ?? AppConstants.myLocation;
                                currentLocation = LatLng(event[i]['position']['latitude'], event[i]['position']['longitude']);
                                _animatedMapMove(currentLocation, 11.5);
                                setState(() {});
                              },
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 500),
                                scale: selectedIndex == i ? 0.5 : 0.4,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: selectedIndex == i ? 1 : 1,
                                  child: SvgPicture.asset(
                                    selectedIndex == i ? 'assets/svg/yellow_map_marker.svg' : 'assets/svg/pink_point_marker.svg',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 2,
                height: MediaQuery.of(context).size.height * 0.25,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) {
                    selectedIndex = value;
                   // currentLocation = mapMarkers[value].location ?? AppConstants.myLocation;
                    currentLocation = LatLng(event[value]['position']['latitude'], event[value]['position']['longitude']);
                    _animatedMapMove(currentLocation, 11.5);
                    setState(() {});
                  },
                //  itemCount: mapMarkers.length,
                  itemCount: event.length,
                  itemBuilder: (_, index) {
               //     final item = mapMarkers[index];
                    final item = event[index];
                    String uidEvent = item.id;
                    Map<String, dynamic> playlist = !((item.data() as Map).containsKey('playlist')) ? {} : item['playlist']??{};
                    String playlistName = !((item.data() as Map).containsKey('playlist')) ? '' : item['playlist']?['name']??'';
                    String playlistFirstImageUrl = !((item.data() as Map).containsKey('playlist')) ? '' : (item['playlist']?['images']?[0]??'').toString();
                    String playlistUri = !((item.data() as Map).containsKey('playlist')) ? '' : item['playlist']?['uri']??'';
                    String nomEvent = item['nom']??'';
                    String eventDescription = item['description']??'';

                    print('@@lon');
                    print(playlistFirstImageUrl);
                    print(playlistFirstImageUrl.runtimeType);
                    print(playlistUri);

                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: PrimaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 0,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              onPressed: (){
                                                Navigator.pushNamed(context, '/chat_page',
                                                    arguments: {
                                                      'uidEvent': uidEvent,
                                                      'email' : eventState.email,
                                                      'nomUser': eventState.nomUser,
                                                      'nomEvent': nomEvent
                                                    });
                                              },
                                              icon: Icon(CupertinoIcons.chat_bubble_text_fill, color: YellowColor,)),

                                          ((playlistFirstImageUrl.isNotEmpty)
                                              ? Expanded(
                                              flex: 0,
                                              child: GestureDetector(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(80.0),
                                                  child: Rotate(
                                                    child: CachedNetworkImage(
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.fill,
                                                      imageUrl: playlistFirstImageUrl,
                                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                          Loading(),
                                                      errorWidget: (context, url, error) => SizedBox(),
                                                    ),
                                                  ),
                                                ),
                                                onLongPress: () async {
                                                  final Uri _url = Uri.parse(playlistUri);
                                                  try{
                                                    // Launch the url which will open Spotify
                                                    launchUrl(_url);
                                                  }catch(e){}

                                                },
                                              )
                                          )
                                              : SizedBox()
                                          ),
                                          SizedBox(width: 5,),
                                          Expanded(
                                            child: TextScroll(
                                              playlistName,
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
                                      )
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            nomEvent,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: YellowColor
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                              eventDescription,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: PinkColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: IconButton(
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/event_list',
                                          arguments: {'event': {
                                            'nomEvent': nomEvent,
                                            'uidEvent': uidEvent,
                                            'description': item['description']?? '',
                                            'dateDebut': DateTime.fromMillisecondsSinceEpoch((item['date_debut'] ?? 0).millisecondsSinceEpoch),
                                            'vueMax': item['vue_max'],
                                            'videoLink' : item['video_link'],
                                            'organisateur' : item['organisateur']?? '',
                                            'playlist': playlist,
                                            'nomUser': widget.nomUser
                                          }
                                          }
                                      );


                                    },
                                    icon: Icon(Icons.video_collection_outlined, size: 40, color: PinkColor,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        _moveToMyLoc(currentLocation, 11.5);
                      },
                    iconSize: 40,
                    color: YellowColor,
                    tooltip: 'Ma position',
                      icon: Icon(CupertinoIcons.map_pin_ellipse),
                  )
                ],
              )
            ],
          );

        },
      )
    );
  }

  void _moveToMyLoc(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  /*
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<LatLng> myPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    var myLocation;
    await Geolocator.getCurrentPosition().then((value) {
      myLocation = LatLng(value.latitude, value.longitude);
      currentLocation = myLocation;
    });

    print("àà@");
    print(currentLocation);

    //  return await Geolocator.getCurrentPosition();
    return myLocation;
  }
*/
}
