import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myliveevent/model/app_user.dart';
import 'package:myliveevent/provider/chat_state.dart';
import 'package:myliveevent/provider/event_state.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/ui/chat/chatpage.dart';
import 'package:myliveevent/ui/event/add_event.dart';
import 'package:myliveevent/ui/event/events_list.dart';
import 'package:myliveevent/ui/event/map/map_page.dart';
import 'package:myliveevent/ui/event/video/read_video.dart';
import 'package:myliveevent/ui/event/video/upload_video.dart';
import 'package:myliveevent/ui/menu/my_bottom_menu.dart';
import 'package:myliveevent/ui/profil/authenticate/reset_password_screen.dart';
import 'package:myliveevent/ui/profil/connection/auth.dart';
import 'package:provider/provider.dart';
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
          ChangeNotifierProvider(create: (context) => AppUser('')),
          ChangeNotifierProvider(create: (context) => ChatState()),
          ChangeNotifierProvider(create: (context) => EventState()),
        ],
        child: MaterialApp(
          title: '',
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
      /*
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
        */
      case '/upload_video':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> UploadVideo(
                nom: arg['nom'], description: arg['description'], playlist: arg['playlist'], uidEvent: arg['uidEvent']??'', videoList: arg['videoList']??[]),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      case '/map':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> MapPage(uid: arg['uid'], email: arg['email'], nomUser: arg['nom'], photo: arg['photo']),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      case '/add_event':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> AddEvent(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
      case '/event_list':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> EventsList(event: arg['event']),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );
        case '/read_video':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> ReadVideo(
              nomEvent: arg['nomEvent'],
              videoLink: arg['videoLink'],
              oneVideoLink: arg['oneVideoLink'],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );

      case '/chat_page':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> ChatPage(
              email: arg['email'],
              uidEvent: arg['uidEvent'],
              nomUser: arg['nomUser'],
              nomEvent: arg['nomEvent'],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );

      case '/my_bottom_menu':
        final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> MyBottomMenu(
                user: arg['user'], uid: arg['uid']),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(curve: Curves.ease, parent: animation);
              return FadeTransition(
                opacity:animation,
                child: child,
              );
            }
        );

      case '/reset_password':
      //  final arg = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation)=> ResetPasswordScreen(),
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
