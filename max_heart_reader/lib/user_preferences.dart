import 'package:shared_preferences/shared_preferences.dart';

/*
*  Stores personal information which includes user's
*  name, age, gender, height and weight using shared_preferences package.
*/

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyName = '';
  static const _keyAge = '';
  static const _keyGender = '';
  static const _keyHeight = '';
  static const _keyWeight = '';

  static Future init() async {
      // pesonalInfo exists
      if (await checkIfDataExists()) return;

      // personalInfo dont exist
      _preferences = await SharedPreferences.getInstance();
  }


  static Future setName(String name) async {
    return await _preferences.setString(_keyName, name);
  }
  static String? getName() => _preferences.getString(_keyName);

  static Future setAge(String age) async =>
      await _preferences.setString(_keyAge, age);
  static String? getAge() => _preferences.getString(_keyAge);

  static Future setGender(String gender) async =>
      await _preferences.setString(_keyGender, gender);
  static String? getGender() => _preferences.getString(_keyGender);

  static Future setHeight(String height) async =>
      await _preferences.setString(_keyGender, height);
  static String? getHeight() => _preferences.getString(_keyHeight);

  static Future setWeight(String weight) async =>
      await _preferences.setString(_keyWeight, weight);
  static String? getWeight() => _preferences.getString(_keyWeight);


  static Future<bool> checkIfDataExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dataExists = prefs.containsKey('key');

    return dataExists;
  }

}
