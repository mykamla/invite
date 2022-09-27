import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:provider/provider.dart';

class AppConstants {

  static const String mapBoxAccessToken = 'pk.eyJ1Ijoia2FtbGEiLCJhIjoiY2phamp2ZXhiM2Z5YTJ4cjF1YW1mcnc1ZyJ9.5UrtXr2QEZ1dpwnReZmL9Q';

  static const String mapBoxStyleId = 'cl82y5vc3007a14qgeavj34nj';

  static var myLocation = LatLng(51.5090214, -0.1982948);

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Map<String, dynamic>> myPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    var eventState = Provider.of<EventState>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      eventState.addEventLoad = "Récupération de votre position"; });
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      eventState.infoMapService = 'Location services are disabled.';
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
        eventState.infoMapService = 'Location permissions are denied';
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      eventState.infoMapService = 'Location permissions are permanently denied, we cannot request permissions.';

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    var myLocation;
    double? lat;
    double? long;
    await Geolocator.getCurrentPosition().then((value) {
      myLocation = LatLng(value.latitude, value.longitude);
      lat = value.latitude;
      long = value.longitude;
    });

    eventState.latitude = lat??0.0;
    eventState.longitude = long??0.0;

    eventState.addEventLoad = "Localisation terminée";

  //  return await Geolocator.getCurrentPosition();
    return {'latitude': lat, 'longitude': long };
  }

}
//https://api.mapbox.com/styles/v1/kamla/cl82y5vc3007a14qgeavj34nj/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2FtbGEiLCJhIjoiY2phamp2ZXhiM2Z5YTJ4cjF1YW1mcnc1ZyJ9.5UrtXr2QEZ1dpwnReZmL9Q