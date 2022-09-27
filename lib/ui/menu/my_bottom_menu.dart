import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:myliveevent/controller/event_%20controller.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/model/event.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/event/event_map.dart';
import 'package:myliveevent/ui/event/events.dart';
import 'package:myliveevent/ui/event/map/map_page.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/ui/profil/connection/services/database.dart';
import 'package:myliveevent/model/user.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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

            print('@@AZ');
            print(snapshot.data);

            if (snapshot.hasData) {
              User? user = snapshot.data;
              if (user == null) return Scaffold(backgroundColor: PrimaryColor, body: Loading(iconColor: YellowColor,));
              var eventState = Provider.of<EventState>(context, listen: false);
              eventState.email = user.email!;

              return Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text(
              'Project Name',
            ),
            actions: [
            Text(user.nom!, style: TextStyle(color: Colors.white)),

              PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                  itemBuilder: (context){
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Mon compte"),
                      ),

                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Réglages"),
                      ),

                      PopupMenuItem<int>(
                        value: 2,
                        child: Text("Se déconnecter", style: TextStyle(color: Colors.redAccent),),
                      ),
                    ];
                  },
                  onSelected:(value) async {
                    if(value == 0){
                      print("My account menu is selected.");
                    }else if(value == 1){
                      print("Settings menu is selected.");
                    }else if(value == 2){
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
              : MapPage(uid: user.uid, nomUser: user.nom, email :user.email, photo: user.photo),
          floatingActionButton: FloatingActionButton(
            onPressed: () {

              Navigator.pushNamed(context, '/add_event' , arguments:{
                "organisateur" : user.email
              });
              },
            child: Icon(Icons.add_circle_outline),
            backgroundColor: PrimaryColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BubbleBottomBar(
            hasNotch: false,
            fabLocation: BubbleBottomBarFabLocation.end,
            opacity: .2,
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
                  color: PrimaryColor,
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: PrimaryColor,
                ),
                title: Text("Evènements"),
              ),
              BubbleBottomBarItem(
                  backgroundColor: PrimaryColor,
                  icon: Icon(
                    Icons.map,
                    color: PrimaryColor,
                  ),
                  activeIcon: Icon(
                    Icons.map_outlined,
                    color: PrimaryColor,
                  ),
                  title: Text("Map")),
              BubbleBottomBarItem(
                  backgroundColor: PrimaryColor,
                  icon: Icon(
                    Icons.map,
                    color: PrimaryColor,
                  ),
                  activeIcon: Icon(
                    Icons.list_alt,
                    color: PrimaryColor,
                  ),
                  title: Text("Mes events")),
            ],
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