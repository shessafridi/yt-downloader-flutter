import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadSelectDialog extends StatelessWidget {
  const DownloadSelectDialog({
    Key? key,
    required this.manifest,
  }) : super(key: key);

  final StreamManifest manifest;

  @override
  Widget build(BuildContext context) {
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
            ListTile(
              title: Text(
                  audioStream.size.totalMegaBytes.toStringAsFixed(1) + "MB"),
            ),
        ],
      ),
    ));
  }
}
