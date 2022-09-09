import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:myliveevent/model/event.dart';
import 'package:myliveevent/provider/eventState.dart';
import 'package:myliveevent/ui/event/event_map.dart';
import 'package:myliveevent/ui/event/events.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Project Name',
        ),
        actions: [
          IconButton(
              onPressed: (){},
      color: Colors.white,
      icon: Icon(Icons.account_circle_outlined)
          )
        ],
      ),
      body: currentIndex == 0
          ? Events()
          : EventMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
  }
}