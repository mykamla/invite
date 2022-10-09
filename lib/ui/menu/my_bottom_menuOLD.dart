import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/event/events.dart';
import 'package:myliveevent/ui/event/map/map_page.dart';
import 'package:myliveevent/ui/event/my_events.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/ui/profil/connection/services/database.dart';
import 'package:myliveevent/model/user.dart';
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
  late int currentIndex;
  final AuthenticationService _auth = AuthenticationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
   // var eventState = Provider.of<EventState>(context, listen: false);
   // final user = Provider.of<AppUser>(context, listen: false);
    if (widget.user == null) throw Exception("user not found");
    final database = DatabaseService(widget.uid!);

    return StreamProvider<List<User>>.value(
        initialData: [],
        value: database.users,
        child: StreamBuilder<User>(
          stream: database.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User? user = snapshot.data;
              if (user == null) return Scaffold(backgroundColor: PrimaryColor, body: Loading(iconColor: YellowColor,));
              var eventState = Provider.of<EventState>(context, listen: false);
              WidgetsBinding.instance.addPostFrameCallback((_){
                eventState.email = user.email!;
                eventState.nomUser = user.nom!;
                });

              return Scaffold(
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
          body: currentIndex == 0
              ? Events(uid: user.uid, nomUser: user.nom, email :user.email, photo: user.photo)
              : currentIndex == 1
                  ? MapPage(uid: user.uid, nomUser: user.nom, email : user.email, photo: user.photo)
          : MyEvents(uid: user.uid, nomUser: user.nom, email : user.email, photo: user.photo),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {

              Navigator.pushNamed(context, '/add_event' , arguments:{
                "organisateur" : user.email
              });
              },
            child: Icon(Icons.add_circle_outline, color: PinkColor,),
            backgroundColor: PrimaryColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: Container(
            color: PrimaryColor,
            child: BubbleBottomBar(
              hasNotch: false,
              fabLocation: BubbleBottomBarFabLocation.end,
              opacity: 1,
              backgroundColor: PrimaryColor,
              currentIndex: currentIndex,
              onTap: changePage,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),//border radius doesn't work when the notch is enabled.
              elevation: 8,
              tilesPadding: EdgeInsets.symmetric(vertical: 8.0,),
              items: <BubbleBottomBarItem>[
                BubbleBottomBarItem(
                  backgroundColor: PrimaryColor,
                  icon: Icon(
                    Icons.dashboard,
                    color: YellowColor,
                  ),
                  activeIcon: Icon(
                    Icons.dashboard,
                    color: YellowColor,
                  ),
                  title: Text("Evènements", style: TextStyle(color: YellowColor),),
                ),
                BubbleBottomBarItem(
                    backgroundColor: PrimaryColor,
                    icon: Icon(
                      Icons.map,
                      color: YellowColor,
                    ),
                    activeIcon: Icon(
                      Icons.map_outlined,
                      color: YellowColor,
                    ),
                    title: Text("Map", style: TextStyle(color: YellowColor))),
                BubbleBottomBarItem(
                    backgroundColor: PrimaryColor,
                    icon: Icon(
                      Icons.list,
                      color: YellowColor,
                    ),
                    activeIcon: Icon(
                      Icons.list_alt,
                      color: YellowColor,
                    ),
                    title: Text("Mes events", style: TextStyle(color: YellowColor))),
              ],
            )
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