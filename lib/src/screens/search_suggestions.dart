import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String suggestion)? onTap;
  const SearchSuggestions(this.suggestions, {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return InkWell(
          onTap: () {
            if (onTap != null) onTap!(suggestion);
          },
          child: ListTile(
            title: Text(suggestion),
          ),
        );
      },
    );
  }
}
