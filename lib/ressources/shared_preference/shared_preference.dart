import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

class SharedPreferenceData {
  static init() async {
    prefs = await SharedPreferences.getInstance();
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
