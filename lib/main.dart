import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myliveevent/provider/eventState.dart';
import 'package:myliveevent/theme/myTheme.dart';
import 'package:myliveevent/ui/event/live/broacast.dart';
import 'package:myliveevent/ui/event/live/live.dart';
import 'package:myliveevent/ui/menu/my_bubble_bottom_bar.dart';
import 'package:myliveevent/ui/profil/connection/auth.dart';
import 'package:myliveevent/ui/profil/login.dart';
import 'package:myliveevent/ui/profil/register.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myliveevent/provider/chatState.dart';
import 'package:provider/provider.dart';
import 'package:myliveevent/ui/chat/chatUI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kDebugMode ? false : true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChatState()),
          ChangeNotifierProvider(create: (context) => EventState()),
        ],
        child: MaterialApp(
          title: 'APP Dec',
          theme: ThemeData(
            primaryColor: PrimaryColor,
            primarySwatch: PrimarySwatch,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
          debugShowCheckedModeBanner: false,
        ));
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //  final arguments = settings.arguments as Map<String, dynamic>;
    switch(settings.name) {
      case '/' :
       // return MaterialPageRoute(builder: (context) => MyBubbleBottomBar());
        return MaterialPageRoute(builder: (context) => Auth());
      case '/events':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> ChatUI(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      case '/login':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> Login(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
        case '/register':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> Register(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      case '/broadcast':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> Broadcast(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      case '/live':
        final argument = settings.arguments as String;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> Live(channelName: argument),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text("Error"), centerTitle: true, backgroundColor: Colors.red),
                body: const Center(
                  child: Text("Page not found"),
                )
            )
        );
    }
  }
}

