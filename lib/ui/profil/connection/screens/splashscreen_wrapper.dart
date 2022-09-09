import 'package:flutter/material.dart';
import 'package:myliveevent/ui/profil/connection/models/user.dart';
import 'package:myliveevent/ui/profil/connection/screens/authenticate/authenticate_screen.dart';
import 'package:myliveevent/ui/profil/connection/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return AuthenticateScreen();
    } else {
      return HomeScreen();
    }
  }
}
