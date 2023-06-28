import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyName = 'name';
  static const _keyAge = 'age';
  static const _keyGender = 'gender';
  static const _keyHeight = 'height';
  static const _keyWeight = 'weight';

  static Future init() async {
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
      await _preferences.setString(_keyHeight, height); // Corrected this line
  static String? getHeight() => _preferences.getString(_keyHeight);

  static Future setWeight(String weight) async =>
      await _preferences.setString(_keyWeight, weight);
  static String? getWeight() => _preferences.getString(_keyWeight);
}
