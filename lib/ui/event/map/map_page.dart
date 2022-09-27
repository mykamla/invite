import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/theme/my_theme.dart';

class MapPage extends StatefulWidget {
  MapPage({required this.uid, required this.nomUser, required this.email, required this.photo, Key? key}) : super(key: key);
  String? uid;
  String? nomUser;
  String? email;
  String? photo;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
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
      .limit(200)
      .snapshots();


  @override
  Widget build(BuildContext context) {
//    var currentLocation = AppConstants.myLocation;
    AppConstants().myPosition(context);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("something is wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: PrimaryColor,
                size: 40,
              ),
            );
          }
var event = snapshot.data!.docs;

          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  minZoom: 5,
                  maxZoom: 18,
                  zoom: 11,
              //    center: currentLocation,
                  center: LatLng(event[0]['position']['latitude'], event[0]['position']['longitude']),
                ),
                layers: [
                  TileLayerOptions(
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
                                scale: selectedIndex == i ? 1 : 0.7,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 500),
                                  opacity: selectedIndex == i ? 1 : 0.5,
                                  child: SvgPicture.asset(
                                    'assets/icons/map_marker.svg',
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
                height: MediaQuery.of(context).size.height * 0.3,
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
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: PrimaryColor300,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              Navigator.pushNamed(context, '/chat_page' , arguments:{
                                                "email" : widget.email,
                                                "uidEvent": 'uidEvent' //todo get uidEvent
                                              });
                                            },
                                            icon: Icon(Icons.chat_bubble)),
                                          IconButton(
                                              onPressed: (){},
                                              icon: Icon(Icons.library_music_outlined))
                                        ],
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['nom'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          item['description']?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
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
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: IconButton(
                                    onPressed: (){

                                      Navigator.pushNamed(context, '/read_video' , arguments:{
                                        "nomUser" : widget.nomUser,
                                        "email" : widget.email,
                                        "videoLink": item['video_link'],
                                        "dateDebut": DateTime.fromMillisecondsSinceEpoch((item['date_debut'] ?? 0).millisecondsSinceEpoch),
                                        "dateFin": DateTime.fromMillisecondsSinceEpoch((item['date_fin'] ?? 0).millisecondsSinceEpoch),
                                        "vueMax": item['vue_max'],
                                        "nomEvent" : item['nom']?? '',
                                        "description" : item['description']?? '',
                                        "organisateur" : item['organisateur']?? '',
                                      });
                                    },
                                    icon: Icon(Icons.play_circle_outline, size: 50, color: Colors.white,),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _moveToMyLoc(currentLocation, 11.5);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.radio_button_checked),
                          Text('Ma position')
                        ],
                      ))
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
