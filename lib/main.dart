import 'package:flutter/material.dart';

import 'ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Raspberry pi',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
