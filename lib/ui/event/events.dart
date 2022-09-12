import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/model/event.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class Events extends StatefulWidget {
  Events({required this.uid, Key? key}) : super(key: key);
  String? uid;

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final TextEditingController message = new TextEditingController();

  final String _channelName = "mychan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 0.79,
          child: AnimatedList(
            initialItemCount: 10,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              return ListTile(
                title: Text(widget.uid!),
                subtitle: Text('Description event'),
                leading: IconButton(
                    color: Colors.redAccent,
                    iconSize: 20,
                    onPressed: (){
                      onJoin(route:' /live_brodcast', uid: widget.uid!,  isBroadcaster: false);
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
      ),
    );
  }

  Future<void> onJoin({required String route, required String uid,  required bool isBroadcaster}) async {
    await [Permission.camera, Permission.microphone].request();

    Navigator.pushNamed(context,'live_broadcast' , arguments:{
      "channelName" : "${_channelName}_${uid}_${Uuid().v4()}",
      "isBroadcaster" : isBroadcaster,
      "uid": uid
    });

    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BroadcastPage(
          channelName: _channelName,

          isBroadcaster: isBroadcaster,
        ),
      ),
    );
    */
  }

}
