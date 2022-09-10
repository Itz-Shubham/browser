import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsPage extends StatefulWidget {
  final WebViewController? webViewController;
  const SettingsPage({Key? key, this.webViewController}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (widget.webViewController != null)
            MyListTile(
              lable: "Clear Cache",
              onTap: () => clearCache(context),
            ),
          MyListTile(
            lable: "Delete History",
            onTap: () => clearHistory(context),
          ),
        ],
      ),
    );
  }

  ButtonStyle style({Color? primary}) {
    return ElevatedButton.styleFrom(
      primary: primary ?? Theme.of(context).primaryColorLight,
      elevation: 0,
    );
  }

  clearHistory(BuildContext context) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Do you really want to clear all history"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: style(),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();
                final removed = await pref.remove('history');
                if (removed) {
                  if (mounted) Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Deleted all history");
                }
              },
              style: style(primary: Colors.red),
              child: const Text("Yes"),
            ),
          ],
        ),
      );

  clearCache(BuildContext context) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Clear websites cache"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: style(),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.webViewController?.clearCache();
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Cleared cache");
              },
              style: style(primary: Colors.red),
              child: const Text("Yes"),
            ),
          ],
        ),
      );
}

class MyListTile extends StatelessWidget {
  final String lable;
  final Function onTap;
  final Widget? traling;
  const MyListTile({
    Key? key,
    required this.lable,
    required this.onTap,
    this.traling,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lable,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            traling ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
          ],
        ),
      ),
    );
  }
}
