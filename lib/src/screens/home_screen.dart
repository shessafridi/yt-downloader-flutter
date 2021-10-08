import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/screens/search_screen.dart';
import 'package:yt_player/src/services/youtubedl_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Video? selectedVideo;
  Future<StreamManifest?>? getManifest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Downloader'),
        actions: [
          IconButton(
              onPressed: () async {
                final video =
                    await showSearch(context: context, delegate: VideoSearch());
                if (video == null) return;
                setState(() {
                  selectedVideo = video;
                  getManifest = getVideoStreamManifest(video);
                });
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: selectedVideo == null || getManifest == null
          ? const NoVideoSelectedPage()
          : FutureBuilder(
              future: getManifest,
              builder: (context, AsyncSnapshot<StreamManifest?> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.connectionState == ConnectionState.done) {
                  var manifest = snapshot.data!;
                  print("MANIFEST\n===========");
                  print(manifest.toString());
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          selectedVideo!.thumbnails.mediumResUrl,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(selectedVideo!.title),
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            child: const Text("Download"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      child: SingleChildScrollView(
                                    child: ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        const ListTile(
                                          title: Text("Video Streams"),
                                        ),
                                        for (var videoStream in manifest.video)
                                          ListTile(
                                            title: Text(videoStream
                                                    .size.totalMegaBytes
                                                    .toStringAsFixed(1) +
                                                "MB"),
                                          ),
                                        const Divider(),
                                        const ListTile(
                                          title: Text("Audio Streams"),
                                        ),
                                        for (var audioStream in manifest.audio)
                                          ListTile(
                                            title: Text(audioStream
                                                    .size.totalMegaBytes
                                                    .toStringAsFixed(1) +
                                                "MB"),
                                          ),
                                      ],
                                    ),
                                  ));
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Converting your video please wait.")
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class NoVideoSelectedPage extends StatelessWidget {
  const NoVideoSelectedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          "Start by searching for a video.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5!.apply(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
