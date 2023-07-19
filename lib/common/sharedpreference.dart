import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static late final SharedPreferences userPref;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    userPref = await SharedPreferences.getInstance();
    return userPref;
  }

  static void setUserPreferences(User user, String? idToken) async {
    Map<String, dynamic>? idMap = parseJwt(idToken!);

    final String firstName = idMap?["given_name"];
    final String lastName = idMap?["family_name"];

    userPref.setString("UID", user.uid);
    userPref.setString("Email", user.email ?? '');
    userPref.setString("Name", user.displayName ?? '');
    userPref.setString("firstName", firstName);
    userPref.setString("lastName", lastName);
    userPref.setString("photoUrl", user.photoURL ?? '');
    userPref.setBool('isLoggedIn', true);
  }

  static void removeUserPreferences() async {
    userPref.setBool('isLoggedIn', false);
    await userPref.clear();
  }

  static bool isLoggedIn() {
    return userPref.getBool('isLoggedIn') ?? false;
  }

  static String getUID() {
    return userPref.getString('UID')!;
  }

  static String getEmail() {
    return userPref.getString('Email')!;
  }

  static String getName() {
    return userPref.getString('Name')!;
  }

  static String getFirstName() {
    return userPref.getString('firstName')!;
  }

  static String getLastName() {
    return userPref.getString('lastName')!;
  }

  static String getPhotoUrl() {
    return userPref.getString('photoUrl')!;
  }

  static Map<String, dynamic>? parseJwt(String token) {
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }
}
