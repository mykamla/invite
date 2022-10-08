import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/widget/text_divider/src/text_divider.dart';

class MyProfil extends StatefulWidget {
  @override
  _MyProfilState createState() => _MyProfilState();
}

class _MyProfilState extends State<MyProfil> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PrimaryColor,
        title: Text('Mes infos'),
      ),
      backgroundColor: PrimaryColor,
      body: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ],
              )
            ),
          ],
        ),
      ),

    );
  }
}
