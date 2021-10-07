import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({
    Key? key,
    required this.suggestion,
    required this.onSuggestionPressed,
  }) : super(key: key);

  final String suggestion;
  final void Function() onSuggestionPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.search),
        title: Text(suggestion),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_upward_outlined),
          onPressed: onSuggestionPressed,
        ));
  }
}
