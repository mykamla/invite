import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/model/event.dart';
import 'package:myliveevent/provider/eventState.dart';
import 'package:myliveevent/theme/myTheme.dart';
import 'package:myliveevent/ui/event/event_map.dart';
import 'package:myliveevent/ui/event/events.dart';
import 'package:myliveevent/ui/profil/connection/services/database.dart';
import 'package:myliveevent/model/user.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MyBubbleBottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyBottomPage();
  }
}

class MyBottomPage extends StatefulWidget {

  @override
  _MyBottomPageState createState() => _MyBottomPageState();
}

class _MyBottomPageState extends State<MyBottomPage> {
  late int currentIndex;

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
    var eventState = Provider.of<EventState>(context, listen: false);
    final user = Provider.of<AppUser>(context, listen: false);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);

    return StreamProvider<List<User>>.value(
        initialData: [],
        value: database.users,
        child: StreamBuilder<User>(
          stream: database.user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User? user = snapshot.data;
              if (user == null) return Loading();
              return Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text(
              'Project Name',
            ),
            actions: [
            Text(user.nom!, style: TextStyle(color: Colors.white)),
              IconButton(
                  onPressed: (){},
                  color: Colors.white,
                  icon: Icon(Icons.account_circle_outlined)
              )
            ],
          ),
          body: currentIndex == 0
              ? Events(uid: user.uid,)
              : EventMap(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              onJoin(route:' /live_brodcast', uid: '',  isBroadcaster: true);
              Navigator.pushNamed(context, '/broadcast');
            },
            child: Icon(Icons.add_circle_outline),
            backgroundColor: Colors.red,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BubbleBottomBar(
            hasNotch: true,
            fabLocation: BubbleBottomBarFabLocation.end,
            opacity: .2,
            currentIndex: currentIndex,
            onTap: changePage,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ), //border radius doesn't work when the notch is enabled.
            elevation: 8,
            tilesPadding: EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                backgroundColor: Colors.red,
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
                title: Text("Evènements"),
              ),
              BubbleBottomBarItem(
                  backgroundColor: Colors.red,
                  icon: Icon(
                    Icons.map,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.map_outlined,
                    color: Colors.red,
                  ),
                  title: Text("Carte évènements")),
            ],
          ),
        );
            } else {
              return Loading();
            }
          },
        ),
    );

  }

  final String _channelName = "mychan";
  Future<void> onJoin({required String route, required String uid,  required bool isBroadcaster}) async {
    await [Permission.camera, Permission.microphone].request();

    Navigator.pushNamed(context,'live_broadcast' , arguments:{
      "channelName" : "${_channelName}_${uid}_${Uuid().v4()}",
      "isBroadcaster" : isBroadcaster,
      "uid": uid
    });

    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BroadcastPage(
          channelName: _channelName,

          isBroadcaster: isBroadcaster,
        ),
      ),
    );
    */
  }


}