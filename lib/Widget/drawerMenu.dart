import 'package:flutter/material.dart';
import 'package:resumelife/feedPage.dart';

import 'package:resumelife/notePage.dart';
import 'package:resumelife/profilePage.dart';
import 'package:resumelife/welcomePage.dart';

class DrawerMenu extends StatefulWidget {
  DrawerMenu({Key key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Color color;

  @override
  void initState() {
    super.initState();
    color = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.purple.shade800,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade800,
              ),
              accountEmail:
                  Text("user@mail.com", style: TextStyle(color: Colors.white)),
              accountName:
                  Text("Lucas Araujo", style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("LA", style: TextStyle(color: Color(0xffe46b10))),
              ),
            ),
            new ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text("Profile", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("My notes", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NotePage()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.share, color: Colors.white),
              title:
                  Text("Global notes", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedPage()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text("Log out", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
