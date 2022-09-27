import 'package:flutter/material.dart';
import 'package:myliveevent/constant/app_constants.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/profil/connection/common/constants.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

import '../../controller/event_ controller.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key? key}) : super(key: key);
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
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
      error = '';
      nameController.text = '';
      descriptionController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text(
          'Nouvel évênement',
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 50),
                child: FlutterLogo(size: 150),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 20, right: 8),
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(color: PrimaryColor),
                            cursorColor: PrimaryColor,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: PrimaryColor300),
                              labelText: 'Nom de l\'event',
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                            value == null || value.isEmpty ? "Vous devez entrer le nom de votre event" : null,
                          ),
                          decoration: BoxDecoration(
                            color: PrimaryColor100,
                            //  border: Border.all(color: PrimaryColorLight),
                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          ),),
                        SizedBox(height: 10.0),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 20, right: 8),
                          child: TextFormField(
                            controller: descriptionController,
                            style: TextStyle(color: PrimaryColor),
                            cursorColor: PrimaryColor,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: PrimaryColor300),
                              labelText: 'Description',
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                            value == null || value.isEmpty ? "Vous devez entrer la description de votre event" : null,
                          ),
                          decoration: BoxDecoration(
                            color: PrimaryColor100,
                            //  border: Border.all(color: PrimaryColorLight),
                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          ),),
                        SizedBox(height: 15.0),

                        Consumer<EventState>(
                            builder: (context, eventState, child) {
                              return
                                ElevatedButton(
                                  style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                              backgroundColor: MaterialStateColor.resolveWith((states) => PrimaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red, width: .1)
                                  )
                              )
                          ),
                                  child:  eventState.progessUpload == ''
                                    ? Text("Démarrer la vidéo")
                                  : Row(
                                    children: [
                                      Loading(iconColor: Colors.white),
                                      const SizedBox(width: 5),
                                      Text(eventState.progessUpload),
                                    ],
                                  ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() == true) {
                              setState(() => loading = true);
                              var nom = nameController.value.text;
                              var description = descriptionController.value.text;

                              await AppConstants().myPosition(context)
                              .then((value) async {
                                eventState.progessUpload = "terminé";
                                Navigator.pushNamed(context, '/upload_video', arguments:{
                                  "nom" :nom,
                                  "description" : description,
                                });
                              });
                            }
                          },
                        );
  }),
                        SizedBox(height: 10.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 15.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
             /*
              Text("Nous aurons accès à votre position pour une meilleure expérience",
                    style: TextStyle(fontSize: 15, color: PrimaryColor300), textAlign: TextAlign.center),
            */
            ],
          ),
        ),
      ),
    );
  }

}
