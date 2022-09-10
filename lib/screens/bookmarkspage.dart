import 'package:browser/modals/bookmarks_modal.dart';
import 'package:browser/screens/searchpage.dart';
import 'package:browser/utils/functions/on_long_press_on_site_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<BookmarksModal> bookmarksList = [];

  Future<void> refresh() async {
    final fetchedData = await BookmarksModal.getList();
    setState(() => bookmarksList = fetchedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: FutureBuilder<List<BookmarksModal>>(
        future: BookmarksModal.getList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            bookmarksList = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () => refresh(),
              child: bookmarklist(bookmarksList),
            );
          } else {
            return const Center(
              child: Text("Bookmarks is Empty"),
            );
          }
        },
      ),
    );
  }

  ListView bookmarklist(List<BookmarksModal> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => ListTile(
        leading: data[index].favicon.isNotEmpty
            ? Image(
                width: 32,
                alignment: Alignment.center,
                image: CachedNetworkImageProvider(data[index].favicon),
              )
            : Image.asset('assets/favicon.png', width: 32),
        title: Text(data[index].title),
        subtitle: Text(data[index].url),
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(initialUrl: data[index].url),
          ),
        ),
        onLongPress: () => onLongPressOnSiteIcon(
          context,
          data[index].url,
          () => BookmarksModal.removeFromBookmark(index).then((result) {
            if (result) {}
          }),
        ),
      ),
    );
  }
}
