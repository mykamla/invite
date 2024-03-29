import 'package:flutter/material.dart';
import 'package:myliveevent/model/user.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/ui/profil/connection/models/user.dart';
import 'package:myliveevent/ui/profil/connection/screens/home/user_list.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/ui/profil/connection/services/database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    return StreamProvider<List<User>>.value(
      initialData: [],
      value: database.users,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          title: Text('Water Social'),
          actions: <Widget>[
            StreamBuilder<User>(
              stream: database.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User? userData = snapshot.data;
                  if (userData == null) return Loading();
                  return TextButton.icon(
                    icon: Icon(
                      Icons.wine_bar,
                      color: Colors.white,
                    ),
                    label: Text('drink', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                   //   await database.saveUser(userData.nom!);
                    },
                  );
                } else {
                  return Loading();
                }
              },
            ),
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text('logout', style: TextStyle(color: Colors.white)),
              onPressed: () async {
             //   await _auth.signOut();
              },
            )
          ],
        ),
        body: UserList(),
      ),
    );
  }
}
