import 'package:flutter/material.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/ui/menu/my_bubble_bottom_bar.dart';
import 'package:myliveevent/ui/profil/authenticate/authenticate_screen.dart';
import 'package:myliveevent/ui/profil/connection/screens/home/home_screen.dart';
import 'package:myliveevent/ui/profil/connection/screens/home/user_list.dart';

import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      print("eeeeeeeeeeerY");
      return AuthenticateScreen();
    } else {
      print("eeeeeeeeeeerX");
      return MyBubbleBottomBar();
    //  return HomeScreen();
    }
  }
}
