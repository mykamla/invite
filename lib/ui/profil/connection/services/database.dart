import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myliveevent/model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(String name) async {
    return await userCollection.doc(uid).set({'name': name});
  }
  Future<void> saveUserPhoto(String name) async {
    return await userCollection.doc(uid).set({'photo': name});
  }

  User _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return User(
      uid: uid,
      nom: data['name'],
      photo: data['photo']
    );
  }

  Stream<User> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  List<User> _userListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
