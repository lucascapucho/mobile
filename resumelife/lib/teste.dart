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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Background Image - FlutterCorner"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/08/28/16/38/stars-912134_960_720.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
