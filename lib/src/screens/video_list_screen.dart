import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/services/youtubedl_service.dart';

class VideoListScreen extends StatefulWidget {
  final String query;
  const VideoListScreen(
    this.query, {
    Key? key,
  }) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  SearchList? _searchList;

  @override
  void initState() {
    super.initState();
    searchVideo(widget.query).then((value) {
      setState(() {
        _searchList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: _searchList == null
          ? const Text("Loading")
          : ListView.builder(
              itemBuilder: (context, index) {
                var video = _searchList![index];

                return Card(
                  child: Column(
                    children: [
                      Image.network(video.thumbnails.standardResUrl),
                      Text(video.title),
                      Text(video.author),
                    ],
                  ),
                );
              },
              itemCount: _searchList!.length,
            ),
    );
  }
}
