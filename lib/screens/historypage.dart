import 'package:flutter/material.dart';

import '../modals/history_modal.dart';
import '../utils/functions/on_long_press_on_site_icon.dart';
import 'searchpage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryModal> history = [];

  Future<void> refresh() async {
    final fetchedData = await HistoryModal.getHistory();
    setState(() => history = fetchedData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryModal>>(
      future: HistoryModal.getHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("History")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          history = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text("History"),
            ),
            body: RefreshIndicator(
              onRefresh: () => refresh(),
              child: historyList(history),
            ),
            floatingActionButton: history.isNotEmpty
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.red,
                    onPressed: () => HistoryModal.clearHistory(),
                    label: const Text("Clear All"),
                  )
                : null,
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("History")),
            body: const Center(
              child: Text("History is Empty"),
            ),
          );
        }
      },
    );
  }

  Widget historyList(List<HistoryModal> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => ListTile(
        title:
            Text(data[index].url, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          data[index].title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(initialUrl: data[index].url),
          ),
        ),
        onLongPress: () => onLongPressOnSiteIcon(
          context,
          data[index].url,
          () => HistoryModal.removeFromHistory(index).then((result) {
            if (result) {}
          }),
        ),
      ),
    );
  }
}
