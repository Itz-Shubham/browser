import 'package:browser/modals/bookmarks_modal.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'menu_modalbottomsheet.dart';

class SearchPageBorromBar extends StatelessWidget {
  final WebViewController webViewController;
  final Function onSearchTap;
  const SearchPageBorromBar({
    Key? key,
    required this.webViewController,
    required this.onSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: Theme.of(context).iconTheme,
      unselectedIconTheme: Theme.of(context).iconTheme,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          label: 'Go back',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_forward_ios_rounded),
          label: 'Go forward',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border_rounded),
          label: 'Bookmark',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_vert),
          label: 'More',
        ),
      ],
      onTap: (index) async {
        switch (index) {
          case 0:
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No back history')),
              );
            }
            break;
          case 1:
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No next history')),
              );
            }
            break;
          case 2:
            onSearchTap();
            break;
          case 3:
            String title = await webViewController.getTitle() ?? '';
            String favicon = '';
            String url = await webViewController.currentUrl() ?? '';
            BookmarksModal.addToBookmarks(BookmarksModal(title, favicon, url));
            break;
          case 4:
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              builder: (context) => MenuModalBottomSheet(
                webViewController: webViewController,
              ),
            );
            break;
          default:
            throw UnimplementedError('index: $index is not implemented');
        }
      },
    );
  }
}
