import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class messages extends StatefulWidget {
  String? email;
  String? uidEvent;
  messages({required this.email, required this.uidEvent});
  @override
  _messagesState createState() => _messagesState();
}

class _messagesState extends State<messages> {

  final _myListKey = GlobalKey<AnimatedListState>();


  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection('messages')
        .where('uid_event', isEqualTo: widget.uidEvent)
        .orderBy('time')
        .snapshots();

    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.hexagonDots(
              color: Colors.white,
              size: 40,
            ),
          );
        }

        print("ok ggggggg");
        print(snapshot.data!.docs);


        return AnimatedList(
          key: _myListKey,
          initialItemCount: snapshot.data!.docs.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          reverse: true,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            QueryDocumentSnapshot msgs = snapshot.data!.docs[index];
            Timestamp t = msgs['time'];
            DateTime d = t.toDate();
            print(d.toString());

            return Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: Column(
                crossAxisAlignment: widget.email == msgs['email']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BubbleSpecialTwo(
                          text: msgs['email'],
                          tail: false,
                          isSender: false,
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),

                      ),
                    ],
                  ),
                  ListTile(
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              msgs['message'],
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            d.hour.toString() + ":" + d.minute.toString(),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            );
          },

        );
      },
    );
  }
}
