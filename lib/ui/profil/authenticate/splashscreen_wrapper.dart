import 'package:flutter/material.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/ui/menu/my_bubble_bottom_bar.dart';
import 'package:myliveevent/ui/profil/authenticate/authenticate_screen.dart';

import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return AuthenticateScreen();
    } else {
      return MyBubbleBottomBar();
    }
  }
}
