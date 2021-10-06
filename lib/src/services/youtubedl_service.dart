import 'package:youtube_explode_dart/youtube_explode_dart.dart';

var _yt = YoutubeExplode();

Future<List<String>> getSearchSuggestions(String query) async {
  return _yt.search.getQuerySuggestions(query);
}

Future<SearchList> searchVideo(String query) async {
  return _yt.search.getVideos(query);
}

Future<Video> getVideoInfo(String url) async {
  return _yt.videos.get(url);
}
