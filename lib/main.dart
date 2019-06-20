import 'package:flutter/material.dart';

import 'package:flutter_codex/routes/login.dart';
import 'package:flutter_codex/routes/profile.dart';
import 'package:flutter_codex/routes/feed.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Codex',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      routes: {
        '/': (context) => Login(),
        '/profile': (context) => Profile(),
        '/feed': (context) => Feed(),
      },
    );
  }
}
