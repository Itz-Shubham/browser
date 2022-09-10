import 'package:browser/screens/bookmarkspage.dart';
import 'package:browser/screens/historypage.dart';
import 'package:browser/screens/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../modals/favourite_site_modal.dart';

class MenuModalBottomSheet extends StatelessWidget {
  final WebViewController webViewController;
  const MenuModalBottomSheet({Key? key, required this.webViewController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GridView(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 90,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        children: [
          ModalBottomSheetOption(
            icon: const Icon(Icons.star_border_purple500_rounded),
            lable: "Add To Favourite",
            onTap: addToFavourite,
          ),
          ModalBottomSheetOption(
            icon: const Icon(Icons.bookmarks_rounded),
            lable: "Bookmarks",
            onTap: () => pushToBookmarksPage(context),
          ),
          ModalBottomSheetOption(
            icon: const Icon(Icons.history_rounded),
            lable: "History",
            onTap: () => pushToHistoryPage(context),
          ),
          ModalBottomSheetOption(
            icon: const Icon(Icons.settings_rounded),
            lable: "Settings",
            onTap: () => pushToSettingsPage(context),
          ),
          ModalBottomSheetOption(
            icon: const Icon(Icons.exit_to_app_rounded),
            lable: "Exit",
            onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          ),
          ModalBottomSheetOption(
            icon: const Icon(Icons.share_rounded),
            lable: "Share",
            onTap: () async => Share.share(
              await webViewController.currentUrl() ?? '',
            ),
          ),
          ModalBottomSheetOption(
            icon: const Icon(Icons.refresh_rounded),
            lable: "Refresh",
            onTap: () => webViewController.reload(),
          ),
        ],
      ),
    );
  }

  Future<void> addToFavourite() async {
    String title = await webViewController.getTitle() ?? '';
    String favicon = '';
    String url = await webViewController.currentUrl() ?? '';
    FavouriteSitesModal.addToFavorite(FavouriteSitesModal(title, favicon, url));
  }

  void pushToBookmarksPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookmarksPage(),
      ),
    );
  }

  void pushToHistoryPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryPage(),
      ),
    );
  }

  void pushToSettingsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          webViewController: webViewController,
        ),
      ),
    );
  }
}

class ModalBottomSheetOption extends StatelessWidget {
  final String? lable;
  final Widget? icon;
  final Function onTap;
  const ModalBottomSheetOption({
    Key? key,
    this.lable,
    this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: icon,
              ),
            ),
            Text(
              lable ?? '',
              style: const TextStyle(fontSize: 10),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
