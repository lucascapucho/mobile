import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resumelife/screens/feedPage.dart';

import 'package:resumelife/screens/notePage.dart';
import 'package:resumelife/screens/profilePage.dart';
import 'package:resumelife/screens/welcomePage.dart';
import 'package:share/share.dart';

class DrawerMenu extends StatefulWidget {
  final String uid;
  DrawerMenu(Type string, this.uid, {Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  late Color color;

  DatabaseReference usersRef =
      FirebaseDatabase.instance.reference().child("Users");

  @override
  void initState() {
    super.initState();
    color = Colors.transparent;
  }

  String getToFb(String name) {
    String a = "";
    usersRef
        .orderByKey()
        .equalTo(widget.uid)
        .once()
        .then((DataSnapshot snapshot) {
      // print('Data : ${snapshot.value}');
      // print(snapshot.value[widget.uid][name]);
      a = (snapshot.value[widget.uid][name]);
      return (snapshot.value[widget.uid][name]);
      // for (DataSnapshot ds in snapshot.value.child()) {
      //   username = ds.value.child("username").getValue(String);
      // }
    });
    print('teste: $a');
    return a;
  }

  _shareAction(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
        "This is the https://github.com/lucascapucho/mobile of the project",
        subject: "Share the git project",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
                  Text(getToFb("email"), style: TextStyle(color: Colors.white)),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(widget.uid)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("My notes", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotePage(widget.uid)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title:
                  Text("Global notes", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedPage(widget.uid)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.share, color: Colors.white),
              title: Text("Share", style: TextStyle(color: Colors.white)),
              onTap: () {
                _shareAction(context);
              },
            ),
            new ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text("Log out", style: TextStyle(color: Colors.white)),
              onTap: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomePage(title: "Welcome")),
                      (Route<dynamic> route) => false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
