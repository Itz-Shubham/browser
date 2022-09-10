import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksModal {
  final String title, favicon, url;
  BookmarksModal(this.title, this.favicon, this.url);

  Map<String, String> toJson() {
    return {"title": title, "favicon": favicon, "url": url};
  }

  static Future<List<BookmarksModal>> getList() async {
    List<BookmarksModal> list = [];

    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('bookmarks') ?? '[]';
    final List sites = jsonDecode(jsonString);
    for (Map<String, dynamic> site in sites) {
      list.add(
        BookmarksModal(site['title'], site['favicon'], site['url']),
      );
    }

    return list;
  }

  static Future<bool> addToBookmarks(BookmarksModal site) async {
    final pref = await SharedPreferences.getInstance();

    try {
      final bookmarkSites = await BookmarksModal.getList();
      if (!bookmarkSites.any((item) => item.url == site.url)) {
        bookmarkSites.add(site);
        final jsonString = jsonEncode(bookmarkSites);
        final result = await pref.setString('bookmarks', jsonString);
        if (result) {
          Fluttertoast.showToast(msg: "Added to Bookmarks");
        }
        return result;
      } else {
        Fluttertoast.showToast(msg: "Already exist in Bookmarks list");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeFromBookmark(int index) async {
    final pref = await SharedPreferences.getInstance();
    final bookmarkSites = await BookmarksModal.getList();
    try {
      bookmarkSites.removeAt(index);
      final jsonString = jsonEncode(bookmarkSites);
      final result = await pref.setString('bookmarks', jsonString);
      Fluttertoast.showToast(msg: "Removed successfully");
      return result;
    } catch (e) {
      return false;
    }
  }
}
