import 'package:browser/modals/favourite_site_modal.dart';
import 'package:browser/screens/searchpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/functions/on_long_press_on_site_icon.dart';

class FavouriteSitesGrid extends StatelessWidget {
  const FavouriteSitesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      sliver: FutureBuilder(
        future: FavouriteSitesModal.getList(),
        builder: (context, AsyncSnapshot<List<FavouriteSitesModal>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverList(
              delegate: SliverChildListDelegate.fixed([
                Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ]),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    favouriteSiteBox(context, snapshot.data![index], index),
                childCount: snapshot.data!.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
            );
          } else {
            return const SliverList(
              delegate: SliverChildListDelegate.fixed([]),
            );
          }
        },
      ),
    );
  }

  Widget favouriteSiteBox(
      BuildContext context, FavouriteSitesModal site, int index) {
    return InkWell(
      onTap: () => visitSite(context, site.url),
      onLongPress: () => onLongPressOnSiteIcon(
        context,
        site.url,
        () => FavouriteSitesModal.removeToFavorite(index),
      ),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            site.favicon.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: site.favicon,
                    height: 24,
                    errorWidget: (_, e, d) => Image.asset('assets/favicon.png'),
                  )
                : Image.asset('assets/favicon.png', height: 24),
            Text(
              site.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

visitSite(BuildContext context, url) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchPage(initialUrl: url),
    ),
  );
}
