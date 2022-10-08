import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class EventController {

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> _compressVideo({required  String videoPath, bool includeAudio = true}) async {
    await VideoCompress.setLogLevel(0);
    var info = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: includeAudio,
    );
    return info!.path!;
  }

  String url = '';
  Future<String> _uploadVideo(BuildContext context, String videoPath) async {

    return url;
  }

  // calling addVideo in UI retrieve video link
  Future<void> addEvent({required context, required String nom, required String description, required Map<String, dynamic> playlist, required String videoPath}) async {

    var eventState = Provider.of<EventState>(context, listen: false);

    if(videoPath == null || videoPath == ''){
      final byteData = await rootBundle.load('assets/empty.txt');

      final file = File('${(await getTemporaryDirectory()).path}/empty.txt');
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      videoPath = file.path;
    }


    String nameVideoUploading = path.basename(videoPath) + DateTime.now().toUtc().toString();
    eventState.nameVideoUploading = nameVideoUploading;
    Reference ref = storage.ref().child('videos/$nameVideoUploading');
    // compressing video before uploading
    String? videoCompressed = await _compressVideo(videoPath: videoPath);
    //uploading video
    UploadTask uploadTask = ref.putFile(File(videoPath));
    //  UploadTask uploadTask = ref.putString(videoCompressed);

    uploadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          // todo when progress == 100 percent, go at home
          await ref.getDownloadURL().then((value) async {

            String urlDwl = value;

            CollectionReference? events;
            var eventState = Provider.of<EventState>(context, listen: false);
            events = FirebaseFirestore.instance.collection('events');

            List urls = [];
            urls.add(urlDwl);


            await events.add(
                {
                  'nom': nom,
                  'description': description,
                  'playlist': playlist,
                  'video_link': urls,
                  'date_debut': DateTime.now().toUtc(),
                  'date_fin': DateTime.now().toUtc().add(const Duration(days: 1)),
                  'vue_max': null,
                  'position': {'latitude': eventState.latitude, 'longitude': eventState.longitude},
                  'organisateur': eventState.email, // email organisateur
                  'created_at': DateTime.now().toUtc()
                }
            ).whenComplete(() async {
              await Future.delayed(const Duration(seconds: 1));
              eventState.progessUpload = "Evênement ajouté";
              //delete video in local storage after stored in Cloud
              try{
                File video = File(videoPath);
                await video.delete();
              }catch(e){print(e);}

              Navigator.pop(context);

            }).catchError((error) async {
              eventState.progessUpload = "Echec";
              //If failed to store date, video was upload is deleted from storage
              Reference ref = storage.ref().child(eventState.nameVideoUploading);
              await ref.delete();
              print("Failed to add event: $error");
            });


          });
          eventState.progessUpload = progress.toString();

          break;
        case TaskState.paused:
          eventState.progessUpload = "paused";
          break;
        case TaskState.success:
          eventState.progessUpload = "success";
          break;
        case TaskState.canceled:
          eventState.progessUpload = "canceled";
          break;
        case TaskState.error:
          eventState.progessUpload = "error";
          break;
      }
    });


/*
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {print(onError);});
*/

  }

  Future<void> addVideoInEvent({required context, required List videoList, required String uidEvent, required String videoPath}) async {
    var eventState = Provider.of<EventState>(context, listen: false);

    String nameVideoUploading = path.basename(videoPath) + DateTime.now().toUtc().toString();
    eventState.nameVideoUploading = nameVideoUploading;
    Reference ref = storage.ref().child('videos/$nameVideoUploading');
    // compressing video before uploading
    String? videoCompressed = await _compressVideo(videoPath: videoPath);
    //uploading video
    UploadTask uploadTask = ref.putFile(File(videoPath));
    //  UploadTask uploadTask = ref.putString(videoCompressed);

    uploadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          // todo when progress == 100 percent, go at home
          await ref.getDownloadURL().then((value) async {

            String urlDwl = value;

          //  CollectionReference? events;
            var eventState = Provider.of<EventState>(context, listen: false);
           // events = FirebaseFirestore.instance.collection('events').doc(uidEvent);

            videoList.add(urlDwl);

            await FirebaseFirestore.instance.collection('events')
                .doc(uidEvent)
                .update(
                {
                  'video_link': videoList,
                  'update_at': DateTime.now().toUtc()
                }
            ).whenComplete(() async {
              await Future.delayed(const Duration(seconds: 1));
              eventState.progessUpload = "finished";
              //delete video in local storage after stored in Cloud
              /// pas tres utile
              try{
                File video = File(videoPath);
                await video.delete();
              }catch(e){print(e);}

            }).catchError((error) async {
              eventState.progessUpload = "Echec";
              //If failed to store date, video was upload is deleted from storage
              Reference ref = storage.ref().child(eventState.nameVideoUploading);
              await ref.delete();
              print("Failed to add event: $error");
            });

          });
          eventState.progessUpload = progress.toString();

          break;
        case TaskState.paused:
          eventState.progessUpload = "paused";
          break;
        case TaskState.success:
          eventState.progessUpload = "success";
          break;
        case TaskState.canceled:
          eventState.progessUpload = "canceled";
          break;
        case TaskState.error:
          eventState.progessUpload = "error";
          break;
      }
    });


/*
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {print(onError);});
*/

  }


  /*
  Future<void> addEvent({required context, required String nom, required String description, required String organisateur, required String uid}) async {

    final _channelName = "{cn_${uid}_${Uuid().v4()}";

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference events = await FirebaseFirestore.instance.collection('events');
    await events.add(
        {
          'nom': nom,
          'description': description,
          'channel': _channelName,
          'date_debut': DateTime.now().toUtc(),
          'date_fin': null,
          'live': true,
          'vue_max': null,
          'position': await _determinePosition(),
          'organisateur': organisateur, // email organisateur
        }
    ).whenComplete(() => onJoin(context: context, channelName: _channelName, route: '/live_broadcast', uid: uid, isBroadcaster: true))
        .catchError((error) => print("Failed to add event: $error"));


  }
*/

 /*
  Future<void> onJoin({required context, required String channelName, required String route, required String uid,  required bool isBroadcaster}) async {
    await [Permission.camera, Permission.microphone].request();

    Position position  = await _determinePosition();

    final _channelName = "{cn_${uid}_${Uuid().v4()}";
    //todo create event

    Navigator.pushNamed(context,route , arguments:{
      "channelName" : _channelName,
      "isBroadcaster" : isBroadcaster,
      "uid": uid
    });
  }
*/


  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
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
    return await Geolocator.getCurrentPosition();
  }

}