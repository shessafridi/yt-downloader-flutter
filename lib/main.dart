import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yt_player/src/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          textTheme:
              GoogleFonts.rubikTextTheme().apply(bodyColor: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
