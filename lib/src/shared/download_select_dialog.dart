import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/services/download_manager.dart';

class DownloadSelectDialog extends StatelessWidget {
  const DownloadSelectDialog({
    Key? key,
    required this.manifest,
    required this.videoName,
  }) : super(key: key);

  final StreamManifest manifest;
  final String videoName;

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
          for (var videoStream in manifest.muxed.sortByVideoQuality())
            if (videoStream.container.name == "mp4")
              InkWell(
                onTap: () async {
                  final state = await _downloadService.downloadMuxed(
                      videoStream, videoName);
                  Navigator.of(context).pop(state);
                },
                child: ListTile(
                    leading: const Icon(Icons.movie_creation_outlined),
                    title: Text(
                        "${videoStream.size.totalMegaBytes.toStringAsFixed(1)}MB ${videoStream.qualityLabel}"),
                    subtitle: Text(
                      "${videoStream.videoResolution} | MP4",
                      style: const TextStyle(color: Colors.white70),
                    )),
              ),
          const Divider(),
          const ListTile(
            title: Text("Audio Streams"),
          ),
          for (var audioStream in manifest.audio)
            InkWell(
              onTap: () async {
                final state = await _downloadService.downloadAudio(
                    audioStream, videoName);
                Navigator.of(context).pop(state);
              },
              child: ListTile(
                leading: const Icon(Icons.music_note_outlined),
                title: Text(
                    "${audioStream.size.totalMegaBytes.toStringAsFixed(1)}MB"),
                subtitle: Text(
                  "${audioStream.bitrate} | MP3",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    ));
  }
}
