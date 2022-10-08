/*import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
class EmojiPickerDemo extends StatefulWidget {
  @override
  _EmojiPickerDemoState createState() => _EmojiPickerDemoState();
}

class _EmojiPickerDemoState extends State<EmojiPickerDemo> {
  bool isShowSticker;

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
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


    return Scaffold(
      appBar: AppBar(
        title: Text("Emoji Picker Demo"),
      ),
      body:WillPopScope(
          child:Stack(
            alignment:Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment:MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.end,
                      children: <Widget>[
                        // Button send image
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 1.0),
                            child: new IconButton(
                              icon: new Icon(Icons.image),
                              onPressed: () {},
                              color: Colors.blueGrey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 1.0),
                            child: new IconButton(
                              icon: new Icon(Icons.face),
                              onPressed: () {
                                setState(() {
                                  isShowSticker = !isShowSticker;
                                });
                              },
                              color: Colors.blueGrey,
                            ),
                          ),
                          color: Colors.white,
                        ),

                        // Edit text
                        Flexible(
                          child: Container(
                            child: TextField(
                              style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        ),

                        // Button send message
                        Material(
                          child: new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 8.0),
                            child: new IconButton(
                              icon: new Icon(Icons.send),
                              onPressed: () {},
                              color: Colors.blueGrey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border: new Border(
                            top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
                        color: Colors.white),
                  ),

                  // Sticker
                  (isShowSticker ? buildSticker() : Container()),
                ],
              ),
            ],
          ),
          onWillPop: onBackPress
      ),

    );
  }
  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );
  }
}

 */