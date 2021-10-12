import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_player/src/models/download_state.dart';

class DownloadCard extends ConsumerWidget {
  const DownloadCard({Key? key, required this.downloadState}) : super(key: key);

  final ChangeNotifierProvider<DownloadState> downloadState;

  Widget _buildTrailing(DownloadState state) {
    if (state.status == DownloadStatus.notStarted) {
      return IconButton(
          onPressed: () {
            state.startDownload();
          },
          icon: const Icon(Icons.download));
    }
    if (state.status == DownloadStatus.active ||
        state.status == DownloadStatus.processing) {
      return CircularProgressIndicator(
        value: state.status == DownloadStatus.processing
            ? null
            : (state.progress / 100),
      );
    }
    return IconButton(onPressed: () {}, icon: const Icon(Icons.download_done));
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(downloadState);
    return ListTile(
      title: Text(state.fileName),
      subtitle: Text(
        state.progress.toStringAsFixed(1) + '%',
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: _buildTrailing(state),
    );
  }
}
