import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HistoryModal {
  final String title, url;
  HistoryModal(this.title, this.url);

  Map<String, String> toJson() => {"title": title, "url": url};

  static Future<List<HistoryModal>> getHistory() async {
    List<HistoryModal> list = [];
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString('history') ?? '[]';
    final List sites = jsonDecode(jsonString);

    for (Map<String, dynamic> site in sites) {
      list.add(HistoryModal(site['title'], site['url']));
    }
    return list;
  }

  static Future<bool> addToHistory(WebViewController controller) async {
    final pref = await SharedPreferences.getInstance();
    final String title = await controller.getTitle() ?? '';
    final String url = await controller.currentUrl() ?? '';

    if (title.isNotEmpty && url.isNotEmpty) {
      try {
        final histories = await HistoryModal.getHistory();
        histories.insert(0, HistoryModal(title, url));
        if (histories.length > 100) {
          for (var i = 100; i < histories.length; i++) {
            histories.removeAt(i);
          }
        }
        final jsonString = jsonEncode(histories);
        final result = await pref.setString('history', jsonString);

        return result;
      } catch (e) {
        // print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> removeFromHistory(int index) async {
    final pref = await SharedPreferences.getInstance();
    final histroySites = await HistoryModal.getHistory();
    try {
      histroySites.removeAt(index);
      final jsonString = jsonEncode(histroySites);
      final result = await pref.setString('history', jsonString);
      Fluttertoast.showToast(msg: "Removed successfully");
      return result;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearHistory() async {
    final pref = await SharedPreferences.getInstance();
    final result = await pref.remove('history');
    return result;
  }
}
