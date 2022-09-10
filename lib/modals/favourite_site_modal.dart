import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

String defaultJson =
    '[{"title":"Google","favicon":"https://www.google.com/favicon.ico","url":"https://www.google.com"},{"title":"Facebook","favicon":"https://www.facebook.com/favicon.ico","url":"https://www.facebook.com"},{"title":"Youtube","favicon":"https://www.youtube.com/favicon.ico","url":"https://www.youtube.com"},{"title":"Twitter","favicon":"https://twitter.com/favicon.ico","url":"https://twitter.com"},{"title":"Instagram","favicon":"https://instagram.com/favicon.ico","url":"https://instagram.com"},{"title":"Amazon","favicon":"https://www.amazon.com/favicon.ico","url":"https://www.amazon.com"},{"title":"Wikipedia","favicon":"https://en.wikipedia.org/favicon.ico","url":"https://en.wikipedia.org"},{"title":"Reddit","favicon":"https://www.reddit.com/favicon.ico","url":"https://www.reddit.com"}]';

class FavouriteSitesModal {
  final String title, favicon, url;

  FavouriteSitesModal(this.title, this.favicon, this.url);

  Map<String, String> toJson() {
    return {"title": title, "favicon": favicon, "url": url};
  }

  static Future<List<FavouriteSitesModal>> getList() async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('favouriteSites') ?? defaultJson;
    final List sites = jsonDecode(jsonString);
    List<FavouriteSitesModal> result = [];
    for (Map<String, dynamic> site in sites) {
      result.add(
        FavouriteSitesModal(site['title'], site['favicon'], site['url']),
      );
    }
    return result;
  }

  static Future<bool> addToFavorite(FavouriteSitesModal site) async {
    final pref = await SharedPreferences.getInstance();

    try {
      final favouriteSites = await FavouriteSitesModal.getList();
      if (!favouriteSites.any((item) => item.url == site.url)) {
        favouriteSites.add(site);
        final jsonString = jsonEncode(favouriteSites);
        final result = await pref.setString('favouriteSites', jsonString);
        if (result) {
          Fluttertoast.showToast(msg: "Added to Favourites List");
        }
        return result;
      } else {
        Fluttertoast.showToast(msg: "Already exist in Favourites List");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeToFavorite(int index) async {
    final pref = await SharedPreferences.getInstance();
    final favouriteSites = await FavouriteSitesModal.getList();
    try {
      favouriteSites.removeAt(index);
      final jsonString = jsonEncode(favouriteSites);
      final result = await pref.setString('favouriteSites', jsonString);
      Fluttertoast.showToast(msg: "Removed successfully");
      return result;
    } catch (e) {
      return false;
    }
  }
}
