import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class PreferenceManager {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static setFirstLaunch(bool value) {
    final SharedPreferences preferences = _prefs;
    preferences.setBool(kFirstLaunch, value);
  }

  static Future<bool> isFirstLaunch() async {
    final SharedPreferences preferences = _prefs;
    if (preferences.getBool(kFirstLaunch) != null) {
      return preferences.getBool(kFirstLaunch)??false;
    } else {
      return true;
    }
  }
  static String getUserEmail() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kUserEmail) ?? "null";
  }
  static String getUserName() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kUserName) ?? 'null';
  }
  static setUserID(String userID) {
    final SharedPreferences preferences = _prefs;
    preferences.setString(kUserId, userID);
  }
  static String getUserID() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kUserId) ?? "null";
  }
  static setAccessToken(String token) {
    final SharedPreferences preferences = _prefs;
    preferences.setString(kAccessToken, token);
  }

  static String getAccessToken() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kAccessToken) ?? "null";
  }

  static setRefreshToken(String token) {
    final SharedPreferences preferences = _prefs;
    preferences.setString(kRefreshToken, token);
  }

  static String getRefreshToken() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kRefreshToken) ?? "null";
  }

  static setUserEmail(String email) {
    final SharedPreferences preferences = _prefs;
    preferences.setString(kUserEmail, email);
  }
  static setUserName(String name){
    final SharedPreferences preferences =  _prefs;
    preferences.setString(kUserName, name);
  }
  static setUserRole(String role) {
    final SharedPreferences preferences = _prefs;
    preferences.setString(kUserRole, role);
  }
  static setUserCurrentRole(String role) {
    final SharedPreferences preferences = _prefs;
    preferences.setString(kUserCurrentRole, role);
  }
  static setProfileName(String profileName){
    final SharedPreferences preferences = _prefs;
    preferences.setString(kProfileName, profileName);
  }

  static bool getHasNotification() {
    final SharedPreferences preferences = _prefs;
    return preferences.getBool(kUnreadNotification)??false;
  }
  static String getUserCurrentRole() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kUserCurrentRole) != null
        ? preferences.getString(kUserCurrentRole)!
        : "null";
  }
  static String getProfileName() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kProfileName) ?? "null";
  }
  static String getUserRole() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kUserRole) != null
        ? preferences.getString(kUserRole)!
        : "null";
  }
  static String getUserImage() {
    final SharedPreferences preferences = _prefs;
    return preferences.getString(kUserImage) ?? "null";
  }
  static setUserImage(String userImage) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(kUSER_IMAGE, userImage);
  }

  static Future<String> getPhoneNumber() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(kPHONE_NUMBER) ?? "null";
  }
  static setPhoneNumber(String phoneNumber) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(kPHONE_NUMBER, phoneNumber);
  }

  static getDeviceID() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(kDEVICE_ID) ?? "null";
  }

  static setTempID(int id) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setInt(kId, id);
  }

  static Future<int> getTempID() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getInt(kId) ?? 1;
  }

  static setResID(String id) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(kResId, id);
  }

  static Future<String> getResID() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(kResId)??"";
  }

  static setDeliveryLat(String Lat) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(kLat, Lat);
  }

  static Future<String> getDeliveryLat() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(kLat)??"";
  }

  static setDeliveryLng(String Lng) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(kLng, Lng);
  }

  static Future<String> getDeliveryLng() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(kLng)??"";
  }

  static setDeliveryAddress(String address) async {
    final SharedPreferences preferences = await _prefs;
    preferences.setString(kAddress, address);
  }

  static Future<String> getDeliveryAddress() async {
    final SharedPreferences preferences = await _prefs;
    return preferences.getString(kAddress)??"";
  }

  static deleteUserBasicInfo() async {
    final SharedPreferences preferences = await _prefs;
    preferences.remove(kAccessToken);
    preferences.remove(kRefreshToken);
    preferences.remove(kProfileName);
    preferences.remove(kUserEmail);
    preferences.remove(kUserName);
    preferences.remove(kUserId);
    preferences.remove(kUserRole);
  }
}