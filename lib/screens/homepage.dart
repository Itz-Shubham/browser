import 'package:flutter/material.dart';

import '../widgets/favourite_sites_grid.dart';
import '../widgets/homepage_search.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              HomepageSearch(),
            ]),
          ),
          FavouriteSitesGrid(),
        ],
      ),
    );
  }
}




// ! News section
// SliverList(
//   delegate: SliverChildListDelegate.fixed([
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Text(
//         "Today's News",
//         style: Theme.of(context).textTheme.headline6,
//         textAlign: TextAlign.center,
//       ),
//     ),
//     const Divider(indent: 16, endIndent: 16),
//   ]),
// ),
// const HomepageNewsSection()