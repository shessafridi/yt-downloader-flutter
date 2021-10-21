import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/pages/download_page.dart';
import 'package:yt_player/src/pages/no_video_selected_page.dart';
import 'package:yt_player/src/pages/video_select_page.dart';
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('YouTube Downloader'),
              actions: [
                IconButton(
                    onPressed: () async {
                      final video = await showSearch(
                          context: context, delegate: VideoSearch());
                      if (video == null) return;
                      setState(() {
                        selectedVideo = video;
                        getManifest = getVideoStreamManifest(video);
                        DefaultTabController.of(context)?.animateTo(0);
                      });
                    },
                    icon: const Icon(Icons.search_rounded))
              ],
            ),
            bottomNavigationBar: const TabBar(
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(Icons.download_for_offline_outlined),
                  text: "Downloads",
                ),
              ],
            ),
            body: TabBarView(
              children: [
                if (selectedVideo == null)
                  const NoVideoSelectedPage()
                else
                  VideoSelectedPage(
                      onDissmissed: (direction) {
                        setState(() {
                          selectedVideo = null;
                          getManifest = null;
                        });
                      },
                      getManifest: getManifest,
                      selectedVideo: selectedVideo),
                const DownloadPage()
              ],
            )));
  }
}
