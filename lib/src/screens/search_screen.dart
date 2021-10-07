import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_player/src/services/youtubedl_service.dart';
import 'package:yt_player/src/shared/search_tile.dart';
import 'package:yt_player/src/shared/youtube_card.dart';

class VideoSearch extends SearchDelegate<Video?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var listFuture = searchVideo(query);
    var listEnded = false;
    return query.isNotEmpty
        ? StatefulBuilder(
            builder: (context, setState) {
              return FutureBuilder(
                future: listFuture,
                builder: (context, AsyncSnapshot<SearchList?> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data?.isEmpty ?? false) {
                      return Center(
                          child: Text(
                        "No results",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .apply(color: Colors.white),
                      ));
                    }
                    return ListView.builder(
                      // shrinkWrap: true,
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index < snapshot.data!.length) {
                          final video = snapshot.data![index];
                          return InkWell(
                            child: YouTubeCard(video),
                            onTap: () {
                              close(context, video);
                            },
                          );
                        } else {
                          snapshot.data?.nextPage().then((value) {
                            if (value != null) {
                              setState(() {
                                snapshot.data?.addAll(value);
                                if (snapshot.data?.isEmpty ?? false) {
                                  listEnded = true;
                                }
                              });
                            }
                          });
                          if (listEnded) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("You have reached the end"),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Something horribly went wrong."));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          )
        : const Center(child: Text("Search Something"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isNotEmpty
        ? FutureBuilder(
            builder: (context, AsyncSnapshot<List<String>?> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final suggestion = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        query = suggestion;
                        showResults(context);
                      },
                      child: SearchTile(
                        suggestion: suggestion,
                        onSuggestionPressed: () {
                          query = suggestion;
                        },
                      ),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return const Center(child: CircularProgressIndicator());
            },
            future: getSearchSuggestions(query))
        : Container();
  }
}
