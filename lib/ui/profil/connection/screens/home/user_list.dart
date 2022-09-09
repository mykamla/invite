import 'package:flutter/material.dart';
import 'package:myliveevent/ui/profil/connection/models/user.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUserData>>(context);
    return ListView.builder(
        itemCount:users.length,
        itemBuilder: (context, index) {
          return UserTile(users[index]);
        }
    );
  }
}

class UserTile extends StatelessWidget {
  final AppUserData user;

  UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.only(top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
        child: ListTile(
          title: Text(user.name),
          subtitle: Text('Drink ${user.waterCounter} water of glass'),
        ),
      ),
    );
  }
}



