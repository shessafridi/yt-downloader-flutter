import 'package:flutter/material.dart';

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
