import 'package:flutter/material.dart';
import 'package:yt_player/src/screens/search_suggestions.dart';
import 'package:yt_player/src/screens/video_list_screen.dart';
import 'package:yt_player/src/services/youtubedl_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var showSearch = false;
  var suggestions = <String>[];
  final _query = TextEditingController();
  final _queryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _query.addListener(() async {
      try {
        var suggestions = await getSearchSuggestions(_query.text);
        setState(() {
          this.suggestions = suggestions;
        });
      } catch (e) {
        setState(() {
          suggestions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _query.dispose();
  }

  void _showSearch() {
    setState(() {
      showSearch = true;
      _queryFocusNode.requestFocus();
    });
  }

  void _hideSearch() {
    setState(() {
      showSearch = false;
      _query.clear();
      suggestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showSearch
            ? TextField(
                focusNode: _queryFocusNode,
                controller: _query,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search YouTube',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
              )
            : const Text('YouTube Downloader'),
        actions: [
          IconButton(
              onPressed: () {
                if (showSearch) {
                  _hideSearch();
                } else {
                  _showSearch();
                }
              },
              icon: Icon(showSearch ? Icons.close : Icons.search_rounded))
        ],
      ),
      body: showSearch
          ? SearchSuggestions(
              suggestions,
              onTap: (suggestion) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoListScreen(suggestion),
                ));
              },
            )
          : const Center(
              child: Text("Hello"),
            ),
    );
  }
}
