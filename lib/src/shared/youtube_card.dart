import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeCard extends StatelessWidget {
  const YouTubeCard(
    this.video, {
    Key? key,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            video.thumbnails.mediumResUrl,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(video.title),
          )
        ],
      ),
    );
  }
}
