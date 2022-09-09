import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPrefferences{

  Future<void> setUser(Map<String, dynamic> user) async {
    print('ok list megX');
    print(user);
    final String encodedData = json.encode(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', encodedData);
  }

  Future<Map<String, dynamic>> getUser() async {
    print('ok list megX0');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    print('ok list megX');
    print(user);
    return json.decode(user!);
  }

  Future<void> setEvent(Map<String, dynamic> event) async {
    print('ok list megX');
    print(event);
    final String encodedData = json.encode(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('event', encodedData);
  }

  Future<Map<String, dynamic>> getEvent() async {
    print('ok list megX0');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? event = prefs.getString('event');

    print('ok list megX');
    print(event);
    return json.decode(event!);
  }

}