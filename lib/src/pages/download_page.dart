import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_player/src/services/download_list.dart';
import 'package:yt_player/src/shared/download_card.dart';

class DownloadPage extends ConsumerWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final downloadList = watch(downloadListStateProvider);

    if (downloadList.state.isEmpty) {
      return const Center(
        child: Text("Your downloads will appear here."),
      );
    }

    return ListView.builder(
      itemCount: downloadList.state.length,
      itemBuilder: (context, index) {
        final downloadState =
            ChangeNotifierProvider((ref) => downloadList.state[index]);
        return DownloadCard(
          downloadState: downloadState,
        );
      },
    );
  }
}
