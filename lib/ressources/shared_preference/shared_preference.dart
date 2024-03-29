import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

class SharedPreferenceData {
  static init() async {
    prefs = await SharedPreferences.getInstance();
    // await saveToken(
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOjI4LCJpYXQiOjE2NjIyMzIyMDR9.coPkBW85BoxqR8RqegUWW8laNkbeLwGa9gsrj_uNdpQ");
    // await saveUserName("Mouh latch");
    // await saveCityId(11);
  }

  static saveTheme(String theme) async {
    await prefs.setString('theme', theme);
  }

  static String loadTheme() {
    return prefs.getString('theme') ?? "default";
  }

  static saveLocale(String locale) async {
    await prefs.setString('locale', locale);
  }

  static String loadLocale() {
    return prefs.getString('locale') ?? "";
  }

  static saveToken(String token) async {
    await prefs.setString('token', token);
  }

  static String? loadToken() {
    print(prefs.getString('token'));
    return prefs.getString('token');
  }

  static saveCityId(int cityId) async {
    await prefs.setInt('cityId', cityId);
  }

  static int? loadCityId() {
    return prefs.getInt('cityId');
  }

  static saveUserName(String userName) async {
    await prefs.setString('userName', userName);
  }

  static String loadUserName() {
    return prefs.getString('userName') ?? "";
  }

  static savePhone(String phone) async {
    await prefs.setString('phone', phone);
  }

  static String loadPhone() {
    return prefs.getString('phone') ?? "";
  }

  static saveNotificationPending(bool pending) async {
    await prefs.setBool('notificationPending', pending);
  }

  static bool loadNotificationPending() {
    return prefs.getBool('notificationPending') ?? false;
  }

  static saveNotificationMessagePending(bool pending) async {
    await prefs.setBool('notificationMessagePending', pending);
  }

  static bool loadNotificationMessagePending() {
    return prefs.getBool('notificationMessagePending') ?? false;
  }

  static saveLastReceivedNotificationDate(String date) {
    return prefs.setString('lastRecivedNotificationDate', date);
  }

  static String loadLastReceivedNotificationDate() {
    return prefs.getString('lastRecivedNotificationDate') ?? "";
  }

  static saveNotificationEnabled(bool enabled) {
    return prefs.setBool('notificationEnabled', enabled);
  }

  static bool loadNotificaionEnabled() {
    return prefs.getBool('notificationEnabled') ?? true;
  }

  static addToFavoriteAnnonces(int annonceId) async {
    var oldList = prefs.getStringList('favorites') ?? [];
    oldList.add(annonceId.toString());
    await prefs.setStringList('favorites', oldList);
  }

  static removeFromFavoriteAnnonces(int annonceId) async {
    var oldList = prefs.getStringList('favorites') ?? [];
    oldList.remove(annonceId.toString());
    await prefs.setStringList('favorites', oldList);
  }

  static List<int> loadFavoriteAnnonces() {
    return (prefs.getStringList('favorites') ?? [])
        .map((e) => int.parse(e))
        .toList();
  }
}
