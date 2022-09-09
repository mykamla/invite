import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventMap extends StatefulWidget {

  @override
  _EventMapState createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 0.79,
          child: Text('Map HERE')
      ),
    );
  }
}
