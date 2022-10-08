import 'package:flutter/material.dart';

import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';

class SendingVideo extends StatefulWidget {
  SendingVideo({Key? key, required this.nomVideo}) : super(key: key);
  String? nomVideo;

  @override
  _SendingVideoState createState() => _SendingVideoState();
}

class _SendingVideoState extends State<SendingVideo> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: [
              Loading(),
              Container(
                child: Text('Envoie de la video', style: TextStyle(color: PrimaryColor),),
              )
            ],
          )

        ],
      ),
    );
  }

}
