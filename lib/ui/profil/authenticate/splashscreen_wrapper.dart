import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/menu/my_bottom_menu.dart';
import 'package:myliveevent/ui/profil/authenticate/authenticate_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {

au() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  await _auth.signOut();
}
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return AnimatedSplashScreen(
          duration: 4000,
          splash: const FlutterLogo(size: 1000),
          nextScreen: AuthenticateScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: PrimaryColor);
    } else {
   //  au();
      return AnimatedSplashScreen(
          duration: 1000,
          splash: const FlutterLogo(size: 2000),
          nextScreen: MyBottomMenu(user: user, uid: user.uid),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: PrimaryColor);
    }
  }
}
