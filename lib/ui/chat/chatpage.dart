import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.email, required this.uidEvent, required this.nomUser, required this.nomEvent});

  String? email;
  String? nomUser;
  String? uidEvent;
  String? nomEvent;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final fs = FirebaseFirestore.instance;
  final TextEditingController? msgController = TextEditingController();

  final _myListKey = GlobalKey<AnimatedListState>();
  bool? isShowSticker;
  Stream<QuerySnapshot>? _messageStream;

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
    _messageStream = FirebaseFirestore.instance
        .collection('messages')
        .where('uid_event', isEqualTo: widget.uidEvent)
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<bool> onBackPress() {
    if (isShowSticker!) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);

  }

  @override
  Widget build(BuildContext context) {


    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: PrimaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.nomEvent??'')),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.94,
          child: FutureBuilder(builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return StreamBuilder(
              stream: _messageStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(""));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Loading(),
                  );
                }

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

                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      child: Column(
                        crossAxisAlignment: widget.email == msgs['email']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Container(
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                                left: widget.email == msgs['email'] ? 50 : 0,
                                right: widget.email == msgs['email'] ? 0 : 50
                            ),
                            child: Column(
                              mainAxisAlignment: widget.email == msgs['email'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: widget.email == msgs['email'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(msgs['nom'], style: TextStyle(fontWeight: FontWeight.bold, color: widget.email == msgs['email'] ? PrimaryColor900 : Colors.white),),
                                ),
                                SizedBox(height: 8,),
                                Container(
                                  child: Text(msgs['message'], style: TextStyle(color: widget.email == msgs['email'] ? PrimaryColor900 : Colors.white),),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  child: Text(d.hour.toString() + ":" + d.minute.toString(),
                                    style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: widget.email == msgs['email'] ? PrimaryColor900 : Colors.white70),

                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: widget.email == msgs['email'] ? YellowColor : PrimaryColor900,
                              //  border: Border.all(color: PrimaryColorLight),
                              borderRadius: BorderRadius.only(
                                topLeft: widget.email == msgs['email'] ? Radius.circular(8.0) : Radius.circular(.0),
                                topRight: widget.email == msgs['email'] ? Radius.circular(.0) : Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),

                              ),),
                          )
                        ],
                      ),
                    );
                  },

                );
              },
            );
          },

          )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 0, right: 15),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextFormField(
                  controller: msgController,
                  style: TextStyle(color: PrimaryColor),
                  cursorColor: PrimaryColor,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ecrivez un message",
                    prefixIcon: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.face),
                      onPressed: () {
                        setState(() {
                  //        isShowSticker = !isShowSticker;
                        });
                      },
                    ),
                  ),
                  ),
                  onSaved: (value) {
                    msgController!.text = value!;
                  },
                ),
                decoration: BoxDecoration(
                  color: PrimaryColor100,
                  //  border: Border.all(color: PrimaryColorLight),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 6),
              child: IconButton(
                onPressed: () {
                  if (msgController!.text.isNotEmpty) {
                    fs.collection('messages').doc().set({
                      'message': msgController!.text.trim(),
                      'time': DateTime.now().toUtc(),
                      'email': widget.email,
                      'nom': widget.nomUser,
                      'uid_event': widget.uidEvent,
                    });
                    msgController!.clear();
                  }
                },
                icon: Icon(CupertinoIcons.paperplane, color: Colors.white,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
