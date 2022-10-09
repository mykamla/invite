import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/event/events.dart';
import 'package:myliveevent/ui/event/map/map_page.dart';
import 'package:myliveevent/ui/event/my_events.dart';
import 'package:myliveevent/ui/event/spotify/example.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/ui/profil/connection/services/database.dart';
import 'package:myliveevent/model/user.dart';
import 'package:myliveevent/util/database_task.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:provider/provider.dart';

class MyBottomMenu extends StatefulWidget {
  MyBottomMenu({this.user, this.uid});
  var user;
  String? uid;

  @override
  _MyBottomMenuState createState() => _MyBottomMenuState();
}

class _MyBottomMenuState extends State<MyBottomMenu> {

  final AuthenticationService _auth = AuthenticationService();

  PageController? _myPage;

  PageController? get myPage => this._myPage;

  set myPage(PageController? value) => this._myPage = value;
  var selectedPage;
  String? title;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myPage = PageController(initialPage: 1);
    selectedPage = 1;

    ///delete old Videos when app launched
    DatabaseTask().batchDeleteOldEvent()
    //    .whenComplete(() => DatabaseTask().batchDeleteChat())
        ;

  }

  @override
  dispose() {
    _myPage!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
   // Exemple().m();
   // var eventState = Provider.of<EventState>(context, listen: false);
   // final user = Provider.of<AppUser>(context, listen: false);
    if (widget.user == null) throw Exception("user not found");
    final database = DatabaseService(widget.uid!);

    Widget emptyButton = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,),
      ],
    );

    Widget mapButton = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: selectedPage == 1 ? 5.0 : 0.0,
          width: selectedPage == 1 ? 30.0 : 0.0,
          decoration: BoxDecoration(
              color: YellowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(00.0),
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(100.0),
                topRight: Radius.circular(00.0),
              )),
        ),
        SizedBox(
          height: 33,
          child: IconButton(
            iconSize: 23.0,
            icon: Icon(CupertinoIcons.map),
            color: YellowColor,
            onPressed: () {
              _myPage!.jumpToPage(1);
              setState(() {
                selectedPage = 1;
              });
            },
          ),
        ),
        Text(
          'Map',
          style: TextStyle(color: YellowColor, fontSize: 12.0),
        )
      ],
    );

    Widget eventsButton = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: selectedPage == 2 ? 5.0 : 0.0,
          width: selectedPage == 2 ? 30.0 : 0.0,
          decoration: BoxDecoration(
              color: YellowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(00.0),
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(100.0),
                topRight: Radius.circular(00.0),
              )),
        ),
        SizedBox(
          height: 33,
          child: IconButton(
            iconSize: 23.0,
            icon: Icon(CupertinoIcons.square_list),
            color: YellowColor,
            onPressed: () {
              _myPage!.jumpToPage(2);
              setState(() {
                selectedPage = 2;
              });
            },
          ),
        ),
        Text(
          'Evènement',
          style: TextStyle(color: YellowColor, fontSize: 12.0),
        )
      ],
    );

    Widget myEventsButton = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: selectedPage == 3 ? 5.0 : 0.0,
          width: selectedPage == 3 ? 30.0 : 0.0,
          decoration: BoxDecoration(
              color: YellowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(00.0),
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(100.0),
                topRight: Radius.circular(00.0),
              )),
        ),
        SizedBox(
          height: 33,
          child: IconButton(
            iconSize: 23.0,
            icon: Icon(CupertinoIcons.list_dash),
            color: YellowColor,
            onPressed: () {
              _myPage!.jumpToPage(3);
              setState(() {
                selectedPage = 3;
              });
            },
          ),
        ),
        Text(
          'Mes events',
          style: TextStyle(color: YellowColor, fontSize: 12.0),
        )
      ],
    );

    return StreamProvider<List<User>>.value(
        initialData: [],
        value: database.users,
        child: StreamBuilder<User>(
          stream: database.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User? user = snapshot.data;
              if (user == null) return Scaffold(backgroundColor: PrimaryColor, body: Loading());
              var eventState = Provider.of<EventState>(context, listen: false);
              WidgetsBinding.instance.addPostFrameCallback((_){
                eventState.email = user.email!;
                eventState.nomUser = user.nom!;
                });

              return Scaffold(
                backgroundColor: PrimaryColor,
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text(
              'Name',
            ),
            actions: [
            Text('', style: TextStyle(color: Colors.white)),
              PopupMenuButton(
                color: YellowColor,
                  itemBuilder: (context){
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Se déconnecter", style: TextStyle(color: PinkColor),),
                      ),
                    ];
                  },
                  onSelected:(value) async {
                    if(value == 0){
                      Loading(iconColor: Colors.redAccent,);
                    //  await Future.delayed(Duration(seconds: 2));
                      await _auth.signOut(context);
                    }
                  }
              ),

            ],
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _myPage,
            children: <Widget>[
              //page 0
              Center(
                child: Text("EmptyPage"),
              ),
              //page 1
              MapPage(uid: user.uid, nomUser: user.nom, email : user.email, photo: user.photo),
              //page 2
              Events(uid: user.uid, nomUser: user.nom, email :user.email, photo: user.photo),
              //page 3
              MyEvents(uid: user.uid, nomUser: user.nom, email : user.email, photo: user.photo),

            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              Navigator.pushNamed(context, '/add_event' , arguments:{
                "organisateur" : user.email
              });
              },
            child: Icon(Icons.add_circle_outline, color: PinkColor, size: 35,),
            backgroundColor: PrimaryColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                bottomNavigationBar: BottomAppBar(
                  color: PrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      mapButton,
                      eventsButton,
                      myEventsButton,
                      emptyButton
                    ],
                  ),
                ),
        );
            } else {
              return Scaffold(backgroundColor: PrimaryColor, body: Loading(iconColor: YellowColor,));
            }
          },
        ),
    );
  }
}