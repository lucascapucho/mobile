import 'package:flutter/material.dart';

import 'package:resumelife/screens/readOnlyPage.dart';
import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:resumelife/widgets/drawerMenu.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
              context, MaterialPageRoute(builder: (context) => ReadOnlyPage()));
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
        title: Text('Global notes'),
      ),
      drawer: DrawerMenu(),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, .0),
            child: TextField(
              style: TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xfff79c4f),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  suffixIcon: Icon(Icons.search, color: Color(0xfff79c4f)),
                  border: InputBorder.none,
                  hintText: 'Search here...',
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          ),
          ListView(
            padding: EdgeInsets.fromLTRB(.0, 75.0, .0, .0),
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
