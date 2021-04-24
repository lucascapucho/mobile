import 'package:flutter/material.dart';
import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:resumelife/widgets/drawerMenu.dart';

class TestePage extends StatefulWidget {
  TestePage({required Key key, required this.title}) : super(key: key);

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
