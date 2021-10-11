import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/services/download_manager.dart';

class DownloadSelectDialog extends StatelessWidget {
  const DownloadSelectDialog({
    Key? key,
    required this.manifest,
  }) : super(key: key);

  final StreamManifest manifest;

  @override
  Widget build(BuildContext context) {
    final _downloadService = context.read(downloadServiceProvider);

    return Dialog(
        child: SingleChildScrollView(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          const ListTile(
            title: Text("Video Streams"),
          ),
          for (var videoStream in manifest.video)
            ListTile(
              title: Text(
                  videoStream.size.totalMegaBytes.toStringAsFixed(1) + "MB"),
            ),
          const Divider(),
          const ListTile(
            title: Text("Audio Streams"),
          ),
          for (var audioStream in manifest.audio)
            InkWell(
              onTap: () async {
                final state =
                    await _downloadService.downloadAudio(audioStream, "Temp");
                Navigator.of(context).pop(state);
              },
              child: ListTile(
                title: Text(
                    audioStream.size.totalMegaBytes.toStringAsFixed(1) + "MB"),
              ),
            ),
        ],
      ),
    ));
  }
}
