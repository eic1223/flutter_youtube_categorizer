import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController {
  // ADD (SAVE)
  static addString(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  addInt(String key, int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }

  addBool(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  // GET
  static getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(key);
    return boolValue;
  }

  getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key);
    return intValue;
  }

  // REMOVE
  removeByKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getKeys().contains(key)) {
      prefs.remove(key);
    }
  }
}
