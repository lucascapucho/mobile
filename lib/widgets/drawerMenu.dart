import 'dart:io';
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
  String user = "  ";
  String email = "";

  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child("Users");

  @override
  void initState() {
    super.initState();
    _getToFb("username");
    _getToFb("email");
  }

  // Get username and password from firebase database
  Future<void> _getToFb(String name) async {
    userRef
        .orderByKey()
        .equalTo(widget.uid)
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        if (name == "username") {
          user = (snapshot.value[widget.uid][name]);
        } else {
          email = (snapshot.value[widget.uid][name]);
        }
      });
    });
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
    if (user == "  " && email == "") {
      sleep(const Duration(milliseconds: 80));
    }

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
              accountEmail: Text(email, style: TextStyle(color: Colors.white)),
              accountName: Text(user, style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(user.substring(0, 2),
                    style: TextStyle(color: Color(0xffe46b10))),
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
