import 'package:flutter/material.dart';

import '../../widgets/favourite_sites_grid.dart';

onLongPressOnSiteIcon(BuildContext context, String url, Function onRemove) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Wrap(
        children: [
          ListTile(
            title: const Text("Go to the site"),
            onTap: () {
              Navigator.pop(context);
              visitSite(context, url);
            },
          ),
          ListTile(
            title: const Text(
              "Remove from favourtites",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              onRemove();
            },
          ),
        ],
      ),
    ),
  );
}
