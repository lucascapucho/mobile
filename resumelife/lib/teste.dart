import 'package:flutter/material.dart';

void main() {
  runApp(BaseLayout());
}

class BaseLayout extends StatefulWidget {
  BaseLayout({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple),
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
