import 'package:flutter/material.dart';
import 'package:yt_player/src/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Downloader'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: VideoSearch());
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: Center(
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
      ),
    );
  }
}
