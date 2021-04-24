import 'package:flutter/material.dart';

import 'package:resumelife/screens/editNotePage.dart';
import 'package:resumelife/screens/newNotePage.dart';

import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:resumelife/widgets/drawerMenu.dart';

class NotePage extends StatefulWidget {
  NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Widget _myCard(BuildContext context, String title, String subtitle,
      String author, String publishData) {
    return new Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.share),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditNotePage()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        // elevation: .0,
        title: Text('My notes'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewNotePage()));
              },
              child: Icon(
                Icons.add_box,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          ListView(
            children: <Widget>[
              // Padding(padding: EdgeInsets.all(15.0)),
              _myCard(context, 'Title 1', 'Subtitle 1', 'Author 1', '29/03'),
              _myCard(context, 'Title 2', 'Subtitle 2', 'Author 2', '29/03'),
              _myCard(context, 'Title 3', 'Subtitle 3', 'Author 3', '29/03'),
            ],
          ),
        ]),
      ),
    );
  }
}
