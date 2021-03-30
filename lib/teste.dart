import 'package:flutter/material.dart';

import 'Widget/backgroundContainer.dart';
import 'Widget/drawerMenu.dart';

class TestePage extends StatefulWidget {
  TestePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<TestePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("My notes"),
        backgroundColor: Colors.transparent,
        actions: [],
        // elevation: .0,
      ),
      drawer: DrawerMenu(),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          TextButton(child: Text("Open editor"), onPressed: () {}),
        ]),
      ),
    );
  }
}
