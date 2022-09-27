import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myliveevent/controller/event_%20controller.dart';
import 'package:myliveevent/model/event.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class MyEvents extends StatefulWidget {
  MyEvents({required this.uid, required this.email, Key? key}) : super(key: key);
  String? uid;
  String? email;

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final TextEditingController message = new TextEditingController();

  final _myListKey = GlobalKey<AnimatedListState>();

  Stream<QuerySnapshot> _eventStream = FirebaseFirestore.instance
      .collection('events')
      .where('live', isEqualTo: true)
      .orderBy('date_debut')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _eventStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("something is wrong");
      }
      if (snapshot.connectionState != ConnectionState.waiting) {
        return Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Colors.white,
            size: 40,
          ),
        );
      }

      print("ok ggggggg");
      print(snapshot.data?.docs);

      return Container(
          height: MediaQuery.of(context).size.height * 0.79,
          child: AnimatedList(
            key: _myListKey,
            initialItemCount: snapshot.data != null ? snapshot.data!.docs.length : 0,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            primary: true,
            reverse: true,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              QueryDocumentSnapshot event = snapshot.data!.docs[index];
              String name = event['nom'];
              String description = event['description'];
              String channel = event['channel'];
              String date_debut = event['date_debut'];
              String date_fin = event['date_fin'];
              String live = event['live'];
              String vue_max = event['vue_max'];
              var position  = event['position'];
              String organisateur = event['organisateur'];

              return ListTile(
                title: Text(widget.uid!),
                subtitle: Text('Description event'),
                leading: IconButton(
                    color: Colors.redAccent,
                    iconSize: 20,
                    onPressed: (){
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
                          Icon(Icons.location_on_outlined, color: Colors.redAccent,),
                          Text('~10 m', style: TextStyle(fontSize: 10, color: Colors.redAccent),),
                        ],
                      ),
                      onPressed: (){},),
                  )
                ),

                onTap: (){},

              );
            },)
      );

        },
    )
    );
  }

}
