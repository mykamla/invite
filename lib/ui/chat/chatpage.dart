import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../profil/login.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.email, required this.codeEvent});

  String? email;
  String? codeEvent;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final fs = FirebaseFirestore.instance;
  final TextEditingController? msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.40,
            child: messages(
              email: widget.email!,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: msgController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.purple[100],
                    hintText: 'Ecrivez un message',
                    enabled: true,
                    contentPadding: EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  validator: (value) {},
                  onSaved: (value) {
                    msgController!.text = value!;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (msgController!.text.isNotEmpty) {
                    fs.collection('messages').doc().set({
                      'message': msgController!.text.trim(),
                      'time': DateTime.now(),
                      'email': widget.email,
                      'event': widget.codeEvent,
                    });

                    msgController!.clear();
                  }
                },
                icon: Icon(Icons.send_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
