import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text('GPS Demo'),
          centerTitle: true,
        ),
        body: Home(),
      ),
    );
  }
}
