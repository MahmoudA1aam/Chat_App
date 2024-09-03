import 'package:shared_preferences/shared_preferences.dart';

class ShareData {
  static Future savedName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
  }
  static Future savedEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
  }

  static Future getDataId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString("name");
    return name;
  }

}

class DataUser {
  String email;

  String name;

  DataUser({required this.email, required this.name});

}
