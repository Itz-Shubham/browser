import 'package:flutter/material.dart';

import '../screens/bookmarkspage.dart';
import '../screens/historypage.dart';
import '../screens/settingspage.dart';

class HomepageMoreOptionButton extends StatelessWidget {
  const HomepageMoreOptionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: () => showGeneralDialog(
          context: context,
          barrierLabel: "homepageMenu",
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          transitionDuration: const Duration(milliseconds: 100),
          pageBuilder: (_, __, ___) {
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                right: 8,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: menu(context),
              ),
            );
          },
          transitionBuilder: (_, anim, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: anim,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
        splashRadius: 24,
        icon: const Icon(Icons.more_vert_rounded),
      ),
    );
  }

  Widget menu(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        width: 200,
        child: Wrap(
          children: [
            const SizedBox(
              height: 48,
              child: Center(
                child: Text(
                  "Menu",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const Divider(height: 0, indent: 10, endIndent: 10),
            ListTile(
              leading: const Icon(Icons.bookmarks_rounded),
              title: const Text("Bookmarks"),
              onTap: () => pushTo(context, const BookmarksPage()),
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text("History"),
              onTap: () => pushTo(context, const HistoryPage()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text("Settings"),
              onTap: () => pushTo(context, const SettingsPage()),
            ),
          ],
        ),
      ),
    );
  }

  void pushTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
