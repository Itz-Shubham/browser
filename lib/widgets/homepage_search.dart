import 'package:browser/screens/bookmarkspage.dart';
import 'package:browser/screens/searchpage.dart';
import 'package:browser/screens/settingspage.dart';
import 'package:flutter/material.dart';

import '../screens/historypage.dart';
import '../utils/homepage_header_curve.dart';
import 'homepage_more_option.dart';

class HomepageSearch extends StatelessWidget {
  const HomepageSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return ClipPath(
      clipper: HomepageHeaderCurve(),
      child: Container(
        height: deviceSize.height / 5 * 3,
        width: deviceSize.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/google.png', width: deviceSize.width / 2),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  ),
                  child: Container(
                    width: deviceSize.width - 50,
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Search"),
                        Icon(Icons.search_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: const HomepageMoreOptionButton(),
            ),
          ],
        ),
      ),
    );
  }
}
