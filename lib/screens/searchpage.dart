import 'dart:async';
import 'dart:io';

import 'package:browser/utils/functions/check_url.dart';
import 'package:browser/widgets/searchpage_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../modals/history_modal.dart';
import '../widgets/searchpage_webview.dart';

class SearchPage extends StatefulWidget {
  final String? initialUrl;
  const SearchPage({Key? key, this.initialUrl}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double loadingValue = 0;
  var webviewController = Completer<WebViewController>();
  final searchTextController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => webviewController.future.then((controller) async {
        if (await controller.canGoBack()) {
          await controller.goBack();
          return false;
        } else {
          return true;
        }
      }),
      child: Scaffold(
        appBar: searchBar(searchTextController.text),
        body: SearchpageWebview(
          controller: webviewController,
          initialUrl: widget.initialUrl,
          loading: (v) => setState(() => loadingValue = v),
          addHistoryFunction: () => webviewController.future.then(
            (controller) => HistoryModal.addToHistory(controller),
          ),
          currentUrl: (u) => setState(() => searchTextController.text = u),
        ),
        bottomNavigationBar: FutureBuilder<WebViewController>(
          future: webviewController.future,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return SearchPageBorromBar(
                webViewController: snapshot.data!,
                onSearchTap: () => focusNode.requestFocus(),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  AppBar searchBar(String url) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          autofocus: widget.initialUrl == null ? true : false,
          controller: searchTextController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            hintText: "Search or type web address",
            isDense: true,
            prefixIcon: SizedBox(
              width: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: searchTextController.text.isEmpty
                    ? Image.asset('assets/google_logo.png')
                    : searchTextController.text.startsWith('http://')
                        ? const Icon(Icons.warning_amber_rounded,
                            color: Colors.red)
                        : const Icon(Icons.lock_outline_rounded,
                            color: Colors.green),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                focusNode.requestFocus();
                searchTextController.clear();
              },
              icon: Icon(
                Icons.clear_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              splashRadius: 16,
            ),
          ),
          focusNode: focusNode,
          keyboardType: TextInputType.url,
          scrollPadding: EdgeInsets.zero,
          style: const TextStyle(fontSize: 16),
          textInputAction: TextInputAction.search,
          minLines: 1,
          onSubmitted: (v) => webviewController.future.then((controller) async {
            final isUrl = isValidUrl(url: url);
            if (isUrl) {
              controller.loadUrl(v);
            } else {
              controller.loadUrl(
                'https://www.google.com/search?q=${v.replaceAll(" ", '+')}',
              );
            }
          }),
        ),
      ),
      flexibleSpace: loadingValue < 1 && loadingValue > 0
          ? PreferredSize(
              preferredSize: const Size(double.infinity, 3),
              child: Align(
                alignment: Alignment.bottomCenter,
                child:
                    LinearProgressIndicator(value: loadingValue, minHeight: 3),
              ),
            )
          : null,
    );
  }
}
