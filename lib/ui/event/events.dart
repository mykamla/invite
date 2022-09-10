import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/model/event.dart';

class Events extends StatefulWidget {

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 0.79,
          child: AnimatedList(
            initialItemCount: 10,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              return ListTile(
                title: Text('Title'),
                subtitle: Text('Description event'),
                leading: IconButton(
                    color: Colors.redAccent,
                    iconSize: 20,
                    onPressed: (){
                      Navigator.pushNamed(context, '/live', arguments: 'arg');
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
}
