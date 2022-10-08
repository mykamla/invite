import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPrefferences{

  Future<void> setUid(int uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('uid', uid);
  }

  Future<int> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? uid = prefs.getInt('uid');
    return uid??0;
  }

  Future<void> setUser(Map<String, dynamic> user) async {
    final String encodedData = json.encode(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', encodedData);
  }

  Future<Map<String, dynamic>> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    return json.decode(user!);
  }

  Future<void> setEvent(Map<String, dynamic> event) async {
    final String encodedData = json.encode(event);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('event', encodedData);
  }

  Future<Map<String, dynamic>> getEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? event = prefs.getString('event');
    return json.decode(event!);
  }

}