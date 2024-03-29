import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/ui/profil/authenticate/splashscreen_wrapper.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child: SplashScreenWrapper()
    );
  }
}
