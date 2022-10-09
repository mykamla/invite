import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/event/spotify/playlist.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/widget/selected_dialog/select_dialog.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key? key}) : super(key: key);
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      nameController.text = '';
      descriptionController.text = '';
    });
  }

  @override
  void initState() {
    getPos();
    nameController.text = '';
    descriptionController.text = '';
    super.initState();
  }

  bool getPosFinished = false;

  Future<void> getPos() async {
    await AppConstants().myPosition(context).whenComplete(() => setState(() => getPosFinished = true ));
  }

  Map<String, dynamic> playlist = {};


  PlaylistSimple? simple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nouvel évènement',
            ),
            getPosFinished == true
            ? Row(
              children: [
                Consumer<EventState>(
                    builder: (context, eventState, child) {
                      return IconButton(
                        tooltip: 'Sans la vidéo',
                        icon: Icon(Icons.add_circle_outline),
                        color: YellowColor,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            setState(() => loading = true);
                            var nom = nameController.value.text;
                            var description = descriptionController.value.text;

                            Navigator.pushNamed(context, '/upload_video', arguments:{
                              "nom" :nom,
                              "description" : description,
                              "playlist": playlist

                            });
                          }
                        },
                      );
                    }),

/*
                Consumer<EventState>(
                    builder: (context, eventState, child) {
                      return IconButton(
                        tooltip: 'ajouter la vidéo',
                        icon: Icon(Icons.add_circle_outline),
                        color: YellowColor,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            setState(() => loading = true);
                            var nom = nameController.value.text;
                            var description = descriptionController.value.text;

                            await AppConstants().myPosition(context)
                                .then((value) async {

                              //first upload wihout video
                              Navigator.pushNamed(context, '/upload_video', arguments:{
                                "nom" :nom,
                                "description" : description,
                                "uidEvent": null,
                                "playlist": playlist
                              });
                            });
                          }
                        },
                      );
                    }),
*/

              ],
            )
            : Container(child:  LoadingAnimationWidget.waveDots(
              color: YellowColor,
              size: 20,
            ),
            )
          ],
        )
      ),
      backgroundColor: PrimaryColor,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //email
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 8),
                            child: TextFormField(
                              controller: nameController,
                              style: TextStyle(color: PrimaryColor),
                              cursorColor: PrimaryColor,
                              keyboardType: TextInputType.text,
                              maxLength: 15,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                labelStyle: TextStyle(color: PrimaryColor300),
                                labelText: "Nom de votre event",
                              ),
                              validator: (value) => value == null || value.isEmpty ? "Nom de l'event requis" : null,
                            ),
                            decoration: BoxDecoration(
                              color: PrimaryColor100,
                              //  border: Border.all(color: PrimaryColorLight),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),),
                          SizedBox(height: 10.0),
                          //password
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 8),
                            child: TextFormField(
                              controller: descriptionController,
                              style: TextStyle(color: PrimaryColor),
                              cursorColor: PrimaryColor,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              maxLength: 200,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                labelStyle: TextStyle(color: PrimaryColor300),
                                labelText: 'Description',
                              ),
                              validator: (value) => value == null || value.isEmpty ? "Desciption requise" : null,),
                            decoration: BoxDecoration(
                              color: PrimaryColor100,
                              //  border: Border.all(color: PrimaryColorLight),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),),
                          SizedBox(height: 10.0),
                          //playlist
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 20, right: 0),
                            decoration: BoxDecoration(
                              color: PrimaryColor100,
                              //  border: Border.all(color: PrimaryColorLight),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: TextButton(
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero,),
                                ),
                                onPressed: () => SelectDialog.showModal<PlaylistSimple>(
                                      context,
                                      autofocus: false,
                                      backgroundColor: PrimaryColor400,
                                      searchHint: 'Chercher une ambiance',
                                      alwaysShowScrollBar: false,
                                      selectedValue: simple,
                                      itemBuilder: (BuildContext context, PlaylistSimple simple, bool) {
                                        var sUrl;
                                        try{
                                          sUrl = simple.images!.first.url;
                                          }catch(e){

                                        }

                                        return Column(
                                          children: [
                                            const SizedBox(height: 5,),
                                            Container(
                                              padding: const EdgeInsets.only(left: 5.0, right: .0),
                                              decoration: BoxDecoration(
                                                color: PinkColor,
                                                //  border: Border.all(color: PrimaryColorLight),
                                                borderRadius: BorderRadius.all(Radius.circular(8.0),
                                                ),),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(child: Text('${simple.name!} [${simple.tracksLink!.total!.toString()}]', style: TextStyle(fontWeight: FontWeight.normal),
                                                  )
                                                  ),
                                                  (sUrl != null || sUrl == '')
                                                      ? GestureDetector(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: CachedNetworkImage(
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.fill,
                                                        imageUrl: sUrl,
                                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                            Loading(),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                      ),
                                                    ),
                                                    onLongPress: () {
                                                    },
                                                  )
                                                      : Container(height: 0,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      onFind: (String filter) {
                                        return SpotifyPlaylist().playlist(filter);
                                      },
                                      onChange: (PlaylistSimple selected) {
                                        List images = [];
                                        setState(() {
                                          simple = selected;
                                          simple!.images!.forEach((element) {
                                            images.add(element.url);
                                          });

                                          playlist['id'] = simple!.id!;
                                          playlist['name'] = simple!.name!;
                                          playlist['images'] = images;
                                          playlist['description'] = simple!.description!;
                                          playlist['uri'] = simple!.uri!;
                                      //    playlist['externalUrls'] = simple!.externalUrls!.spotify;
                                          playlist['type'] = simple!.type!;
                                          playlist['href'] = simple!.href!;
                                        });
                                      },
                                    ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(simple == null ? 'Ajoutez une embiance' : simple!.name!, overflow: TextOverflow.ellipsis),
                                    ),
                                    simple != null
                                    ? Expanded(
                                      flex: 0,
                                      child: GestureDetector(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                            imageUrl: simple!.images!.first.url!,
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                Loading(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                        onLongPress: () async {

                                          print("@longpres");


                                          final Uri _url = Uri.parse(simple!.uri!);


                                          try{
                                            // Launch the url which will open Spotify
                                            launchUrl(_url);
                                          }catch(e){}

                                        },
                                      )
                                    )
                                    : SizedBox()
                                  ],
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
